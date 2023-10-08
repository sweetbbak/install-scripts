#!/usr/bin/python3

from collections import defaultdict
from typing import List
from serde import Model, fields
import json, yaml, os, time, asyncio, aiohttp, async_timeout, copy

CONFIG_DIR = f"{os.environ['HOME']}/.config/youtube/"
QUEUE_FILE = f"{CONFIG_DIR}youtube.json"
SUBS_FILE = f"{CONFIG_DIR}subs.yml"


class Sub(Model):
    name: fields.Str()
    id: fields.Str()
    rank: fields.Int()
    filter: fields.Optional(fields.Str)
    res: fields.Optional(fields.Int)


def dump_queue(Q):
    with open(QUEUE_FILE, "w") as out:
        json.dump(Q, out, indent=2)
        out.flush()
        os.fsync(out.fileno())


def read_queue():
    return json.load(open(QUEUE_FILE))


def get_subs() -> List[Sub]:
    return [Sub.from_dict(s) for s in yaml.safe_load(open(SUBS_FILE))]


def set_subs(subs: List[Sub]):
    with open(SUBS_FILE, "w") as out:
        yaml.dump([s.to_dict() for s in subs], out)


async def fetch(session, url):
    async with async_timeout.timeout(5):
        async with await session.get(url) as resp:
            return await resp.text()


async def get_vids_from_sub(session, sub: Sub, from_time):
    import feedparser, time, html
    url = "https://www.youtube.com/feeds/videos.xml?channel_id=" + sub.id
    feed = feedparser.parse(await fetch(session, url))
    new_vids = []
    for entry in feed.entries:
        try:
            pub_time = time.mktime(entry["published_parsed"])
        except:
            pub_time = time.time()
        if pub_time > from_time:
            new_vids.append({
                "channel": sub.name,
                "channel_id": sub.id,
                "title": html.unescape(entry["title"]),
                "link": entry["link"],
                "time": pub_time,
            })
    return new_vids


async def get_duration(session, url):
    # Naive processing without BS
    body = await fetch(session, url)
    lines = body.split("\n")
    for line in lines:
        prop_ind = line.find('itemprop="duration"')
        if prop_ind != -1:
            start = line.find("PT", prop_ind) + 2
            end = line.find("S", start)
            time = line[start:end].split("M")
            time = int(time[0]) * 60 + int(time[1])
            return time
    return 0xAA


def parse_time(s):
    start = s.find("PT") + 2
    end = s.find("S", start)
    time = s[start:end].split("M")
    time = int(time[0]) * 60 + int(time[1])
    return time


def get_info(url):
    # Naive processing without BS
    from yt_dlp import YoutubeDL
    opts = {"quiet": True, "no_warnings": True}
    with YoutubeDL(opts) as ydl:
        info = ydl.extract_info(url, download=False)
        return {
            "channel": info["channel"],
            "title": info["title"],
            "channel_id": info["channel_id"],
            "link": url,
            "time": time.time(),
            "duration": info["duration"],
        }


def id_from_url(url):
    from urllib.parse import urlparse, parse_qs
    url = urlparse(url)
    if url.hostname == None:
        return
    if url.hostname == "youtu.be":
        return url.path
    if url.hostname.endswith("youtube.com"):
        return parse_qs(url.query)["v"][0]


def thumbnail_path(id):
    return f"{CONFIG_DIR}thumbs/{id}.jpg"


def rm_thumb(id):
    path = thumbnail_path(id)
    if os.path.exists(path):
        os.remove(path)


async def download_thumbnail(session, url):
    id = id_from_url(url)
    with open(thumbnail_path(id), "wb") as out:
        async with async_timeout.timeout(5):
            async with await session.get(f"https://i1.ytimg.com/vi/{id}/hq720.jpg") as resp:
                if resp.status == 404:
                    async with await session.get(f"https://i.ytimg.com/vi/{id}/hqdefault.jpg") as resp:
                        out.write(await resp.read())
                else:
                    out.write(await resp.read())


async def renew_queue():
    Q = read_queue()
    last_fetch = Q["fetch_time"] if "fetch_time" in Q else 0
    new_fetch = time.time() + time.timezone
    new_vids = []
    subs = get_subs()
    print("Fetching subscribers...")
    async with aiohttp.ClientSession() as session:
        tasks = [get_vids_from_sub(session, sub, last_fetch) for sub in subs]
        new = await asyncio.gather(*tasks)
    old_vids = Q["videos"] if "videos" in Q else []
    new_vids = [v for n in new for v in n]
    filtered_old_vids = [o for o in old_vids if all(n["link"] != o["link"] for n in new_vids)]
    print()
    print(f"Added {len(new_vids)} videos to queue")
    print(f"Getting durations...")
    async with aiohttp.ClientSession() as session:
        await asyncio.gather(*[download_thumbnail(session, v["link"]) for v in new_vids])
        durations = await asyncio.gather(*[get_duration(session, v["link"]) for v in new_vids])
        for i in range(len(new_vids)):
            new_vids[i]["duration"] = durations[i]
    ranks = {sub.name: sub.rank for sub in subs}
    Q["fetch_time"] = new_fetch
    filters = {sub.name: sub.filter for sub in subs if sub.filter}


    def eval_filter(f: str, v: dict) -> bool:
        v["now"] = time.time()
        return eval(f, copy.deepcopy(v))
    videos = [v for v in filtered_old_vids + new_vids if v["channel"] not in filters or eval_filter(filters[v["channel"]], v)]
    Q["videos"] = list(reversed(sorted(videos, key=lambda v:(ranks.get(v["channel"], 100), v["time"], v["channel"]))))
    dump_queue(Q)
    print()


async def add_vid(args):
    link = args.link
    Q = read_queue()
    async with aiohttp.ClientSession() as session:
        info = get_info(link)
        await download_thumbnail(session, link)
    if info:
        Q["videos"].insert(0, info)
    dump_queue(Q)


def list_videos():
    print("{:20}{:80}{}".format("Channel", "Title", "Time"))
    for vid in json.load(open(QUEUE_FILE))["videos"]:
        print("{:20}{:80}{}".format(vid["channel"], vid["title"], time.ctime(vid["time"])))


def get_entry_line(v, channel_width):
    return "\b".join([
        f"{'W ' if 'watched' in v else '  '}{v['channel']:{channel_width}}{v['title']}",
        v["link"],
    ])


def fzf_get_lines():
    Q = read_queue()
    videos = Q["videos"]
    filtered = []
    chans = defaultdict(int)
    for v in videos:
        chan = v["channel"]
        chans[chan] += 1
        if chans[chan] <= 3:
            filtered.append(v)
    channel_width = max(map(lambda v:len(v["channel"]), filtered)) + 2
    fzf_lines = [f"W {'Channel':{channel_width}}Title"]
    fzf_lines.extend(get_entry_line(v, channel_width) for v in filtered)
    return "\n".join(fzf_lines)


def fzf_get_lines_cmd(args):
    print(fzf_get_lines())


async def play_queue():
    from subprocess import Popen, PIPE, DEVNULL
    import os, threading
    import ueberzug.lib.v0 as ueberzug
    link_fifo = f"{CONFIG_DIR}link_fifo.{os.getpid()}"
    preview_fifo = f"{CONFIG_DIR}preview_fifo.{os.getpid()}"
    os.mkfifo(link_fifo)
    os.mkfifo(preview_fifo)

    def render_dur(dur):
        def render_lower(dur):
            return f"{dur//60:02}:{dur%60:02}"
        if dur < 3600:
            return render_lower(dur)
        return str(int(dur // 3600)) + ":" + render_lower(dur % 3600)

    def preview_task(_link_fifo, _preview_fifo):
        import textwrap
        space = " " * 37
        with ueberzug.Canvas() as c:
            uz = c.create_placement('youtube-preview', x=0, y=1, max_height=8)
            while True:
                with open(_link_fifo) as link_fifo:
                    for link in link_fifo:
                        id = id_from_url(link.strip())
                        vids = [v for v in read_queue()["videos"] if id in v["link"]]
                        if len(vids) == 1:
                            vid = vids[0]
                            duration = vid["duration"]
                            preview_lines = [
                                f"Channel: {vid['channel']}",
                                f"Title: {vid['title']}",
                                f"Publish Time: {time.ctime(vid['time'])}",
                                f"Length: {render_dur(duration)}",
                                f"Watched: {render_dur(vid['watched'])}" if "watched" in vid else "",
                            ]
                            preview_lines = [w + "\n"
                                             for l in preview_lines
                                             for w in textwrap.wrap(l, width=87 - 4, initial_indent=space, subsequent_indent=space)]
                            preview_lines = preview_lines[:7]
                            preview_lines.extend((7 - len(preview_lines)) * ["\n"])
                            uz.path = thumbnail_path(id)
                            uz.visibility = ueberzug.Visibility.VISIBLE
                            with open(_preview_fifo, "w") as preview_fifo:
                                preview_fifo.write("".join(preview_lines))
                        else:
                            with open(_preview_fifo, "w") as preview_fifo:
                                preview_fifo.write("")
    threading.Thread(target=preview_task, args=(link_fifo, preview_fifo), daemon=True).start()
    while True:
        fzf_input = fzf_get_lines()
        fzf_binds = [
            ("ctrl-f", "page-down"),
            ("ctrl-b", "page-up"),
            ("ctrl-r", "reload(youtube.py fzf-lines)"),
            ("?", "execute(less {f})"),
        ]
        fzf_opts = [
            "-e",   # --exact
            # "-s",
            # "--no-clear",
            "-m",   # --multi
            "--reverse",
            "--header-lines=1",
            "-d \b",  # --delimiter
            "--with-nth=1",
            "--expect=del,enter,esc,ctrl-a,ctrl-x",
            "--info=inline",
            f"--preview='echo {{2}} >> {link_fifo} && head -n7 {preview_fifo}'",
            "--preview-window=up:7:wrap",
        ]
        fzf_opts.append("--bind='" + ",".join(f"{k}:{a}" for k, a in fzf_binds) + "'")
        fzf_cmd = f"fzf {' '.join(fzf_opts)}"
        fzf = Popen(fzf_cmd, stdin=PIPE, stdout=PIPE, shell=True)
        fzf.stdin.write(bytes(fzf_input, "utf8"))
        fzf.stdin.close()
        results = fzf.stdout.readlines()
        if len(results) == 0:
            break
        key = results.pop(0)[:-1].decode("utf8")
        for i, line in enumerate(results):
            results[i] = line[:-1].split(b"\b")[1].decode("utf8")
        if key == "del":
            Q = read_queue()
            Q["videos"] = list(filter(lambda v:v["link"] not in results, Q["videos"]))
            for link in results:
                id = id_from_url(link)
                rm_thumb(id)
            dump_queue(Q)
        elif key == "ctrl-c":
            break
        elif key == "esc":
            await renew_queue()
        elif key == "ctrl-a":
            subs = get_subs()
            for link in results:
                channel_id = list(filter(lambda v:v["link"] == link, read_queue()["videos"]))[0]["channel_id"]
                for sub in subs:
                    if sub.id == channel_id:
                        sub.rank += 1
                        break
            set_subs(subs)
        elif key == "ctrl-x":
            subs = get_subs()
            for link in results:
                channel_id = list(filter(lambda v:v["link"] == link, read_queue()["videos"]))[0]["channel_id"]
                for sub in subs:
                    if sub.id == channel_id:
                        sub.rank -= 1
                        break
            set_subs(subs)
        else:   # enter
            # os.system("tput rmcup")
            Q = read_queue()
            print(f"Playing: {results[0]}")
            cookies = os.path.expanduser("~/.config/youtube/cookie.txt")
            vid = [v for v in Q["videos"] if v["link"] == results[0]][0]
            sub = [s for s in get_subs() if s.id == vid["channel_id"]][0]
            res = sub.res if sub.res != None else 1080
            proc = Popen(
                [ "mpv"
                , "--script-opts=ytdl_hook-ytdl_path=yt-dlp"
                , f'--ytdl-format=bestvideo[height<={res}]+bestaudio/best[height<={res}]'
                , f"--ytdl-raw-options=external-downloader=aria2c,throttled-rate=300k,cookies={cookies},mark-watched="
                ] + results, stdout=None, stdin=DEVNULL)
            proc.wait()
            time.sleep(0.5)
    # os.system("tput rmcup")
    os.remove(link_fifo)
    os.remove(preview_fifo)


def watched_video(args):
    # from glob import glob
    Q = read_queue()
    id = id_from_url(args.link)
    if id == None:
        return
    if args.finished:
        Q["videos"] = list(filter(lambda v:v["link"] != args.link, Q["videos"]))
        rm_thumb(id)
        # for file in glob(f"{CONFIG_DIR}{id}.*"):
        #     os.remove(file)
    else:
        if args.time != "":
            for i, video in enumerate(Q["videos"]):
                if video["link"] == args.link:
                    Q["videos"][i]["watched"] = int(float(args.time))
                    break
            else:
                video = get_info(args.link)
                video["watched"] = int(float(args.time))
                Q["videos"].insert(0, video)
    dump_queue(Q)
    # pprint.pp(read_queue())


async def sub_with_vid(args):
    from yt_dlp import YoutubeDL
    subs = get_subs()
    opts = {"quiet": True, "no_warnings": True}
    with YoutubeDL(opts) as ydl:
        info = ydl.extract_info(args.link, download=False)
        assert info != None, f"Can't find video {args.link}"
        subs.append(Sub(id=info["channel_id"], name=info["channel"], rank=args.rank))
        set_subs(subs)


async def main():
    await renew_queue()
    await play_queue()

if __name__ == "__main__":
    import sys
    from argparse import ArgumentParser
    parser = ArgumentParser()
    parser.set_defaults(func=lambda _: asyncio.run(main()))
    sub_parsers = parser.add_subparsers()
    add_cmd = sub_parsers.add_parser("add")
    add_cmd.add_argument("link")
    add_cmd.set_defaults(func=lambda args: asyncio.run(add_vid(args)))
    mpv_watch_cmd = sub_parsers.add_parser("mpv_watched")
    mpv_watch_cmd.set_defaults(func=watched_video, finished=True)
    mpv_watch_cmd.add_argument("link")
    mpv_Watch_cmd = sub_parsers.add_parser("mpv_Watched")
    mpv_Watch_cmd.set_defaults(func=watched_video, finished=False)
    mpv_Watch_cmd.add_argument("link")
    mpv_Watch_cmd.add_argument("time")
    fzf_cmd = sub_parsers.add_parser("fzf-lines")
    fzf_cmd.set_defaults(func=fzf_get_lines_cmd)
    sub_cmd = sub_parsers.add_parser("sub")
    sub_cmd.add_argument("link")
    sub_cmd.add_argument("-r", "--rank", type=int, default=5, required=False)
    sub_cmd.set_defaults(func=lambda args: asyncio.run(sub_with_vid(args)))

    match = parser.parse_args()
    match.func(match)

#-*- coding: utf-8 -*-
from __future__ import print_function
import re
import requests
import yaml
from bs4 import BeautifulSoup
from subprocess import call
import curses, os
import locale
import threading

# Init locale
locale.setlocale(locale.LC_ALL, '')

# Support python 2 and 3
try: input = raw_input
except NameError: pass

class WpConfig:
    FILE_PATH = os.path.expanduser('~/.wpconfig')
    RESOLUTION = {'key': 'resolution', 'default': '3360x2100'}
    WP_DIR = {'key': 'save-dir', 'default': '~/'}

    def __init__(self):
        try:
            with open(WpConfig.FILE_PATH) as config_file:
                config = yaml.load(config_file)

            self.resolution = config[WpConfig.RESOLUTION['key']]
            self.save_dir = os.path.expanduser(config[WpConfig.WP_DIR['key']])
        except (TypeError, IOError, KeyError):
            self._create_config()

    def _create_config(self):
        print('Config will be saved to {}'.format(WpConfig.FILE_PATH))
        # Get save dir
        save_dir = input('\nDirectory to save wallpapers [{}]: '.format(WpConfig.WP_DIR['default']))
        self.save_dir = os.path.expanduser(save_dir if save_dir else WpConfig.WP_DIR['default'])
        # Get resolution
        resolution = input('\nWallpaper resolution [{}]: '.format(WpConfig.RESOLUTION['default']))
        self.resolution = resolution if resolution else WpConfig.RESOLUTION['default']
        # Create config
        config = {
            WpConfig.WP_DIR['key']: self.save_dir,
            WpConfig.RESOLUTION['key']: self.resolution,
        }
        with open(WpConfig.FILE_PATH, 'w') as config_file:
            yaml.dump(config, config_file)
        print('\nConfig successfully saved to {}'.format(WpConfig.FILE_PATH))
        input('\nPress ENTER to continue...')


class WallpaperDL:
    MENU = "menu"
    COMMAND = "command"
    ST_EXIT = 'exit'
    ST_PREV = 'prev'
    ST_NEXT = 'next'
    ST_DEL = 'delete'
    ST_EXEC = 'exec'
    DOMAIN = 'https://interfacelift.com'
    SAVED_TEXT = ' (saved)'
    DOWNLOAD_CHUNK = 512 * 1024
    INITIAL_PAGE = 1
    INSTRUCTIONS = 'Controls: \'↑ ↓ ← →\' rows/pages, \'ENTER\' save/preview, \'BACKSPACE\' delete, \'Q/ESC\' quit'

    def __init__(self):
        # Get config first
        self.config = WpConfig()

        # Screen and curses setup
        self.screen = curses.initscr()
        curses.noecho()
        curses.cbreak()
        curses.start_color()
        self.screen.keypad(1)
        curses.curs_set(0)

        # Colors on screen
        curses.init_pair(1, curses.COLOR_BLACK, curses.COLOR_WHITE)
        self.h_color = curses.color_pair(1)
        self.n_color = curses.A_NORMAL

        # Menu data
        self.curr_pos = 0
        self.curr_page = WallpaperDL.INITIAL_PAGE
        self.menu_data = self.get_menu_data()

        # Start running
        self.run()

        # Stop if exit
        curses.endwin()
        os.system('clear')

    def get_command(self, title, command):
        return {'title': title, 'type': WallpaperDL.COMMAND, 'command': command}

    def get_menu(self, title, subtitle, options):
        return { 'title': title, 'type': WallpaperDL.MENU, 'subtitle': subtitle, 'options': options}

    def parse_container(self, wp_container):
        return {
            'title': wp_container.find('h1').find('a').text,
            'url': wp_container.find('div', id=re.compile('^download_')).find('a')['href']
        }

    def get_parsed_wps(self, url):
        page = requests.get(url)
        soup = BeautifulSoup(page.content, 'html.parser')
        wp_containers = soup.find_all('div', id=re.compile('^list_'))
        return map(self.parse_container, wp_containers)

    def get_item_text(self, index):
        return "{number} - {title}".format(
            number=(self.curr_page - 1) * len(self.menu_data['options']) + index + 1,
            title=self.menu_data['options'][index]['title']
        )

    def download(self, url, filepath, pos, title):
        with open(filepath, 'wb') as handle:
            res = requests.get(url, stream=True)
            i = 0
            total_length = int(res.headers.get('content-length'))
            for block in res.iter_content(WallpaperDL.DOWNLOAD_CHUNK):
                if not block:
                    break

                # Render percentage if same item on screen
                if title == self.menu_data['options'][pos]['title']:
                    text = "{text} ({percent:.0f}%)".format(
                        text=self.get_item_text(pos),
                        percent=i * 1.0 * WallpaperDL.DOWNLOAD_CHUNK / total_length * 100
                    )
                    self.screen.addstr(pos + 9, 4, text, self.n_color)
                    self.screen.refresh()
                    i += 1

                handle.write(block)

        if title == self.menu_data['options'][pos]['title']:
            self.menu_data['options'][pos]['title'] += WallpaperDL.SAVED_TEXT
            self.screen.addstr(pos + 9, 4, self.get_item_text(pos), self.n_color)
            self.screen.refresh()

    def generate_parsed_command(self, parsed_item):
        dl_path = os.path.join(self.config.save_dir, parsed_item['url'].split('/')[-1])
        text = '{}{}'.format(str(parsed_item['title']),
                             WallpaperDL.SAVED_TEXT if os.path.isfile(dl_path) else '')
        return {
            'title': text,
            'type': WallpaperDL.COMMAND,
            'url': WallpaperDL.DOMAIN + parsed_item['url'],
            'dl_path': dl_path
        }

    def get_menu_data(self):
        parsed = self.get_parsed_wps(
            'https://interfacelift.com/wallpaper/downloads/date/widescreen/{}/index{}.html'.format(
                self.config.resolution, self.curr_page
            )
        )
        return self.get_menu('Download Wallpaper', 'Wallpapers', list(map(self.generate_parsed_command, parsed)))

    def run_menu(self):
        option_count = len(self.menu_data['options'])  # how many options in this menu
        old_pos = 0

        self.screen.border(0)
        self.screen.addstr(2, 2, self.menu_data['title'], curses.A_STANDOUT)
        self.screen.addstr(4, 2, 'Resolution: \'{}\', Saving in: \'{}\''.format(
            self.config.resolution,
            self.config.save_dir
        ), curses.A_BOLD)
        self.screen.addstr(6, 2, WallpaperDL.INSTRUCTIONS)
        self.screen.addstr(8, 2, 'Page {} - {}'.format(
            self.curr_page,
            self.menu_data['subtitle']
        ), curses.A_BOLD)

        for index in range(option_count):
            textstyle = self.h_color if self.curr_pos == index else self.n_color
            self.screen.addstr(9 + index, 4, self.get_item_text(index), textstyle)
            self.screen.clrtoeol()

        # Loop until return key is pressed
        while True:
            if self.curr_pos != old_pos:
                self.screen.addstr(9 + old_pos, 4, self.get_item_text(old_pos), self.n_color)
                old_pos = self.curr_pos
                self.screen.addstr(9 + self.curr_pos, 4, self.get_item_text(self.curr_pos), self.h_color)

            x = self.screen.getch()  # Gets user input

            # What is user input?
            if x == 258:  # down arrow
                self.curr_pos = (self.curr_pos + 1) % option_count
            elif x == 259:  # up arrow
                self.curr_pos = (self.curr_pos - 1) % option_count
            elif x == 260:  # left arrow
                status = WallpaperDL.ST_PREV
                break
            elif x == 261:  # right arrow
                status = WallpaperDL.ST_NEXT
                break
            elif x == ord('\n'):
                status = WallpaperDL.ST_EXEC
                break
            elif x == ord('q') or x == 27:  # q or esc pressed
                status = WallpaperDL.ST_EXIT
                break
            elif x == 127:
                status = WallpaperDL.ST_DEL
                break

        return status

    def run(self):
        while True:
            status = self.run_menu()
            if status == WallpaperDL.ST_EXIT:
                break
            elif status == WallpaperDL.ST_PREV:
                if self.curr_page > WallpaperDL.INITIAL_PAGE:
                    self.curr_page -= 1
                    self.menu_data = self.get_menu_data()
            elif status == WallpaperDL.ST_NEXT:
                self.curr_page += 1
                self.menu_data = self.get_menu_data()
            else:
                menu_link = self.menu_data['options'][self.curr_pos]
                dl_path = menu_link['dl_path']
                if status == WallpaperDL.ST_EXEC:
                    dl_url = menu_link['url']
                    if menu_link['title'].endswith(WallpaperDL.SAVED_TEXT):
                        with open(os.devnull, 'w') as devnull:
                          call('qlmanage -p {}'.format(dl_path).split(' '), stdout=devnull, stderr=devnull)
                    else:
                        download_thread = threading.Thread(
                            target=self.download,
                            args=(dl_url, dl_path, self.curr_pos, menu_link['title'])
                        )
                        download_thread.start()
                elif status == WallpaperDL.ST_DEL and menu_link['title'].endswith(WallpaperDL.SAVED_TEXT):
                    os.remove(dl_path)
                    menu_link['title'] = menu_link['title'][:-len(WallpaperDL.SAVED_TEXT)]


def main():
    # Run wallpaper cli
    WallpaperDL()


main()

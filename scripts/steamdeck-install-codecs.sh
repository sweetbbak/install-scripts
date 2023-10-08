#!/bin/bash
# re-enable mesa driver video decoding components
# with h264/h265 enabled
# to manually extract:
# tar --use-compress-program=unzstd -xvf

echo -e "Install h265/h265 codecs for steamdeck?\n(y/n) "
read -rN1 key
echo

case "${key}" in
    y|Y) pass ;;
    *) echo -e '\nThis script is to install video codecs on steamdeck only...' ; exit 0 ;;
esac

url0="https://cdn.discordapp.com/attachments/865651345083203644/1042194220968067162/libva-mesa-driver-22.2.0.157819.radeonsi_3.4.0-3-x86_64.pkg.tar.zst?ex=6519e901&is=65189781&hm=c67d420c743ff7b4147641513a1f53a1547355ad38a736af5599ee3637e78a9f&"
url1="https://cdn.discordapp.com/attachments/865651345083203644/1042194220590567464/mesa-vdpau-22.2.0.157819.radeonsi_3.4.0-3-x86_64.pkg.tar.zst?ex=6519e901&is=65189781&hm=885beb23f89291b2d82b5e494c98c958860edd252728ac215bfc6870456f07d1&"
url2="https://cdn.discordapp.com/attachments/865651345083203644/1042194221374902323/lib32-mesa-vdpau-22.2.0.157819.radeonsi_3.4.0-3-x86_64.pkg.tar.zst?ex=6519e901&is=65189781&hm=cef89b292fd29bbb3fc5d9e140a24a15c6d5cefa1e398c8bd265dbf7ed8ade83&"
url3="https://cdn.discordapp.com/attachments/865651345083203644/1042194221727232050/lib32-libva-mesa-driver-22.2.0.157819.radeonsi_3.4.0-3-x86_64.pkg.tar.zst?ex=6519e901&is=65189781&hm=d7d0ea961d23841d9ce0ba6b25863749b55793970f40253f5a5e6bcbe17e83c8&"

wget "${url0}" -O libva-mesa-driver-22.2.0.157819.radeonsi_3.4.0-3-x86_64.pkg.tar.zst
wget "${url1}" -O mesa-vdpau-22.2.0.157819.radeonsi_3.4.0-3-x86_64.pkg.tar.zst
wget "${url2}" -O lib32-mesa-vdpau-22.2.0.157819.radeonsi_3.4.0-3-x86_64.pkg.tar.zst
wget "${url3}" -O lib32-libva-mesa-driver-22.2.0.157819.radeonsi_3.4.0-3-x86_64.pkg.tar.zst

sudo steamos-readonly disable
sudo pacman -U mesa-vdpau-22.2.0.157819.radeonsi_3.4.0-3-x86_64.pkg.tar.zst libva-mesa-driver-22.2.0.157819.radeonsi_3.4.0-3-x86_64.pkg.tar.zst lib32-mesa-vdpau-22.2.0.157819.radeonsi_3.4.0-3-x86_64.pkg.tar.zst lib32-libva-mesa-driver-22.2.0.157819.radeonsi_3.4.0-3-x86_64.pkg.tar.zst
sudo steamos-readonly enable

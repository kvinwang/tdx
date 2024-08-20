#!/bin/sh
mkinitramfs -v -d config -o initrd.img 6.8.0-40-generic
cp initrd.img ../canonical-tdx/guest-tools/

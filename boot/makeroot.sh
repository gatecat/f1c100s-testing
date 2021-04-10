#!/usr/bin/env bash
set -ex
tmp_dir=$(mktemp -d)
cp ../init/target/armv5te-unknown-linux-musleabi/release/init ../rootfs/bin
genext2fs -d ../rootfs -b 4096 ${tmp_dir}/initrd
gzip -9 ${tmp_dir}/initrd
mkimage -A arm -T ramdisk -C none -n uInitrd -d ${tmp_dir}/initrd.gz initrd.img
rm -rf ${tmp_dir}

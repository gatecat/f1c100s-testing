#!/usr/bin/env bash
# Usage boot.sh <u-boot> <kernel> <fdt>

set -ex
tmp_dir=$(mktemp -d)
cat > ${tmp_dir}/boot.cmd <<EOT
setenv bootargs console=ttyS0,115200
bootm 0x80500000 - 0x80C00000
EOT

mkimage -C none -A arm -T script -d ${tmp_dir}/boot.cmd ${tmp_dir}/boot.scr

sunxi-fel -p -v uboot $1 \
             write 0x80500000 $2 \
             write 0x80C00000 $3 \
             write 0x80C50000 ${tmp_dir}/boot.scr
rm -rf ${tmp_dir}

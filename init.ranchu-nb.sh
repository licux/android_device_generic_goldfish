#!/system/bin/sh

#
# Houdini integration (Native Bridge)
#
houdini_bin=0
dest_dir=/system/lib$1/arm$1
binfmt_misc_dir=/proc/sys/fs/binfmt_misc

# this is to add the supported binary formats via binfmt_misc

if [ ! -e $binfmt_misc_dir/register ]; then
	mount -t binfmt_misc none $binfmt_misc_dir
fi

cd $binfmt_misc_dir
if [ -e register ]; then
	[ -e /system/bin/houdini$1 ] && dest_dir=/system/bin
	# register Houdini for arm binaries
	if [ -z "$1" ]; then
		echo ':arm_exe:M::\\x7f\\x45\\x4c\\x46\\x01\\x01\\x01\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x02\\x00\\x28::'"$dest_dir/houdini:P" > register
		echo ':arm_dyn:M::\\x7f\\x45\\x4c\\x46\\x01\\x01\\x01\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x03\\x00\\x28::'"$dest_dir/houdini:P" > register
	else
		echo ':arm64_exe:M::\\x7f\\x45\\x4c\\x46\\x02\\x01\\x01\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x02\\x00\\xb7::'"$dest_dir/houdini64:P" > register
		echo ':arm64_dyn:M::\\x7f\\x45\\x4c\\x46\\x02\\x01\\x01\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x03\\x00\\xb7::'"$dest_dir/houdini64:P" > register
	fi
	if [ -e arm${1}_exe ]; then
		houdini_bin=1
	fi
else
	log -pe -thoudini "No binfmt_misc support"
fi

if [ $houdini_bin -eq 0 ]; then
	log -pe -thoudini "houdini$1 enabling failed!"
else
	log -pi -thoudini "houdini$1 enabled"
    
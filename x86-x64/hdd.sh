#!/usr/bin/env bash

echoerr() { 
    printf "\033[1;31m$1\033[0m" 
}
echoinfo() { 
    printf "\033[1;32m$1\033[0m"
}
echowarn() { 
    printf "\033[1;33m$1\033[0m"
}

vgreduce BonusVolGroup --removemissing --force
#获取系统盘符，应对系统盘不是sda的情况
root_type=$(lsblk -ar 2>>/dev/null | grep -w "/" | awk '{print $(NF-1)}')
root_name=$(lsblk -ar 2>>/dev/null | grep -w "/" | awk '{print $1}')
root_disk=""
if [[ x"${root_type}" == x"lvm" ]]; then
    root_vg_name=$(echo ${root_name} | awk -F- '{print $1}')
    root_disk=$(pvs 2>>/dev/null | grep "${root_vg_name}" | awk '{print $1}' | sed 's/[0-9]//;s/\/dev\///')
else
    root_disk=$(lsblk -ar 2>>/dev/null | grep -w "/" | awk '{print $1}' | sed 's/[0-9]//')
fi

if [[ -z "${root_disk}" ]]; then
    echoerr "Can't find the root disk, exit"
    exit 1
else
    echoinfo "/dev/${root_disk} "
	printf "is the root disk."
fi
printf "\n"

for sd in $(ls /dev/* | grep -E '((sd)|(vd)|(hd)|(nvme))[a-z]$' | grep -v "$root_disk" ); do
	pv_have=$(pvs 2>/dev/null | grep -q "${sd}" ;echo $?)
    vg_have=$(pvs 2>/dev/null | grep "${sd}" | grep -q "BonusVolGroup" ;echo $?)

	if [[ ${pv_have} == 0 && ${vg_have} == 0 ]]; then 
	    echoinfo "${sd} "
		printf "Already done, skip! \n"
		continue
	fi
	#清除磁盘残留信息，防止不能做lvm
	wipefs -a ${sd}
	pvcreate ${sd}
	vgcreate BonusVolGroup ${sd}
	vgextend BonusVolGroup ${sd}
done

echowarn "\nTotal cache space: "
free_space=$(vgdisplay | grep 'VG Size' | awk '{print $3,$4}' | sed -r 's/\i//g')
echoinfo "${free_space} \n"
for sd in $(ls /dev/* | grep -E '((sd)|(vd)|(hd)|(nvme))[a-z]$' | grep -v "$root_disk" ); do
	pv_have=$(pvs 2>/dev/null | grep -q "${sd}" ;echo $?)
    vg_have=$(pvs 2>/dev/null | grep "${sd}" | grep -q "BonusVolGroup" ;echo $?)
	echoinfo "${sd} "
	if [[ ${pv_have} == 0 && ${vg_have} == 0 ]]; then
	    printf "is already in the VG Group. \n"
	else 
	    echoerr "is not in the VG Group! \n"
	fi
done
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

for sd in $(fdisk -l | grep -E 'Disk /dev/((sd)|(vd)|(hd))' | sed 's/Disk //g' | sed 's/\://g' | awk '{print $1}' | sort); do
	pv_have=$(pvs 2>/dev/null | grep -q "${sd}" ;echo $?)
    vg_have=$(pvs 2>/dev/null | grep "${sd}" | grep -q "BonusVolGroup" ;echo $?)

	if [[ ${pv_have} == 0 && ${vg_have} == 0 ]]; then 
	    echoinfo "${sd} "
		printf "Already done, skip! \n"
		continue
	fi
	#清除磁盘残留信息，防止不能做lvm
	wipefs -a ${sd} 2>/dev/null
	pvcreate ${sd} 2>/dev/null
	vgcreate BonusVolGroup ${sd} 2>/dev/null
	vgextend BonusVolGroup ${sd} 2>/dev/null
done

echowarn "\nTotal cache space: "
free_space=$(vgdisplay | grep 'VG Size' | awk '{print $3,$4}' | sed -r 's/\i//g')
echoinfo "${free_space} \n"
for sd in $(fdisk -l | grep -E 'Disk /dev/((sd)|(vd)|(hd))' | sed 's/Disk //g' | sed 's/\://g' | awk '{print $1}' | sort); do
	pv_have=$(pvs 2>/dev/null | grep -q "${sd}" ;echo $?)
    vg_have=$(pvs 2>/dev/null | grep "${sd}" | grep -q "BonusVolGroup" ;echo $?)
	echowarn "${sd} "
	if [[ ${pv_have} == 0 && ${vg_have} == 0 ]]; then
	    echoinfo "is already in the VG Group. \n"
	else 
	    echoerr "is not in the VG Group! \n"
	fi
done
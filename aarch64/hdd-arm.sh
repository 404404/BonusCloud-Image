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

for sd in $(fdisk -l | grep -E 'Disk /dev/((sd)|(vd)|(hd))' | sed 's/Disk //g' | sed 's/\://g' | awk '{print $1}' | sort); do
	vg_have=$(pvs 2>/dev/null | grep "${sd}" | grep -q "BonusVolGroup" ;echo $?)
	echowarn "Now Processing / 正在处理： "
	echoinfo "${sd} \n"
	if [[ ${vg_have} == 0 ]]; then
	    printf "Detected that the disk has created a VG volume, do you need to format it? \n"
		echoerr "Formatting will clear all the data on the disk, please choose carefully. \n"
		printf "检测到该磁盘已创建VG卷，是否需要格式化？"
		echoerr "格式化将会清除该磁盘上所有的数据，请谨慎选择。默认N \n"
		read -r -p "[Y / Default N]:  " choose
		case ${choose} in
            Y|y|YES|YEs|YeS|yES|Yes|yEs|yeS|yes ) echo -e "o\nw\n" | fdisk ${sd} ;;
			* ) printf "Skip! \n" && continue ;;
        esac
	fi
	#清除磁盘残留信息，防止不能做lvm
	wipefs -a ${sd} 2>/dev/null
	pvcreate ${sd} 2>/dev/null
	vgcreate BonusVolGroup ${sd} 2>/dev/null
	vgextend BonusVolGroup ${sd} 2>/dev/null
done

vgreduce BonusVolGroup --removemissing --force

free_space=$(vgdisplay | grep 'VG Size' | awk '{print $3,$4}' | sed -r 's/\i//g')
if [[ ${free_space} > 101 ]]; then 
    echowarn "\nTotal cache space / 总可用缓存空间: "
	echoinfo "${free_space} \n"

	for sd in $(fdisk -l | grep -E 'Disk /dev/((sd)|(vd)|(hd))' | sed 's/Disk //g' | sed 's/\://g' | awk '{print $1}' | sort); do
	    pv_have=$(pvs 2>/dev/null | grep -q "${sd}" ;echo $?)
        vg_have=$(pvs 2>/dev/null | grep "${sd}" | grep -q "BonusVolGroup" ;echo $?)
	    echowarn "${sd} "
	    if [[ ${pv_have} == 0 && ${vg_have} == 0 ]]; then
	        echoinfo "is already in the VG volume. / 该磁盘已加入VG卷。 \n"
	    else 
	        echoerr "is not in the VG volume! Please try again! / 该磁盘未加入VG卷！请重试！ \n"
	    fi
    done
else
    echoerr "The available space is less than 100G, please replace the larger disk and try again! \n"
	echoerr "可用空间不足100G，请更换更大的磁盘后重试! \n"
fi

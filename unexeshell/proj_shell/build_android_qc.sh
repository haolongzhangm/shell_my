#!/bin/bash
#
#Target: This script and related configuration files are used to set up one framework for building android project and create the package daily for Qualcomm platform
#
#Author: Jason Jiao <song.jiao@ck-telecom.com>
#
#2014-07-08: Initial version
#
 
#==============Utilities=================
logD(){
    if [ 0 -eq 0 ] ;
    then
        echo $@
        echo
    fi
} 

#Read value from file which parameter is like "Name=Value"
readPara(){
    local __file_name=$1    
    local __para_name=$2

    local __para_value=`grep -w ${__para_name} ${__file_name}`
    __para_value=`echo $__para_value | awk -F "${__para_name}=" '{print $2}'`
    echo ${__para_value}
}

toUpper(){
	local __orig_string=$1
	
	local __new_string=`echo $__orig_string | tr '[a-z]' '[A-Z]'`

	echo ${__new_string}
}

toLower(){
	local __orig_string=$1
	
	local __new_string=`echo $__orig_string | tr '[A-Z]' '[a-z]'`

	echo ${__new_string}
}

buildProject(){
    local __project_name=$1

    local __product_name=$(readPara "${_work_dir_name}/${__project_name}.project" "PROJECT")

    local __project_id=$(readPara "${_work_dir_name}/${__project_name}.project" "PROJECT_ID")
    local __lunch_option=$(readPara "${_work_dir_name}/${__project_name}.project" "LUNCHOPTION")

    if [  -z $__project_id ];
    then
        logD "Project id is not specified, terminated."
	return 
    fi

    local __qc_branch_name=$(readPara "${_work_dir_name}/${__project_name}.project" "BRANCH_NAME")
    local __android_root_dir=$(readPara "${_work_dir_name}/${__project_name}.project" "ANDROIDROOTDIR")
    local __qc_root_dir=$(readPara "${_work_dir_name}/${__project_name}.project" "QCROOTDIR")
    local __qc_app_target=$(readPara "${_work_dir_name}/${__project_name}.project" "QCAPPTARGET")

    local __system_dir=$__android_root_dir/out/target/product/$__project_id/
    local __data_dir=$__android_root_dir/out/target/product/$__project_id/

    local __mail_list=$(readPara "${_work_dir_name}/${__project_name}.project" "MAILLIST")
    local __email_msg=$(readPara "${_work_dir_name}/${__project_name}.project" "EMAILMSG")

    local __appimg_file_list=$(readPara "${_work_dir_name}/${__project_name}.project" "APPIMGFILELIST")
    local __backup_file_list=$(readPara "${_work_dir_name}/${__project_name}.project" "BACKUPFILELIST")
    local __qcimg_file_list=$(readPara "${_work_dir_name}/${__project_name}.project" "QCIMGFILELIST")
    local __qmsct_file_list=$(readPara "${_work_dir_name}/${__project_name}.project" "QMSCTFILELIST")

    local __meta_file=$(readPara "${_work_dir_name}/${__project_name}.project" "META_FILE")
    local __cmd_build_mpss=$(readPara "${_work_dir_name}/${__project_name}.project" "CMD_BUILD_MPSS")
    local __cmd_build_bootimg=$(readPara "${_work_dir_name}/${__project_name}.project" "CMD_BUILD_BOOTIMG")
    local __cmd_create_cdt=$(readPara "${_work_dir_name}/${__project_name}.project" "CMD_CREATE_CDT")
    local __cmd_build_tz=$(readPara "${_work_dir_name}/${__project_name}.project" "CMD_BUILD_TZ")
    local __cmd_build_rpm=$(readPara "${_work_dir_name}/${__project_name}.project" "CMD_BUILD_RPM")

    local __building_options=$(readPara "${_work_dir_name}/${__project_name}.project" "BUILDING_OPTIONS")
    local __3rd_apk_path=$(readPara "${_work_dir_name}/${__project_name}.project" "APK_PATH")
    local __need_OTA=$(readPara "${_work_dir_name}/${__project_name}.project" "NEED_OTA")
    local __ota_package_prefix=$(readPara "${_work_dir_name}/${__project_name}.project" "OTA_PACKAGE_NAME_PREFIX")

    local __special_project=$(readPara "${_work_dir_name}/${__project_name}.project" "SPECIAL_PROJECT")


    #SSSS or DSDS or ...
    local __ssss_or_not=$(readPara "${_work_dir_name}/${__project_name}.project" "SSSS")
    __ssss_or_not=$(toUpper "${__ssss_or_not}")

    local __fsg_name=$(readPara "${_work_dir_name}/${__project_name}.project" "FSGNAME")

    local __splash_name=$(readPara "${_work_dir_name}/${__project_name}.project" "SPLASHNAME")

    local __ts=`date +%y%m%d`
    local __ts_long=`date +%y%m%d%H%M%S`
    
    local __package_name_prefix=$(readPara "${_work_dir_name}/${__project_name}.project" "PACKAGE_NAME_PREFIX")

    if [ "$__package_name_prefix" == "" ]
    then
        logD "__package_name_prefix= is null, please check the project file."
        exit -1;
    fi

    __package_name=${__package_name_prefix}_${__ts}.tar.gz
    __internal_version_number=${__package_name_prefix}_${__ts_long}
    __version_number=${__package_name_prefix}_${__ts}
    __package_dir_name=/tmp/${__package_name_prefix}_${__ts}
    __qmsct_dir_name=$__package_dir_name/IMAGES_FOR_QMSCT
    __ota_package_name=${__ota_package_prefix}_${__ts}
    logD "__package_name=${__package_name}"
    logD "__version_number=${__version_number}"
    logD "__internal_version_number=${__internal_version_number}"
    logD "__package_dir_name=${__package_dir_name}"
    logD "__ota_package_name=${__ota_package_name}"

    local __git_log_file="${_log_dir_name}/git_log_${__project_name}_${__ts}"
    local __build_log_file="${_log_dir_name}/build_log_${__project_name}_${__ts}"
    local __tar_log_file="${_log_dir_name}/tar_log_${__project_name}_${__ts}"
    local __msg_body_file="${_log_dir_name}/release_note_${__project_name}_${__ts}"

    if [ -d $__android_root_dir ] ;
    then
        logD "__android_root_dir="$__android_root_dir
        logD "__mail_list="$__mail_list
        logD "__appimg_file_list="$__appimg_file_list
        logD "__qcimg_file_list="$__qcimg_file_list
        logD "__qmsct_file_list="$__qmsct_file_list

        logD "__building_options="$__building_options
        logD "__git_log_file="$__git_log_file
        logD "__build_log_file="$__build_log_file
        logD "__tar_log_file="$__tar_log_file
        logD "__3rd_apk_path="$__3rd_apk_path
        logD "__need_OTA="$__need_OTA
        logD "__ota_package_prefix="$__ota_package_prefix
        
        
	cd $__qc_root_dir
	git checkout -f $__qc_branch_name
	git reset HEAD --hard
	git clean -dxf
	git pull
        if [ "$?" != "0" ];
          then
            echo "** git pull errors..."
            exit 1;
        fi

	cd -

        cd $__android_root_dir
	repo forall -c git reset HEAD --hard
	repo forall -c git clean -dxf
	repo sync -j8
        if [ "$?" != "0" ];
          then
            echo "** repo fetch errors..."
            exit 1;
        fi
	cd -
        

	#Copy QC proprietary source code in place
	rm -rf $__android_root_dir/vendor/qcom/proprietary  
	cp -rf $__qc_root_dir/LINUX/android/vendor/qcom/proprietary  $__android_root_dir/vendor/qcom/

	#Building QC proprieatory code
	#Refer to SP80-NL239-4_F_MSM8916_LA_SW_User_Manual_SPD.pdf
 	#Refer to SP80-NM846-4_F_MSM8936_MSM8939_LA_SW_User_Manual_SPD.pdf
	#.......................................

 	#Pre 3.3.7 make right meta file in place(backup original contents.xml first)
 	cd $__qc_root_dir
 	mv contents.xml contents.xml.backup
 	cp -rf $__meta_file contents.xml
 	cd -

        processor=`grep -i processor /proc/cpuinfo |wc -l`
 
	#3.3.2 Building MPSS
	cd $__qc_root_dir/modem_proc/build/ms
 	#sh build.sh 8916.gen.prod -k
 	eval "$__cmd_build_mpss -j$processor" 2>&1
	cd -

	#3.3.3 Building boot loaders
	cd $__qc_root_dir/boot_images/build/ms
 	#sh build.sh TARGET_FAMILY=8916 BUILD_ID=HAAAANAZ -j1
 	eval "$__cmd_build_bootimg" 2>&1
	cd -

	#3.3.3.1 Create your own CDT configuration binary
	cd $__qc_root_dir/boot_images/core/boot/secboot3/scripts
	#python cdt_generator.py xxx.xml cdt.bin
	eval "$__cmd_create_cdt" 2>&1
	cd -

	#3.3.4 Building TrustZone images
	cd $__qc_root_dir/trustzone_images/build/ms
 	#sh build.sh CHIPSET=msm8916 tz hyp sampleapp tzbsp_no_xpu playready widevine isdbtmm securitytest keymaster commonlib -j1
 	eval "$__cmd_build_tz" 2>&1
	cd -

	#3.3.5 Building RPM
	cd $__qc_root_dir/rpm_proc/build
 	#sh build_8916.sh -j1
 	eval "$__cmd_build_rpm" 2>&1
	cd -

	#3.3.6 Building WCNSS
	#TODO: Currently WCDNSS building will be failed

	#End of building QC proprieatory code

        #Follow new SCM process
	#If there is no SN in the project file then get the stream number from __package_name_prefix
        local __stream_number=$(readPara "${_work_dir_name}/${__project_name}.project" "STREAM_NUMBER")

	local __msg="${__email_msg}${__package_name}  \n\n Release Note: \n "

        echo -e $__msg > $__msg_body_file 
	echo -e "building options...\n" >>$__msg_body_file
	echo -e $__building_options >> $__msg_body_file
        echo -e "\n\r$diffs">> $__msg_body_file 
            
        cd $__android_root_dir
        source build/envsetup.sh
	lunch $__lunch_option 
	rm -rf out


	if [ "${__special_project}" != "yes" ];
      	then
                rm -rf $__android_root_dir/out/target/product/$__project_id/system/build.prop
                rm -rf $__android_root_dir/out/target/product/$__project_id/system/build.prop.bakforspec
                sed -i "s/ro.build.display.id=.*$/ro.build.display.id=${__version_number}\""/g "$__android_root_dir"/build/tools/buildinfo.sh
                sed -i '/ckt.internal.version/d' $__android_root_dir/build/tools/buildinfo.sh
                echo "echo \"ckt.internal.version=${__internal_version_number}\"" >>$__android_root_dir/build/tools/buildinfo.sh
       	fi

        #sed -i "s/CKT_PRODUCT_NAME.*$/CKT_PRODUCT_NAME := ${__product_name}"/g "$__android_root_dir"/device/qcom/${__project_id}/${__project_id}.mk

   	if [ "$__ssss_or_not" == "YES" ]
	then
            	echo "Configuration for SSSS is enabled! Switch ...">> $__build_log_file
                sed -i "s/dsds/ssss/g" "$__android_root_dir"/device/qcom/${__project_id}/${__project_id}.mk
            	echo "Configuration for SSSS is enabled! Switch done.">> $__build_log_file
	elif [ "$__ssss_or_not" == "NO" ];
        then
        	echo "Configuration for DSDS is disabled! Switch ...">> $__build_log_file
		#TOCHECK: device/qcom/msm8916_32/msm8916_32.mk set this prop as dsds in default, done nothing
                #sed -i 's/persist.radio.multisim.config=.*$/persist.radio.multisim.config='"dsds"/g "$__android_root_dir"/out/target/product/$__project_id/system/build.prop
                sed -i "s/ssss/dsds/g" "$__android_root_dir"/device/qcom/${__project_id}/${__project_id}.mk
            	echo "Configuration for DSDS is disabled! Switch done.">> $__build_log_file
	else
       		echo "No configuration for SSSS, done nothing">> $__build_log_file
	fi #[ "$__ssss_or_not" == "YES" ]
	#End of SSSS

	#Building... ...

        make -j$processor update-api 2>&1 | tee -a $__build_log_file
        if [ "$?" != "0" ];
          then
            echo "** update-api errors..."
            exit 1;
        fi

        make -j$processor
        if [ "$?" != "0" ];
          then
            echo "** Build errors..."
            exit 1;
        fi

	#Put 3rd packages in place
	#20141024 Remove the integration for 3rd party apk temporarilly
        #if [ "$__3rd_apk_path" != "" ] ;
        #then
                #find $__3rd_apk_path -exec touch {} \;
                ##copy other APP related files to related directory
                #cp -r $__3rd_apk_path/system/ $__system_dir >>$__build_log_file 2>>$__build_log_file
                #cp -r $__3rd_apk_path/data/ $__data_dir >>$__build_log_file 2>>$__build_log_file

                #echo
        #fi


	#Rebuild system and userdata for making the changed properties included
	#Remove the built system image and userdata image because we will soon build another ones
       	#rm -rf $__system_dir/system.img
       	#rm -rf $__system_dir/userdata.img
		
	#TODO: Double check if there are other images need to be rebuilt
       	#make -j8 systemimage >>$__build_log_file 2>>$__build_log_file
       	#make -j8 userdataimage >>$__build_log_file 2>>$__build_log_file
	#End of Rebuild system and userdata 

   	echo "__package_name=$__package_name" >>$__build_log_file 2>>$__build_log_file
       	echo "__package_dir_name=$__package_dir_name"  >>$__build_log_file 2>>$__build_log_file
	cd -
    
    
 	#======Copy and tar=====
	#1. Sort the app file full path
	local __full_app_file_path_list=
	for __file in ${__appimg_file_list}
	do
		__full_app_file_path_list="$__full_app_file_path_list $__android_root_dir/$__file"
	done

	#2: Copy android images to QC directory for generating package
	#ATTENTION: How the string of projectid processed to satisfy the proprietary code building
	#local __tmp_dir=$__qc_root_dir/$__qc_app_target/$__project_id
	local __tmp_dir=$__qc_root_dir/$__qc_app_target/${__project_id#${__project_id%%msm*}}
	mkdir -p $__tmp_dir
	cp -rf ${__full_app_file_path_list} ${__tmp_dir}/ >>${__tar_log_file} 2>>${__tar_log_file}

	#3. Updating NON-HLOS.bin
	cd $__qc_root_dir/common/build
	python update_common_info.py
	cd -
	
	#4: Copy all the images to be tared in place (Use tar to keep the directory hierachy

	#4.1 Copy images for R&D use in place
	rm -rf ${__package_dir_name}
	mkdir -p ${__package_dir_name}
	cd ${__qc_root_dir}
	tar cvfz ${__package_dir_name}/xxxxxx.tar.gz ${__qcimg_file_list}
	cd -
	
	cd ${__package_dir_name}
	#TOCHECK: As confirmed by Alex, images for QMSCT works for QFIT also, so no need to tar the following images
	#tar xvfz xxxxxx.tar.gz
	rm -rf xxxxxx.tar.gz
	cd -

	#4.2 Copy images for QMSCT use in place
	mkdir -p ${__qmsct_dir_name}
	cd ${__qc_root_dir}
	cp ${__qmsct_file_list} ${__qmsct_dir_name}/
	#tar cvfz ${__qmsct_dir_name}/xxxxxxqmsct.tar.gz ${__qmsct_file_list}

	#4.3 Generate rawprogram_unsparse.xml for upgrading QCN(fsg)
	cp -f ${__qmsct_dir_name}/rawprogram_unsparse.xml  ${__qmsct_dir_name}/rawprogram_unsparse_without_QCN.xml
	#mv -f ${__qmsct_dir_name}/rawprogram_unsparse.xml  ${__qmsct_dir_name}/rawprogram_unsparse_with_QCN.xml
	sed -i "s/\<program SECTOR_SIZE_IN_BYTES=\"512\" file_sector_offset=\"0\" filename=\"\" label=\"modemst1\"\(.*\)\>/program SECTOR_SIZE_IN_BYTES=\"512\" file_sector_offset=\"0\" filename=\"zero.bin\" label=\"modemst1\"\1/g" ${__qmsct_dir_name}/rawprogram_unsparse.xml
	sed -i "s/\<program SECTOR_SIZE_IN_BYTES=\"512\" file_sector_offset=\"0\" filename=\"\" label=\"modemst2\"\(.*\)\>/program SECTOR_SIZE_IN_BYTES=\"512\" file_sector_offset=\"0\" filename=\"zero.bin\" label=\"modemst2\"\1/g" ${__qmsct_dir_name}/rawprogram_unsparse.xml

	sed -i "s/\<program SECTOR_SIZE_IN_BYTES=\"512\" file_sector_offset=\"0\" filename=\"\" label=\"fsg\"\(.*\)\>/program SECTOR_SIZE_IN_BYTES=\"512\" file_sector_offset=\"0\" filename=\"${__fsg_name}\" label=\"fsg\"\1/g" ${__qmsct_dir_name}/rawprogram_unsparse.xml

	sed -i "s/\<program SECTOR_SIZE_IN_BYTES=\"512\" file_sector_offset=\"0\" filename=\"splash.img\" label=\"splash\"\(.*\)\>/program SECTOR_SIZE_IN_BYTES=\"512\" file_sector_offset=\"0\" filename=\"${__splash_name}\" label=\"splash\"\1/g" ${__qmsct_dir_name}/rawprogram_unsparse.xml
	sed -i "s/\<program SECTOR_SIZE_IN_BYTES=\"512\" file_sector_offset=\"0\" filename=\"splash.img\" label=\"splash\"\(.*\)\>/program SECTOR_SIZE_IN_BYTES=\"512\" file_sector_offset=\"0\" filename=\"${__splash_name}\" label=\"splash\"\1/g" ${__qmsct_dir_name}/rawprogram_unsparse_without_QCN.xml


   #	if [ "$__ssss_or_not" == "YES" ]
#	then
#		sed -i "s/\<program SECTOR_SIZE_IN_BYTES=\"512\" file_sector_offset=\"0\" filename=\"\" label=\"fsg\"\(.*\)\>/program SECTOR_SIZE_IN_BYTES=\"512\" file_sector_offset=\"0\" filename=\"fsg_ssss.img\" label=\"fsg\"\1/g" ${__qmsct_dir_name}/rawprogram_unsparse_with_QCN.xml
#	else
#		sed -i "s/\<program SECTOR_SIZE_IN_BYTES=\"512\" file_sector_offset=\"0\" filename=\"\" label=\"fsg\"\(.*\)\>/program SECTOR_SIZE_IN_BYTES=\"512\" file_sector_offset=\"0\" filename=\"fsg.img\" label=\"fsg\"\1/g" ${__qmsct_dir_name}/rawprogram_unsparse.xml
#	fi #[ "$__ssss_or_not" == "YES" ]

	cd -

	#cd ${__qmsct_dir_name}
	#tar xvfz ${__qmsct_dir_name}/xxxxxxqmsct.tar.gz 
	#rm -rf ${__qmsct_dir_name}/xxxxxxqmsct.tar.gz 
	#cd -

	#5: Tar
	cd ${__package_dir_name}
	cd ..
        tar cvfhz ${__package_name}  `basename ${__package_dir_name}` >>${__tar_log_file} 2>>${__tar_log_file}

	#6: Move tar in place
	mkdir -p ${_target_dir_name}/${__project_id} 2>/dev/null
	mv -v ${__package_name} ${_target_dir_name}/${__project_id} >>${__tar_log_file} 2>>${__tar_log_file}
	cd $_work_dir_name

	#7: Remove temp dir
       	rm -rf ${__package_dir_name} >>${__tar_log_file} 2>>${__tar_log_file}

 	#======End of copy and tar=====

        if [ "$new_tag" != "" ]
	then
		cd $__qc_root_dir
		#TAG the tags
		git tag $__version_number
		#TAG push the tags
		git push origin $__version_number
		cd -

        	cd $__android_root_dir
		#TAG the tags
		repo forall -c git tag $__version_number
		#TAG push the tags
		repo forall -c git push gerrit $__version_number
		cd -
	fi


	#Send notification
       	logD $__msg
       	cat $__msg_body_file | mail -s "New $__package_name Build is Ready" -t $__mail_list

	cd -
	#finally backup the vmlinux file
	logD "Copying vmlinux file: cp $__android_root_dir/kernel/out/vmlinux $_vmlinux_backup_dir_name/vmlinux_$__package_name_prefix"_"$__ts_long"
	temp_dir=$_vmlinux_backup_dir_name/${__project_id}/vmlinux_$__package_name_prefix"_"$__ts_long
       	mkdir -p $temp_dir
	cp $__android_root_dir/out/target/product/${__project_id}/obj/KERNEL_OBJ/vmlinux $temp_dir

	#Backup symbols
	#1. Sort out
	local __full_backup_file_path_list=
	for __file in ${__backup_file_list}
	do
		__full_backup_file_path_list="$__full_backup_file_path_list $__android_root_dir/$__file"
	done

	#2: Copy backup files
	cp -rf ${__full_backup_file_path_list} ${temp_dir} 

	#TODO: Check if need backup the symbols, actually did not find such symbols 
       	#cp -r $__android_root_dir/out/target/product/$__project_id/symbols/system/lib $temp_dir || echo "Waring !! the drectory models does not exist!"
       	cd $temp_dir && tar -czvf vmlinux_$__package_name_prefix"_"$__ts_long.tar.gz * && cp *.tar.gz $_vmlinux_backup_dir_name/${__project_id} && cd -

       	rm -fr $temp_dir

    else
        echo "$__android_root_dir is not exist" >> $__build_log_file
    fi
}

#------------------------Main-------------------------
_script_name=`basename $0`

#Project list, separated by space
if [ "$1" != "" ];
then
    if [ "$(echo "$1" | grep ".project")" != "" ];then
    	_project_list=$(echo "$1"| cut -d "." -f1)
    else
    	_project_list="$1"
    fi
else
	echo "Usage: ${_script_name} PROJECT_FILE"
        exit 1
fi

new_tag="$2"
# __tag_or_not="FALSE"
# if [ "$(toUpper "$2")" == "TAG" ];
# then
#     __tag_or_not="YES"
# fi

_work_dir_name=`dirname $0`

#Get the absolute path
cd $_work_dir_name
_work_dir_name=`pwd`
cd -

cd $_work_dir_name
git pull --rebase
cd -

_log_dir_name="${_work_dir_name}/logs"
mkdir -p ${_log_dir_name} 2>/dev/null
logD "_log_dir_name="${_log_dir_name}

_target_dir_name="${_work_dir_name}/target"
mkdir -p ${_target_dir_name} 2>/dev/null
logD "_target_dir_name="${_target_dir_name}

_vmlinux_backup_dir_name="${_work_dir_name}/target"
mkdir -p ${_vmlinux_backup_dir_name} 2> /dev/null
logD "_vmlinux_backup_dir_name="$_vmlinux_backup_dir_name

for _project in $_project_list
do
    logD "__project="$_project "tag="$new_tag
    buildProject $_project $new_tag
done


#---------------------------------------------------End of the script--------------------------------------


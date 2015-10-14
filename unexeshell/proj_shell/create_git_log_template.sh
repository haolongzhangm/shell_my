#!/bin/bash

GITMESSAGE_FILE=~/.gitmessage
GITCONFIG_FILE=~/.gitconfig

# Used by email-address, the result is : ${USERNAME}@ck-telecom.com
# which will be used as the commit owner,such as => Author: junhu.fan <junhu.fan@ck-telecom.com>
USERNAME=ying.han

function backup_and_get_username
{
	if test -f ${GITMESSAGE_FILE}; then
		mv ${GITMESSAGE_FILE} ${GITMESSAGE_FILE}_bk
		echo "backup file: ${GITMESSAGE_FILE} -> ${GITMESSAGE_FILE}_bk"	
	fi
	
	if test -f ${GITCONFIG_FILE}; then
		USERNAME=`cat ${GITCONFIG_FILE} | grep name | awk '{print $3}'`
		mv ${GITCONFIG_FILE} ${GITCONFIG_FILE}_bk	
		echo "backup file: ${GITCONFIG_FILE} -> ${GITCONFIG_FILE}_bk"
	else
		echo "Can't get your username,Please modify this script"
	fi
	
	echo ""
	echo "Your username is : ${USERNAME}"
	echo "If the username is not correct,please modify the script to specify your e-mail name by changing macro: USERNAME"
}

function create_gitmessage_file
{
	echo "[Feature/BugFix/Enhancement/MTKPatch]xxx" > ${GITMESSAGE_FILE}
	echo "" >> ${GITMESSAGE_FILE}
	echo "[id]:NONE" >> ${GITMESSAGE_FILE}
	echo "[Type]" >> ${GITMESSAGE_FILE}
	echo "   BUG/FEATURE/ENHANCEMENT" >> ${GITMESSAGE_FILE}
	echo "   bugid if bug or feature or enhanchement" >> ${GITMESSAGE_FILE}
	echo "" >> ${GITMESSAGE_FILE}
	echo "[Products]" >> ${GITMESSAGE_FILE}
	echo "   X baseline" >> ${GITMESSAGE_FILE}
	echo "   X HIKe" >> ${GITMESSAGE_FILE}
	echo "   Z baseline" >> ${GITMESSAGE_FILE}
	echo "   Z HIKe" >> ${GITMESSAGE_FILE}
	echo "" >> ${GITMESSAGE_FILE}
	echo "[Requirement]" >> ${GITMESSAGE_FILE}
	echo "   N/A" >> ${GITMESSAGE_FILE}
	echo "" >> ${GITMESSAGE_FILE}
	echo "[Solution Description]" >> ${GITMESSAGE_FILE}
	echo "   N/A" >> ${GITMESSAGE_FILE}
	echo "" >> ${GITMESSAGE_FILE}
	echo "[Other Info]" >> ${GITMESSAGE_FILE}
	echo "   N/A" >> ${GITMESSAGE_FILE}
	echo "" >> ${GITMESSAGE_FILE}
}

function create_gitconfig_file
{
	echo "[user]" > ${GITCONFIG_FILE}
	echo "        name = ${USERNAME}" >> ${GITCONFIG_FILE}
	echo "        email = ${USERNAME}@ck-telecom.com" >> ${GITCONFIG_FILE}
	echo "[color]" >> ${GITCONFIG_FILE}
	echo "        ui = auto" >> ${GITCONFIG_FILE}
	echo "" >> ${GITCONFIG_FILE}
	echo "[commit]" >> ${GITCONFIG_FILE}
	echo "        template = ~/.gitmessage" >> ${GITCONFIG_FILE}
}

backup_and_get_username
create_gitmessage_file
create_gitconfig_file

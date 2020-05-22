# ----------------------------------------------------------------------------
# File Name     : trash_fuc.sh
# Author        : gsj
# E-MAIL        : guosj.so@gmail.com
# Created Date  : 2019.12.13
# ----------------------------------------------------------------------------
# Version       : 20200519
# Modified Date : 2020.05.19
# Modified by   : gsj   guosj.so@gmail.com
# ----------------------------------------------------------------------------
# others        :
# ----------------------------------------------------------------------------
#!/bin/sh


############ Trash #####################################################################
### 重定义rm命令 ### 
#DATE_TIME="`date +%Y_%m-%d_%H:%M`"
date_day="`date +%m-%d-%Y`"
my_name=`whoami`
auto_rm_date=7
trash_version=200519
#pwd_user=`cd ~ && pwd`
alias ps='ps auxf'
alias tree='~/.tools/tree/bin/tree -l -F'
alias rmps='ps | grep $my_name'
alias rmkill='kill_all_process'
# Help
#sh ~/.tools/trash/rmhelp.sh
alias rmhelp='sh ~/.tools/trash/rmhelp.sh' 
alias rmupdate='echo -e "\ntrash code::" && cat ~/.tools/trash/trash.sh && echo -e "\n\nrmhelp and rmupdate:" && cat ~/.tools/trash/rmhelp.sh '
alias rmversion='echo "Your trash version is: $trash_version"'

# Define the trash_path. 
trash_path=~/.trash 

# Define pwd_user: cd ~ and pwd. 
pwd_now=$(pwd) && cd ~ > $trash_path/pwd_user && pwd_user=$(pwd) && cd $pwd_now > $trash_path/pwd_user
trash_path_e=$(echo $trash_path | sed "s#$pwd_user#~#g" )

# Enter your trash
alias my_trash='cd $trash_path'

# 判断 $trash_path 定义的文件是否存在，如果不存在，那么就创建 $trash_path. 
if [ ! -d $trash_path ]; then 
	mkdir -p $trash_path 
fi 
 
# alias: trash function. 
alias rm=trash 
alias rmnt='/bin/rm'

# du -hd1 trash_path
alias rmdu='du -hd1 $trash_path'
 
# rmls : 'ls -a ~/.trash'  
alias rmls='ls -a $trash_path' 
alias rmll='tree -L 2 $trash_path'
 
# unrm : restorefile，Execute in the parent directory of the deleted file or directory.
alias unrm=restorefile 

# mv xxx to current file
alias mvrm=mvtrashfile
 
# rmtrash : clearteash 
alias rmtrash=cleantrash 

kill_all_process()
{
	read -p "确定要杀掉自己在当前节点所有进程吗？（会强制断开所有已连接的当前节点！）[y/n]" confirm 
	[ $confirm == 'y' ] || [ $confirm == 'Y' ]  && killall -u $my_name
}

# Restore function.
restorefile() 
{ 
#sh ~/.tools/trash/trash.sh
	if [ ! -z $@ ]; then
		# Define restore_path now.
		restore_path_now=`pwd`
		restore_path_now_e=$(echo $restore_path_now | sed "s#$pwd_user#~#g" )

		# Search for inputs.
		find $trash_path/ -name *$@* | tee $trash_path/restore_list
		for restore_file in `cat $trash_path/restore_list`
		do
			restore_file_e=$(echo $restore_file | sed "s#$pwd_user#~#g" )
			read -e -p "Do you want to restore file : $restore_file_e ? [y/n]" confirm 
			[ $confirm == 'y' ] || [ $confirm == 'Y' ]  && mv -i $restore_file $restore_path_now/ && restore_suc=1 && break
			restore_suc=0
		done
		#mv -i $trash_path/$@ $restore_path/ 
		if [[ $restore_suc == 1 ]]; then
			echo -e "Restore  $restore_file_e  to  $restore_path_now_e/  successfully. "
		else
			echo -e "Restore error. \nTry 'rmhelp' for more information. "
		fi
	else
		restore_suc_auto=0
		if [ -z $restore_path ]; then
			restore_path=`pwd`
			restore_path_e=$(echo $restore_path | sed "s#$pwd_user#~#g" )
		fi
		if [ ! -z "$restore" ]; then
			for restore_list in $restore
			do
				restore_old_step=$(echo $restore_list | sed "s/\/$//g")
				restore_old=$(echo $restore_old_step | sed "s#^.*/##g")
				mv -i $trash_path/$date_day/$restore_old $restore_path/ && \
				if [ ! -e $trash_path/$date_day/$restore_old ]; then restore_suc_auto=1; fi
				if [[ $restore_suc_auto == 1 ]]; then
					echo -e "Restore  $trash_path_e/$date_day/$restore_old  to  $restore_path_e/  successfully. "
				else
					echo -e "Restore error. \nTry to use 'rmll' and 'unrm xxxx' to restore your file.  Or try 'rmhelp' for more information. "
				fi
			done
		fi
	fi
} 
 
# rm function 
trash() 
{ 
#sh ~/.tools/trash/trash.sh
date_day="`date +%m-%d-%Y`"
	# Make sure that the trash_path exists.
	if [ ! -d $trash_path ]; then 
		mkdir -p $trash_path 
	fi 

	# Make sure that the trash_path/date_day exists.
	if [ ! -d $trash_path/$date_day ]; then 
		mkdir -p $trash_path/$date_day
	fi 

	# Delete duplicate files to prevent conflicts.
	for rm_list in $@
	do
		if [ -e $trash_path/$date_day/$rm_list ]; then 
			/bin/rm -rf $trash_path/$date_day/$rm_list
		fi
	done
	for rm_list in $@
	do
		rm_list=$(echo $rm_list | sed "s#/##g")
		if [ -e $trash_path/$date_day/$rm_list ]; then 
			/bin/rm -rf $trash_path/$date_day/$rm_list
		fi
	done
	
	# Determine whether $@ is a file or a folder.
	

	# The rm function.
	for rm_list in $@
	do
		mv -f $rm_list $trash_path/$date_day/
		if [ $? -eq 0 ]; then
			restore_path=`pwd`
			restore_path_e=$(echo $restore_path | sed "s#$pwd_user#~#g" )
			echo -e "Remove  $restore_path_e/$rm_list  to  $trash_path_e/$date_day/  successfully. "
		else
			#what_i_input=$(echo $@ | sed "s#\ #\\\ #g")
			echo -e "Remove error. Use 'rmnt' again to rm the error item, add '\' before the space. Just like 'rmnt -rf 1\ 2\ 3' instead of 'rm 1 2 3'. \nOr try 'rmhelp' for more information."
			#echo -e "Remove error. Use 'rm' again to rm the error item, add '\' before the space. Like '' then use 'rmnt -rf $what_i_input' instead. \nTry 'rmhelp' for more information."
		fi
	done
	if [ $? -eq 0 ]; then
		restore=$@
	fi
#	mv -f $@ $trash_path/$date_day/
#	if [ $? -eq 0 ]; then
#		restore=$@
#		restore_path=`pwd`
#		restore_path_e=$(echo $restore_path | sed "s#$pwd_user#~#g" )
#		echo -e "Remove  $restore_path_e/$@  to  $trash_path_e/$date_day/  successfully. "
#	else
#		echo -e "Remove error. \nTry 'rmhelp' for more information. "
#	fi
}
 
# Clean trash function 
cleantrash() 
{ 
	#if [ ! -e ~/.trash.log ]; then
	#	touch ~/.trash.log
	#fi
	read -p "确定清空回收站吗???[y/n]" confirm 
	[ $confirm == 'y' ] || [ $confirm == 'Y' ]  && /bin/rm -rf $trash_path && mkdir $trash_path
	#[ $confirm == 'y' ] || [ $confirm == 'Y' ]  && find ~/.trash/ \( -path "." -o -path "." \) -prune -o -type f -print > ~/.trash.log && /bin/rm -rf `cat ~/.trash.log`
	#[ $confirm == 'y' ] || [ $confirm == 'Y' ]  && /bin/rm -rf $trash_path/*
	if [ $? -eq 0 ]; then
		echo -e "Clean the trash successfully. "
	else
		echo -e "Clean error. \nTry 'rmhelp' for more information. "
	fi
}

# 自动删除 $auto_rm_date 之前的文件。
#sh ~/.tools/trash/trash_auto_rm.sh &
auto_rm_seconds=$((24*3600))
#for ((i=1;i>0;i++)) 
#while $auto_rm_date > 0
while true
do
	find $trash_path/ -mindepth 1 -maxdepth 1 -type d -ctime +$auto_rm_date -exec rm -rf {} \;
#	find $trash_path/ -mindepth 1 -maxdepth 1 -type d -ctime +5 -exec rm -rf {} \;
	sleep ${auto_rm_seconds}
done &
########## Trash end ###################################################################

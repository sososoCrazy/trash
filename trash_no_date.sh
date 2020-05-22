#########################################################################
#   > File Name:     trash.sh
#   > Author:        gsj
#   > mail:          guosj.so@gmail.com
#   > Created Time:  2019.12.13 10:03
#########################################################################
#!/bin/sh

############ Trash #####################################################################
### 重定义rm命令 ### 
pwd_user="`cd ~ && pwd`"

# Help
#sh ~/.tools/trash/rmhelp.sh
alias rmhelp='sh ~/.tools/trash/rmhelp.sh' 
alias rmupdate='echo -e "\ntrash code::" && cat ~/.tools/trash/trash.sh && echo -e "\n\nrmhelp and rmupdate:" && cat ~/.tools/trash/rmhelp.sh '

# 定义回收站目录 
trash_path=~/.trash 
trash_path_e=$(echo $trash_path | sed "s#$pwd_user#~#g" )
 
# Enter your trash
alias my_trash='cd $trash_path'

# 判断 $trash_path 定义的文件是否存在，如果不存在，那么就创建 $trash_path. 
if [ ! -d $trash_path ]; then 
	mkdir -p $trash_path 
fi 
 
# 定义别名：使用 rm 就调用 trash 
alias rm=trash 
alias rmnt='/bin/rm'

# du -hd1 trash_path
alias rmdu='du -hd1 $trash_path'
 
# 使用 rmls 就调用 'ls ~/.trash' 
# 如果更改上面的回收站目录这里的目录也需要修改 
alias rmls='ls -a $trash_path' 
 
# 使用 unrm 就调用 restorefile，需要在删除目录的父目录下执行 
alias unrm=restorefile 

# mv xxx to current file
alias mvrm=mvtrashfile
 
# 使用 rmtrash 就调用 claearteash 
alias rmtrash=cleartrash 

# 恢复文件的函数 
restorefile() 
{ 
	if [ -z $restore_path ]; then
		restore_path=`pwd`
		restore_path_e=$(echo $restore_path | sed "s#$pwd_user#~#g" )
	fi
	if [ ! -z $@ ]; then
		mv -i $trash_path/$@ $restore_path/ 
		if [ $? -eq 0 ]; then
			echo -e "Restore  $trash_path_e/$@  to  $restore_path_e/  successfully. "
		else
			echo -e "Restore error. \nTry 'rmhelp' for more information. "
		fi
	else
		mv -i $trash_path/$restore $restore_path/ 
		if [ $? -eq 0 ]; then
			echo -e "Restore  $trash_path_e/$restore  to  $restore_path_e/  successfully. "
		else
			echo -e "Restore error. \nTry 'rmhelp' for more information. "
		fi
	fi
} 
 
# 删除文件的函数 
trash() 
{ 
if [ ! -d $trash_path ]; then 
	mkdir -p $trash_path 
fi 
	for rm_list in $@
	do
	if [ -e $trash_path/$rm_list ]; then 
		/bin/rm -rf $trash_path/$rm_list
	fi
	done
	mv -f $@ $trash_path/ 
	if [ $? -eq 0 ]; then
		restore=$@
		restore_path=`pwd`
		restore_path_e=$(echo $restore_path | sed "s#$pwd_user#~#g" )
		echo -e "Remove  $restore_path_e/$@  to  $trash_path_e/  successfully. "
	else
		echo -e "Remove error. \nTry 'rmhelp' for more information. "
	fi
} 
 
# 清空回收站的函数 
cleartrash() 
{ 
	#if [ ! -e ~/.trash.log ]; then
	#	touch ~/.trash.log
	#fi
	read -p "确定要清空回收站吗?[y/n]" confirm 
	[ $confirm == 'y' ] || [ $confirm == 'Y' ]  && /bin/rm -rf $trash_path && mkdir $trash_path
	#[ $confirm == 'y' ] || [ $confirm == 'Y' ]  && find ~/.trash/ \( -path "." -o -path "." \) -prune -o -type f -print > ~/.trash.log && /bin/rm -rf `cat ~/.trash.log`
	#[ $confirm == 'y' ] || [ $confirm == 'Y' ]  && /bin/rm -rf $trash_path/*
	if [ $? -eq 0 ]; then
		echo -e "Clean the trash successfully. "
	else
		echo -e "Clean error. \nTry 'rmhelp' for more information. "
	fi
}
########## Trash end ###################################################################

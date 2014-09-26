#!/bin/sh

#判断是否传入参数   
if [ $# -eq 0 ];then
	echo "Usge: ./shellname dirname [en/cn] [c/java/m/h]"
	exit 1	
fi

#获取统计目录名和输出语言类型
dir_name=$1
lang_type=$2
file_type=$3
result_file="code_statistics_result.txt"

sum_files=0;
sum_alllines=0;
sum_codelines=0;
sum_nocommentlines=0;
sum_commentslines=0;
sum_blanklines=0;

#检测参数是否是一个目录
if [ ! -d $dir_name ];then
	echo "$dir_name is not a directory!"
	exit 2
fi


#函数 - 统计所有文件总数
Files_TotalNum()
{
	sum_files=$(find $dir_name -name "*.$file_type" | wc -l);
#	echo $sum_files;
	return 0;
}

#函数 - 统计所有文件行总数
AllLines_TotalNum()
{
	sum_alllines=$(find $dir_name -name "*.$file_type" | xargs cat | wc -l);
#	echo $sum_alllines;
	return 0;
}


#函数 - 统计所有代码行总数
CodeLines_TotalNum()
{
	sum_codelines=$(find $dir_name -name "*.$file_type" | xargs cat | grep -v '^[[:space:]]*$'|grep -v '^[[:space:]]*\/\/' |sed '/\/\*/,/\*\//d' | wc -l);
#	echo $sum_codelines;
	return 0;	
}



#函数 - 统计所有注释行总数
Comments_TotalNum()
{
	sum_nocommentlines=$(find $dir_name -name "*.$file_type" | xargs cat |  sed '/\/\*/,/\*\//d' | sed '/\/\//d'|wc -l);
	let sum_commentslines=sum_alllines-sum_nocommentlines;
#	echo $sum_commentslines;
	return 0;	
}

#noteLine=10
#line=100
#awk 'BEGIN{printf "%.2f%\n",('$noteLine'/'$line')*100}'


#函数 - 统计所有空白行总数
BlankLines_TotalNum()
{
	sum_blanklines=$(find $dir_name -name "*.$file_type" | xargs cat | grep '^[[:space:]]*$' |wc -l);
#	echo $sum_blanklines;
	return 0;
}


#函数 - 定义统计(英文)
Statistics_Func_EN()
{
	Files_TotalNum;
	AllLines_TotalNum;
	CodeLines_TotalNum;
	Comments_TotalNum;
	BlankLines_TotalNum;
	
#	echo "en $1";
	echo "=======Statistics Result===========" 	>> $result_file
	echo "$(date)"  							>> $result_file
	echo -n "Directory Name: "					>> $result_file
	echo $dir_name								>> $result_file
    echo -n "File    Type:  ."					>> $result_file
    echo $file_type								>> $result_file
	echo "" 									>> $result_file
	echo -n "Files    Sum: "					>> $result_file
	echo $sum_files								>> $result_file
	echo -n "Total   line: "					>> $result_file
	echo $sum_alllines							>> $result_file
	echo -n "Code    line: "					>> $result_file
	echo $sum_codelines							>> $result_file
	echo -n "Blank   line: "					>> $result_file
	echo $sum_blanklines 						>> $result_file
	echo -n "Comment line: "					>> $result_file
	echo $sum_commentslines 					>> $result_file
	echo "===================================" 	>> $result_file

	return 0;
}

#函数 - 定义统计(中文)
Statistics_Func_CN()
{
	Files_TotalNum;
    AllLines_TotalNum;
    CodeLines_TotalNum;
    Comments_TotalNum;
    BlankLines_TotalNum;
	
#	echo "en $1";
	echo "=============统计结果==============" 	>> $result_file
	echo "$(date)"  							>> $result_file
	echo -n "统计目录名: "						>> $result_file
	echo $dir_name								>> $result_file
    echo -n "文件类型:  ."					     	>> $result_file
    echo $file_type								>> $result_file
	echo "" 									>> $result_file
	echo -n "文件数量:  "						>> $result_file
	echo $sum_files								>> $result_file
	echo -n "文件总行数: "						>> $result_file
	echo $sum_alllines							>> $result_file
	echo -n "代码总行数: "						>> $result_file
	echo $sum_codelines							>> $result_file
	echo -n "空白总行数: "						>> $result_file
	echo $sum_blanklines 						>> $result_file
	echo -n "注释总行数: "						>> $result_file
	echo $sum_commentslines 					>> $result_file
	echo "===================================" 	>> $result_file

	return 0;
}

#函数 - 定义统计(日文)
Statistics_Func_JP()
{
Files_TotalNum;
AllLines_TotalNum;
CodeLines_TotalNum;
Comments_TotalNum;
BlankLines_TotalNum;

#	echo "en $1";
echo "=============統計結果==============" 	>> $result_file
echo "$(date)"  							>> $result_file
echo -n "フォルダ名:　　　 "					>> $result_file
echo $dir_name								>> $result_file
echo -n "ファイルタイプ: 　."					    >> $result_file
echo $file_type								>> $result_file
echo "" 									>> $result_file
echo -n "ファイル数:　　　 "					>> $result_file
echo $sum_files								>> $result_file
echo -n "ファイルライン数: "					>> $result_file
echo $sum_alllines							>> $result_file
echo -n "ソースライン数:　 "					>> $result_file
echo $sum_codelines							>> $result_file
echo -n "空白ライン数: 　　"					>> $result_file
echo $sum_blanklines 						>> $result_file
echo -n "コメントライン数: "					>> $result_file
echo $sum_commentslines 					>> $result_file
echo "===================================" 	>> $result_file

return 0;
}

echo "Statistics Start!"
#根据语言类型,输出统计结果(默认语言为英文)
if [ "$lang_type" = "cn" ];then
	echo "Output Language is Chinese!"
	Statistics_Func_CN $dir_name
fi

if [ "$lang_type" = "jp" ];then
    echo "Output Language is Japanese!"
    Statistics_Func_JP $dir_name
fi

if [ "$lang_type" = "en" ];then
	echo "Output Language is English!"
	Statistics_Func_EN $dir_name
fi

echo "Statistics End!"
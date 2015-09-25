#!/bin/bash
echo ===============================================================

echo Now into xs android project !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
cd /home/zhl/mycode/xs_base/mt6592_kk
pwd
function print_usage(){
echo Usage!!
echo =================================================================
echo command ----------------:-----meaning
echo $0 n_pre ------------:-----new build preloader
echo $0 r_pre ------------:-----build preloader just modify file
echo $0 n_kernel ---------:-----new build kernel
echo $0 r_kernel ---------:-----build kernl just modifify file
echo $0 n_bootimage ------:-----new build bootimage 
echo $0 r_bootimage ------:-----build bootimage just modify file
echo $0 n_recovery -------:-----new build recovery
echo $0 r_recovery -------:-----build recovery just modify file
echo $0 n_all ------------:-----new build all project
echo $0 r_all ------------:-----build all project just modify file
echo $0 n_lk -------------:-----new build lk
echo $0 r_lk -------------:-----build lk just modify file 
echo ==================================================================
}
if [ $# -eq 0 ]
then
 echo "just into $0 dir"
 print_usage

elif [ $1 == "n_pr" ]
then
 echo "just into $1  function"
 ./mk -t listp
 ./mk -t ckt92_we_kk n pl

elif [ $1 == "n_all" ]
then
 echo "just into $1  function"
 ./mk -t listp
 ./mk -t ckt92_we_kk n 

elif [ $1 == "n_bootimage" ]
then
 echo "just into $1  function"
 ./mk -t listp
 ./mk -t ckt92_we_kk n bootimage

elif [ $1 == "n_kernel" ]
then
 echo "just into $1  function"
 ./mk -t listp
 ./mk -t ckt92_we_kk n k

elif [ $1 == "n_lk" ]
then
 echo "just into $1  function"
 ./mk -t listp
 ./mk -t ckt92_we_kk n lk

elif [ $1 == "n_recovery" ]
then
 echo "just into $1  function"
 ./mk -t listp
 ./mk -t ckt92_we_kk n recoveryimage

elif [ $1 == "r_pr" ]
then
 echo "just into $1  function"
 ./mk -t listp
 ./mk -t ckt92_we_kk r pl

elif [ $1 == "r_all" ]
then
 echo "just into $1  function"
 ./mk -t listp
 ./mk -t ckt92_we_kk r

elif [ $1 == "r_bootimage" ]
then
 echo "just into $1  function"
 ./mk -t listp
 ./mk -t ckt92_we_kk r bootimage

elif [ $1 == "r_kernel" ]
then
 echo "just into $1  function"
 ./mk -t listp
 ./mk -t ckt92_we_kk r k

elif [ $1 == "r_recovery" ]
then
 echo "just into $1  function"
 ./mk -t listp
 ./mk -t ckt92_we_kk r recoveryimage 

elif [ $1 == "r_lk" ]
then
 echo "just into $1  function"
 ./mk -t listp
 ./mk -t ckt92_we_kk r lk

else 
 print_usage
 echo "Nothing DONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
fi

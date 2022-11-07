#!/bin/sh

PS3='Select an action: '
options=(
"Install Node"
"Check Log"
"Exit")
select opt in "${options[@]}"
do
case $opt in
"Install Node")
echo "Install node"
break
;;

"Check Log")
echo "Check Log"
break;
;;
"Exit")
exit
;;
*) echo "invalid option $REPLY";;
esac
done
done
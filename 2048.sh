#!/bin/bash
gotoxy(){
	printf "\\e[$2;$1H"
}
#clear(){
#	printf "\\e[H\\e[J"
#}
#getxy(){
#	echo -ne '\e[6n';read -sdR position
#	position=${position#*[}
#	#x=`echo $position|cut -d ';' -f 2`
#	y=`echo $position|cut -d ';' -f 1`
#	#echo "\n"
#	#echo "$y">tmp
#	#return `expr substr "$y" 1 2`
#	
#}
showbanner()
{
echo '#---------------------------#'
echo '|                           |'
echo '|                           |'
echo '|                           |'
echo '|                           |'
echo '|                           |'
echo '|                           |'
echo '|                           |'
echo '|           2048            |'
echo '|                           |'
echo '|                           |'
echo '|                           |'
echo '|                           |'
echo '|                           |'
echo '|                           |'
echo '|                By Poilynx |'
echo '#---------------------------#'
}
refresh()
{
	#clear
	gotoxy 1 1
	ptns="      ,   2  ,   4  ,   8  ,  16  ,  32  ,  64  ,  128 ,  256 ,  512 , 1024 , 2048 , 4096 , 8192 ,"
	
	for((i=0;i<4;i++))
	do
		for((j=0;j<4;j++))
        	do
			#echo $i $j
			eval pos=\$\(\(\${map_${i}_${j}}*7\)\)
                	#echo $pos
			eval a${i}${j}=\$\{ptns\:$pos\:6\}
			#eval echo \"\$a${i}${j}\"
			#eval tmp=\$map_${i}_${j}
                	#echo $tmp
        	done    
	done
	
	echo "#------#------#------#------#"
	echo "|      |      |      |      |"
	echo "|${a00}|${a01}|${a02}|${a03}|"
	echo "|      |      |      |      |"
	echo "#------#------#------#------#"
	echo "|      |      |      |      |"
	echo "|${a10}|${a11}|${a12}|${a13}|"
	echo "|      |      |      |      |"
	echo "#------#------#------#------#"
	echo "|      |      |      |      |"
	echo "|${a20}|${a21}|${a22}|${a23}|"
	echo "|      |      |      |      |"
	echo "#------#------#------#------#"
	echo "|      |      |      |      |"
	echo "|${a30}|${a31}|${a32}|${a33}|"
	echo "|      |      |      |      |"
	echo "#------#------#------#------#"
	#getxy
	return
}

n=0
newblock(){
	if [ $nblank -eq 0 ] 
	then
		return 0
	fi
	pos=$((${RANDOM}%(${nblank})))
	tmp=0
	bk=0
	for((i=0;i<4;i++))
	do
        	for((j=0;j<4;j++))
        	do
			eval v=\$map_${i}_${j}
			if [ $v -eq 0 ]
			then
				if [ $tmp -eq $pos ]
				then
					eval map_${i}_${j}=1
					let nblank-=1
					return 1
				fi

				let tmp+=1
			fi
        	done
	done
	return 1
	
}


push_up(){


	moved=0
	for((i=0;i<4;i++)) ;do
	
		#j=3
		p=-1
		v=0
		#while [ $j -ge 0 ] ;do
		for((j=3;j>=0;j--)) ;do
			eval value=\$map_${j}_${i}
			if [ $value -ne 0 ] ;then 
				if [ $p -eq -1 ] ;then
					p=$j
					v=$value
				else
					if [ $v -eq $value ] ;then
						eval let map_${p}_${i}+=1
						eval let map_${j}_${i}=0
						let nblank+=1
						[ $moved -eq 0 ] && moved=1
						break
					else
						p=$j
						v=$value
					fi
				fi
				
			fi
			#let j-=1
		done
		#j=0
		p=-1
		#while [ $j -lt 4 ] ;do
		for((j=0;j<4;j++)) ;do
			eval value=\$map_${j}_${i}
			if [ $value -eq 0 ] && [ $p -eq -1 ] ;then 
				p=$j
				#v=$value
			elif [ $value -ne 0 ] && [ $p -ne -1 ] ;then
				eval let map_${p}_${i}=\$map_${j}_${i}
				eval let map_${j}_${i}=0
				let p+=1
				[ $moved -eq 0 ] && moved=1
			fi
			#let j+=1
		done

	done
	
	if [ $moved -eq 0 ] ;then
		return 1
	else
		return 0
	fi
	
}

push_down(){
	moved=0
	for((i=0;i<4;i++)) ;do
	
		#j=3
		p=-1
		v=0
		#while [ $j -ge 0 ] ;do
		for((j=0;j<4;j++)) ;do
			eval value=\$map_${j}_${i}
			if [ $value -ne 0 ] ;then 
				if [ $p -eq -1 ] ;then
					p=$j
					v=$value
				else
					if [ $v -eq $value ] ;then
						eval let map_${p}_${i}+=1
						eval let map_${j}_${i}=0
						let nblank+=1
						[ $moved -eq 0 ] && moved=1
						break
					else
						p=$j
						v=$value
					fi
				fi
				
			fi
			#let j-=1
		done
		p=-1
		for((j=3;j>=0;j--)) ;do
			eval value=\$map_${j}_${i}
			if [ $value -eq 0 ] && [ $p -eq -1 ] ;then 
				p=$j
				#v=$value
			elif [ $value -ne 0 ] && [ $p -ne -1 ] ;then
				eval let map_${p}_${i}=\$map_${j}_${i}
				eval let map_${j}_${i}=0
				let p-=1
				[ $moved -eq 0 ] && moved=1
			fi
			#let j+=1
		done

	done
	
	if [ $moved -eq 0 ] ;then
		return 1
	else
		return 0
	fi
}
push_left(){


	moved=0
	for((i=0;i<4;i++)) ;do
	
		#j=3
		p=-1
		v=0
		for((j=3;j>=0;j--)) ;do
			eval value=\$map_${i}_${j}
			if [ $value -ne 0 ] ;then 
				if [ $p -eq -1 ] ;then
					p=$j
					v=$value
				else
					if [ $v -eq $value ] ;then
						eval let map_${i}_${p}+=1
						eval let map_${i}_${j}=0
						let nblank+=1
						[ $moved -eq 0 ] && moved=1
						break
					else
						p=$j
						v=$value
					fi
				fi
				
			fi
			#let j-=1
		done
		#j=0
		p=-1
		#while [ $j -lt 4 ] ;do
		for((j=0;j<4;j++)) ;do
			eval value=\$map_${i}_${j}
			if [ $value -eq 0 ] && [ $p -eq -1 ] ;then 
				p=$j
				#v=$value
			elif [ $value -ne 0 ] && [ $p -ne -1 ] ;then
				eval let map_${i}_${p}=\$map_${i}_${j}
				eval let map_${i}_${j}=0
				let p+=1
				[ $moved -eq 0 ] && moved=1
			fi
			#let j+=1
		done

	done
	
	if [ $moved -eq 0 ] ;then
		return 1
	else
		return 0
	fi
	
}

push_right(){
	moved=0
	for((i=0;i<4;i++)) ;do
	
		#j=3
		p=-1
		v=0
		#while [ $j -ge 0 ] ;do
		for((j=0;j<4;j++)) ;do
			eval value=\$map_${i}_${j}
			if [ $value -ne 0 ] ;then 
				if [ $p -eq -1 ] ;then
					p=$j
					v=$value
				else
					if [ $v -eq $value ] ;then
						eval let map_${i}_${p}+=1
						eval let map_${i}_${j}=0
						let nblank+=1
						[ $moved -eq 0 ] && moved=1
						break
					else
						p=$j
						v=$value
					fi
				fi
				
			fi
			#let j-=1
		done
		p=-1
		for((j=3;j>=0;j--)) ;do
			eval value=\$map_${i}_${j}
			if [ $value -eq 0 ] && [ $p -eq -1 ] ;then 
				p=$j
				#v=$value
			elif [ $value -ne 0 ] && [ $p -ne -1 ] ;then
				eval let map_${i}_${p}=\$map_${i}_${j}
				eval let map_${i}_${j}=0
				let p-=1
				[ $moved -eq 0 ] && moved=1
			fi
			#let j+=1
		done

	done
	
	if [ $moved -eq 0 ] ;then
		return 1
	else
		return 0
	fi
}

getdir(){
	
	while :
	do
		read -s -n 1 key
		if [ "$key" = "Q" ] || [ "$key" = "q" ] ;then
			printf "quit"
			return 0
		elif  [ "$key" != `printf "\\\\e"` ] ;then
			continue
		fi
		
		read -s -n 2 key
		case $key in
			"[A")
				printf "up"
				return 0
				;;
			"[B")
				printf "down"
				return 0
				;;
			"[D")
				printf "left"
				return 0
				;;
			"[C")
				printf "right"
				return 0
				;;
			*)
		esac

	done
}



clear
gotoxy 1 1
for((i=0;i<4;i++))
do
	for((j=0;j<4;j++))
	do
		eval map_${i}_${j}=0
	done
done
nblank=16

rx=$(($RANDOM%4))
ry=$(($RANDOM%4))

eval map_${rx}_${ry}=1
let nblank-=1

b=0
showbanner
sleep 1
while true
do
	if [ $b -eq 0 ] ;then
		gotoxy 1 1
		refresh
		#sleep 0.1
		newblock
		gotoxy 1 1
		refresh
	fi

	key=$(getdir)
	printf "        \r"

	case $key in
		"quit")
			exit 0
			;;
		"up")
			push_up
			b=$?
			;;
		"down")
			push_down
			b=$?
			;;
		"left")
			push_left
			b=$?
			;;
		"right")
			push_right
			b=$?
			;;
		*)
	esac
	#printf "$r\n"
done

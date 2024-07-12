#! /usr/bin/bash

screen=(
	'----------'
	'| $      |'
	'|   o    |'
	'|      $ |'
	'|$$      |'
	'----------'
	)


winScreen=(
	'----------'
	'|        |'
	'|  YOU   |'
	'|  WON   |'
	'|        |'
	'----------'
	)


emptyLine='|        |'

player="o"
bonus="$"
bonusCount=0
bonusesOnScreen=4
playerY=1
playerX=1
boundaryY=${#screen[@]}
((boundaryY-=2))
boundaryX=${#emptyLine}
((boundaryX-=2))

findP () {
	local pY=0
	playerX=1
	local playerLine=""
	for line in "${screen[@]}"
	do
		if [[ $line == *$player* ]]
		then
			playerLine=$line
			playerY=$pY
			break
		fi
		((pY+=1))
	done
	
	for (( place=0; place<${#playerLine}; place++ )); do
		if [[ ${playerLine:$place:1} == *$player* ]]
		then
			playerX=$place
			break
		fi
	done
}

moveUp () {
	local newLine="${screen[playerY-=1]}"
	local pX=$playerX
	((pX+=1))
	newLine=$(echo "$newLine" | sed s/./$player/$pX)
	screen[playerY]=$newLine
	local prevLine=${screen[playerY+=1]}
	prevLine=$(echo "$prevLine" | sed "s/$player/ /g")
	screen[playerY]=$prevLine
}

moveDown () {
	local newLine="${screen[playerY+=1]}"
	local pX=$playerX
	((pX+=1))
	newLine=$(echo "$newLine" | sed s/./$player/$pX)
	screen[playerY]=$newLine
	local prevLine=${screen[playerY-=1]}
	prevLine=$(echo "$prevLine" | sed "s/$player/ /g")
	screen[playerY]=$prevLine
}

moveRight () {
	local tempLine="${screen[playerY]}"
	local newX=$playerX
	((newX+=2))
	tempLine=$(echo "$tempLine" | sed "s/$player/ /g")
	tempLine=$(echo "$tempLine" | sed s/./$player/$newX)
	screen[playerY]=$tempLine
}

moveLeft () {
	local tempLine="${screen[playerY]}"
	tempLine=$(echo "$tempLine" | sed "s/$player/ /g")
	tempLine=$(echo "$tempLine" | sed s/./$player/$playerX)
	screen[playerY]=$tempLine
}

countBonuses () {
	bonusCount=$bonusesOnScreen
	local tempLine=""
	for line in ${screen[@]}
	do
		if [[ $line == *$bonus* ]]
		then
			tempLine=$line
			for (( place=0; place<${#tempLine}; place++ )); do
				if [[ ${tempLine:$place:1} == *$bonus* ]]
				then
					((bonusCount-=1))
				fi
			done
		fi
	done
}

while true
do
	clear
	countBonuses

	if [[ $bonusCount -eq $bonusesOnScreen ]]
	then
		clear
		for line in "${winScreen[@]}"
		do
			echo "$line"
		done
		break
	fi

	for line in "${screen[@]}"
	do
		echo "$line"
	done

	findP
	echo "Money: $bonusCount"
	# echo "Player Y: $playerY"
	# echo "Player X: $playerX"

	echo -e '\nCONTROL PLAYER -> o\nBY PRESSING WASD'
	echo -e '\nCOLLECT MONEY'
	read -rsn1 comm
	if [[ $comm == "q" ]]
	then
		break
	elif [[ $comm == "w" && $playerY -gt 1 ]]
	then
		moveUp
		continue
	elif [[ $comm == "s" && $playerY -lt $boundaryY ]]
	then
		moveDown
		continue
	elif [[ $comm == "a" && $playerX -gt 1 ]]
	then
		moveLeft
		continue
	elif [[ $comm == "d" && $playerX -lt $boundaryX ]]
	then
		moveRight
		continue
	else
		continue
	fi
done

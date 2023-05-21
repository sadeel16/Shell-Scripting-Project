#Ansam Rihan - 1200749 - section 4
#Sadeel Malassa - 1191153 - sec 1

touch grades.txt  #this  file is used to store the grades in it initially before doing mathmetical equations on it
touch hours.txt #this file to know the hours of the courses
touch years.txt
touch fail.txt 
Menu() #this function is used to print the menu the user should select from
{
echo "
	 "1. Show or print student Records"
	 "2. Show or print student Records for a specific semester"
	 "3. Show or print the overall average"
	 "4. Show or print the average of every semester"
	 "5. Show or print the total number of passed hours"
	 "6. Show or print the percentage of total passed hours in relation to total F and FA hours"
	 "7. Show or print the total number of hours taken for every semester"
	 "8. Show or print the total number of courses taken"
	 "9. Show or print the total number of labs taken"
	 "10.Insert the new Semester"
	 "11.change in course grade"
	 "

}

echo "---------Welcome to our program------------" #for design purposes

	
		echo 
		echo "PLEASE ENTER THE FILE NAME: "
		read fileName  #scanning the file name and string it into the variable
		
		#while loop keeps repeating until the user enters an existing file name
		while [ ! -e $fileName -o ! -f $fileName ]
		do
		  echo
		  echo "ERROR: FILE DOES NOT EXIST IN THE CURRENT DIRECTORY OR IT'S NOT AN ORDINARY FILE. PLEASE TRY AGAIN"
		   echo
		  echo "Please enter the file name : "
		  read fileName 
		done
		
		

Show(){ #this function is to show all semester's info

	if [[ -z $(grep '[^[:space:]]' $fileName) ]] #if file is empty
	then
		echo "file is empty"
	fi

	while read command; #if not print all info in that file
		do
			echo
			echo $command | tr ';' ':' | tr '[/,]' ' '
			
		done < $fileName
	

}

Search(){ #this function is to search foe a specific semester info

echo "PLEASE ENTER THE SEMESTER NUMBER: (1)FOR THE FISRT SEMESTER (2)FOR THE SECOND SEMESTER (3)FOR THE SUMMER SEMESTER "
read sem_Num  #reading the semester type

echo "PLEASE ENTER THE Year as FirstYear-SecondYear "
read Year_Num  #reading year of the semester 
echo
grep "$Year_Num/$sem_Num" $fileName | tr ';' ':' | tr '[/,]' ' ' #getting all info of that line using grep from the file


}

AverageForSemesters(){ #this function is to calculate the avg for each semester alone

grep "EN" $fileName | tr -s ' ' ' ' | cut -d';' -f1 > years.txt

while read -r line; #it will reed line by line from the file we stored only the semeter year/semester type in
do

	declare -a g=() #this array is used to put all the grades from grades file in it, and make it empty again for next use to the next semester
	declare -a h=() #this array is used to put all the hours from hours file in it, and make it empty again for next use to the next semester
	declare -a multi=() #this array to multiply the two arrays above and store the result in it

	grep $line $fileName | tr -s ' ' ' ' | cut -d';' -f2 | tr ',' '\n' | grep -v "I" | sed 's/FA/50/' | sed 's/F/55/' | sort | uniq -w 9 | cut -d' ' -f3 > grades.txt 
	#this will get only the grades from the specific semester and store them in the file

	while read -r line3; #to store file info in the array
	do
	        g+=("$line3")
	done < grades.txt 

	grep $line $fileName | tr -s ' ' ' ' | cut -d';' -f2 | tr ',' '\n' | grep -v "I" | sed 's/FA/50/' | sed 's/F/55/' | sort | uniq -w 9 | cut -c7 > hours.txt
	#this grep is used to take only the hours of the specific semester and store them in a file
	#and before that removing all courses with I, then replacing all FA to 55, and all F to 55 to make it easy to calculate the avg

	while read -r line2; #to store file info in the array
	do
	        h+=("$line2")
	done < hours.txt

	count=${#h[@]} #means get the number of elements in the array


	for ((i=0; i<$count; i++)) #to go through all the elements and do the mathmetical equation required
	do
	        multi[$i]=$(( ${h[$i]} * ${g[$i]} ))

	done


	sum_grades=0 #to store the summation of all  grades multiplied with thier hours

	for k in ${multi[@]}; do  #doing the summation of all  grades multiplied with thier hours

        	let sum_grades+=$k
	done


	sum_hours=0 #to store the summation of all hours in the semester

	for j in ${h[@]}; do  # #doing the summation of all  hours in the semester
        	let sum_hours+=$j
	done

	echo " your avrage in $line is > " $(( sum_grades / sum_hours ))"%"  #printing the avg of the semester

done < years.txt

}

AverageAll(){ #this function is used to print the average of all semesters

declare -a g #array to store grades from file
declare -a h #array to store hours from file
declare -a multi #array to store the multiplication of the two arrays above

grep "EN" $fileName | tr -s ' ' ' ' | cut -d';' -f2 | tr ',' '\n' | grep -v "I" | sed 's/FA/50/' | sed 's/F/55/' | sort | uniq -w 9 | cut -d' ' -f3 > grades.txt
#this grep is used to remove all the courses which are taken again and get the new grade of them
#then removing all courses with I, then replacing all FA to 55, and all F to 55 to make it easy to calculate the avg
#then take only the grades part and store them in a file

while read -r line; #storing all the info in file to the array
do
	g+=("$line")
done < grades.txt
 

grep "EN" $fileName | tr -s ' ' ' ' | cut -d';' -f2 | tr ',' '\n' | grep -v "I" | sed 's/FA/50/' | sed 's/F/55/' | sort | uniq -w 9 | cut -c7 > hours.txt
#this grade is used to do the same as the one before but with storing the hours not grades in file

while read -r line; #storing all info in array from file
do
	h+=("$line")
done < hours.txt
 

count=${#h[@]} #getting the number of elements in array


for ((i=0; i<$count; i++)) #to multiply both arrays elements and store them in the third array 
do
	multi[$i]=$(( ${h[$i]} * ${g[$i]} ))
	
done


sum_grades=0 #to store the summation of grades * their hours in it

for i in ${multi[@]}; do  #doing the summation for all elements
	let sum_grades+=$i
done


sum_hours=0 #to store the summation of hours in the array

for i in ${h[@]}; do  #doing the summation of all elements in the array
	let sum_hours+=$i
done

echo " your overall avrage > " $(( sum_grades / sum_hours ))"%"

}


HoursPerSemester(){ #this function is used to print the houre taken in each semester without the failed and incomplete

grep "EN" $fileName | tr -s ' ' ' ' | cut -d';' -f1 > years.txt

while read -r line; #reading the files with the years and semetsers stored in it
do

	declare -a h=() #an arrau to put the hours from file in it to do the calculations, and should get back to empty each for different semester calculations

	grep $line $fileName | tr -s ' ' ' ' | cut -d';' -f2 | tr ',' '\n' | grep -v "I" | grep -v "F" | grep -v "FA" | sort | uniq -w 9 | cut -c7 > hours.txt
	
	while read -r line2; #putting file info in array
	do
	        h+=("$line2")
	done < hours.txt

	count=${#h[@]} #to get the number of elements in the array
 
	sum_hours=0 #to store the summation of hours in it

	for i in ${h[@]}; do  #doing the summation of hours
        	let sum_hours+=$i
	done

	echo " All hours passed in $line > " $sum_hours 

	done < years.txt

}

AllHours(){ #this function to print all the hours taken in all semesters without fail and incomplete

declare -a h #initialling an array to store hours in it

grep "EN" $fileName | tr -s ' ' ' ' | cut -d';' -f2 | tr ',' '\n' | grep -v "I" | grep -v "F" | grep -v "FA" | sort | uniq -w 9 | cut -c7 > hours.txt
#grep used to get all the hours of all courses without the failed and incomplete and with the new grades of the courses that are existing again and putting them in a file

while read -r line; #storing file info in the array
do
	h+=("$line") 
done < hours.txt

sum_hours=0 #to store the summation of all hours in it

for i in ${h[@]}; do  #doing the summation of all elements in the array
	let sum_hours+=$i
done

echo " All hours passed > " $sum_hours 

}

Labs(){  #this function is to print the number of labs taken
count=`grep "EN" $fileName | tr -s ' ' ' ' | cut -d';' -f2 | tr ',' '\n' | grep -v "I" | grep -v "F" | grep -v "FA" | sort | uniq -w 9 | cut -c7 | grep "1" | wc -l`
#this grep is used to get all the courses without the failed and incomplete and check and get the courses with the hours equal 1 and getting the number of lines (number of labs) of that and sotre it in the variable
echo " Number of taken labs > "$count
}

Courses_Num(){ #this function is used to know the number of courses taken

count=`grep "EN" StudentRecord.txt | tr -s ' ' ' ' | cut -d';' -f2 | tr ',' '\n' | sed 's/FA/50/' | sed 's/F/55/' | sort | uniq -w 9 | wc -l`
#this grep is used to get all the courses without the failed and incomplete and  getting the number of lines (number of courses) of that and sotre it into variable
echo " Number of Courses taken > "$count

}

Percentage(){ #this function is used to get the relation between failed hours and passed hours

declare -a f  #array to store the passed courses hours in it
declare -a h #array to store the failed courses hours in it

grep "EN" $fileName | tr -s ' ' ' ' | cut -d';' -f2 | tr ',' '\n' | grep -v "I" | grep -v "F" | grep -v "FA" | sort | uniq -w 9 | cut -c7 > hours.txt
#this grep will get the courses without fail and incomplete and get the houres of them and store them in a file

while read -r line; #storing the file info in array
do
	h+=("$line")
done < hours.txt

sum_hours=0 #to store summation of passed hours

for i in ${h[@]}; do  #doing the summation of array elements
	let sum_hours+=$i
done

echo " All hours passed > " $sum_hours 

grep "EN" $fileName | tr -s ' ' ' ' | cut -d';' -f2 | tr ',' '\n' | grep "F" | sort | uniq -w 9 | cut -c 7 > fail.txt
#this grep to do the same put only to the courses with failed

while read -r line; #to store info in the array
do
	f+=("$line")
done < fail.txt

sum_fail=0 #to store summation of failed hours

for i in ${f[@]}; do #this is to do the summation of array elements
	let sum_fail+=$i
done

var=$(bc <<<"scale=2; $sum_fail/$sum_hours*100")
echo " All failed hours > " $sum_fail
echo -n " the percentage of total passed hours in relation to total F and FA hours > " 
echo $var"% fail in relation with success hours"
}

Insert(){ #this function to insert new semester to the main file

echo -n >> $fileName

echo "Insert the academic Year (ex : 2021-2022) "
read year

echo -n $year/ >> $fileName

echo "PLEASE ENTER THE SEMESTER NUMBER: (1)FOR THE FISRT SEMESTER (2)FOR THE SECOND SEMESTER (3)FOR THE SUMMER SEMESTER"
read semster 
echo -n $semster\; >> $fileName #echoing without new line

x=0 #to store the number of houres of the inserted courses

while $true # 
do
	echo "PLEASE ENTER The Course Name"
	while $true
	do 
	read course
	if [ "$course" = "ENEE" -o "$course" = "ENCS" ] #if course name is one of those print it in the file
	then
		echo -n " "$course >> $fileName
		break
	else #if not ask again for the course name
		echo "PLEASE RE-ENTER THE COURSE NAME IN THE CORRECT FORM" 
	fi
	done
	
	echo "PLEASE ENTER The Courses Number"
	while $true
	do 
	read courseNum

	if [ $courseNum -ge 2000 -a $courseNum -le 5999 ] #if course number is between 2000 and 5999 
	then
		echo -n $courseNum >> $fileName #then put it in the file
		x=$(( x + `echo $courseNum | head -c 2 | tail -c1` )) #and take the second number which is the hours of the course and add it to the previous course's hours
		break
	else #if not ask again
		echo "PLEASE RE-ENTER THE COURSE NUMBER IN THE CORRECT RANGE" 
	fi
	done

	echo "PLEASE ENTER The Courses grade"

	while $true
	do 
	read coursegrade
	

	# to print the right grade value in the file
	if [ "$coursegrade" = "F" ]
	then
		echo -n " "$coursegrade  >> $fileName
		break
	elif [ "$coursegrade" = "I" ]
	then
		echo -n " "$coursegrade  >> $fileName
		break
	elif [ "$coursegrade" = "FA" ]
	then
		echo -n " "$coursegrade  >> $fileName
		break
	elif [ $coursegrade -ge 60 -a $coursegrade -le 99 ]
	then
		echo -n " "$coursegrade  >> $fileName
		break
	else
		echo "PLEASE RE-ENTER THE COURSE GRADE IN THE CORRECT FORM" 
	fi
	done
	
	echo "ADD NEW COURSE ? Y [YES] / N [NO]"  #to ask if the user wants to add another course
	read finish
	
	if [ "$finish" = "N" ] #if no then it will check the number of hours in that semester if less than 12 it will ask for more courses
	then
		if [ $x -ge 12 ]
		then
			echo >> $fileName

			break
		else 
			echo "PLEASE REGISTER MORE COURSES LEAST LIMIT ACCEPTED IS 12 YOU ARE ONLY REGISTRED FOR $x HOURS" 
			echo -n , >> $fileName
		fi
	else 
		echo -n , >> $fileName
		continue
	fi
done
}

changeCourseGrade(){ #this function is used to change the grade of a course the user wants 

echo "PLEASE ENTER THE COURSE NAME"
read course 


echo "PLEASE ENTER THE NEW GRADE"
read newGrade

x=`grep "EN" $fileName | tr -s ' ' ' ' | cut -d';' -f2 | tr ',' '\n' | sort | uniq -w 9 | grep "$course" | cut -d' ' -f3`
#this grep is used to get the past grade of the course added and store it in the variable

sed -i "s/$course $x/$course $newGrade/" $fileName
#this will change the course with the old grade to the course with the new grade in the file
#used this method so that in will change the last occurance of the course not the first
grep "EN" $fileName | tr -s ' ' ' ' | cut -d';' -f2 | tr ',' '\n' | sort | uniq -w 9 | grep "$course"
#this grep to print the course with it's new value
}


#show the menu to the user
while $true 
do
Menu
read x 
case "$x" #used to call functions for each request on the menu
in
1) Show;;
2) Search;;
3) AverageAll;;
4) AverageForSemesters;;
5) AllHours;;
6) Percentage;;
7) HoursPerSemester;;
8) Courses_Num;;
9) Labs;;
10) Insert;;
11) changeCourseGrade;;
*) echo "please enter valid input" 
 continue;;
esac

done	


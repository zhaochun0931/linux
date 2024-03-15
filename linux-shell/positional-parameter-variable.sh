$0 being the script’s name, $1 being the fi rst parameter, $2 being the second parameter, and so on, up to $9 for the ninth parameter

cat 1.sh

echo the file name is $0
echo the 1st parameter is $1
echo the 2nd parameter is $2
echo the 3rd parameter is $3
echo the 4th parameter is $4
echo the 5th parameter is $5
echo the 6th parameter is $6
echo the 7th parameter is $7
echo the 8th parameter is $8
echo the 9th parameter is $9
echo the 10th parameter is ${10}
echo the 11th parameter is ${11}
echo



./1.sh 5 9 11 12 34 23 56 23 12 16
the file name is ./1.sh
the 1st parameter is 5
the 2nd parameter is 9
the 3rd parameter is 11
the 4th parameter is 12
the 5th parameter is 34
the 6th parameter is 23
the 7th parameter is 56
the 8th parameter is 23
the 9th parameter is 12
the 10th parameter is 16
the 11th parameter is

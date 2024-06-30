# If no variable is used with the read command, the input value is stored in the $REPLY variable
read

echo $REPLY





# The method of taking the single or multiple variables using a read command
read name age
echo $name
echo $age





#
read -p "please input the name: " name

echo $name


# The input value of the password will not be displayed for the -s option.
read -sp "please input the password: " password
echo $password





name1=xxx
echo "new name is: " $name1

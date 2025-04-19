# no space before or after the = sign
MYVAR=xiaoming
echo $MYVAR




# MYVAR=xiaoming
#
#
# echo $MYVAR
xiaoming
#





# myvar=helloworld
# echo $myvar
helloworld
#








# The unset command allows for the deletion of a variable
unset username

# It is strongly recommended to protect variables with quotes
address='china beijing'
echo $address


# To isolate the name of the variable from the rest of the text, you must use quotes or braces:

file=file_name
touch "$file"1
touch ${file}2

# The systematic use of braces is recommended.






# Environment variables and system variables are variables used by the system for its operation. By convention these are named with capital letters.

# The env command displays all the environment variables used.
env

# The set command displays all used system variables.
set


# The export command allows you to export a variable.







# substitute commands
mydate=`date`
echo $mydate


# mydate=`date`
# echo $mydate
Sat Apr 19 12:54:46 PM UTC 2025
#



# Preferred syntax
mydate=$(date)
echo $mydate

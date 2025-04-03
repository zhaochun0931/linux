# The character = assigns content to a variable
# There is no space before or after the = sign
username=xiaoming



# Once the variable is created, it can be used by prefixing it with a dollar $
echo $username



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



# Substitute commands
mydate=`date`
echo $mydate

sleep 1


# Preferred syntax
mydate=$(date)
echo $mydate





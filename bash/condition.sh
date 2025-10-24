In Linux shell scripting (Bash), conditions are used in if, while, and until statements to control program flow.

They typically appear inside [ ... ] or [[ ... ]], and evaluate to true or false depending on what you’re testing.




🧩 1. Basic Syntax
Single-bracket test:
[ condition ]

Double-bracket test (modern Bash, more powerful):
[[ condition ]]






🧠 2. Common Types of Conditions
🔹 String comparisons
[ "$a" = "$b" ]     # equal
[ "$a" != "$b" ]    # not equal
[ -z "$a" ]         # string is empty
[ -n "$a" ]         # string is not empty

🔹 Number comparisons
[ $a -eq $b ]   # equal
[ $a -ne $b ]   # not equal
[ $a -lt $b ]   # less than
[ $a -le $b ]   # less than or equal
[ $a -gt $b ]   # greater than
[ $a -ge $b ]   # greater than or equal


Example:

x=5
if [ $x -gt 3 ]; then
  echo "x is greater than 3"
fi

🔹 File tests
[ -e file ]   # file exists
[ -f file ]   # regular file
[ -d dir ]    # directory
[ -r file ]   # readable
[ -w file ]   # writable
[ -x file ]   # executable
[ file1 -nt file2 ]  # newer than
[ file1 -ot file2 ]  # older than


Example:

if [ -d /etc ]; then
  echo "/etc exists"
fi

🔹 Logical operators
[ condition1 ] && [ condition2 ]   # AND
[ condition1 ] || [ condition2 ]   # OR
! [ condition ]                    # NOT


Or, with double brackets:

[[ $x -gt 3 && $y -lt 10 ]]
[[ $a = "yes" || $b = "y" ]]






🧩 1. test Command

test is an external command (a binary usually located at /usr/bin/test) used to evaluate expressions.


If the condition is true, the exit code is 0; if false, it’s 1.
You can check it via $?.







🧱 2. [ ] — test with shell syntax sugar

[ ] is just a synonym for test, but implemented as a shell builtin.
They behave the same, except that you must add spaces inside the brackets.



❗ Common pitfalls:

You need spaces after [ and before ]

You must quote variables to avoid syntax errors:

[ "$var" = "foo" ]





🧠 3. [[ ]] — modern Bash conditional expression

[[ ... ]] is a Bash keyword (not an external command or simple builtin).
It offers enhanced syntax and safety, and is recommended for Bash scripts.

Advantages:

✅ No need to quote variables (safe from word-splitting)
✅ Supports pattern matching (==, !=, =~)
✅ Supports logical operators &&, || directly inside

Example:

name="xiaoming"
if [[ $name == xiao* ]]; then
  echo "Pattern match works!"
fi

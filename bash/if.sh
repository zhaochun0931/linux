🧠 1. Basic Syntax

if [ condition ]; then
    # commands if true
else
    # commands if false
fi


✅ Example:

if [ "$USER" = "root" ]; then
    echo "You are root"
else
    echo "You are not root"
fi





💡 3. Using Double Brackets

[[ ... ]] is more powerful — it allows regex, pattern matching, and no need to quote variables usually.


if [[ $var == "abc" || $var == "xyz" ]]; then
    echo "var is abc or xyz"
fi




🚀 8. With Command Exit Codes

You can use if directly with commands — no brackets:

if ping -c1 8.8.8.8 &>/dev/null; then
    echo "Network OK"
else
    echo "Network down"
fi






🧠 Pro Tip:

Always put spaces around brackets [ and ].
These are actually separate commands, not part of the shell syntax.

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




🧠 Pro Tip:

Always put spaces around brackets [ and ].
These are actually separate commands, not part of the shell syntax.

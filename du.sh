The du command allows you to displays the amount of space that is being used by files in a directory.





By default, the du command displays the disk usage in kilobytes.






At the end of the list, the du command always shows the grand total for the current directory. To display only this information, supply the -s command line option:


du -sh *

du -sh * | sort -h

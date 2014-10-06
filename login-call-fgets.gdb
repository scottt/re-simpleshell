set disassemble-next-line 1

file simpleshell
break *0x8048935
run
# "login"
x/4a $esp

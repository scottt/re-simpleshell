set disassemble-next-line 1

file simpleshell
break *0x804899e
run
# "login"
# "admin"
x/4a $esp

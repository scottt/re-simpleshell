set disassemble-next-line 1

set target-async 1
set non-stop 1
set pagination 0

source gdbstdioredirect.py
inferior-stdin-redirect
set environment LD_PRELOAD=./override-time.so

file simpleshell

# MAIN_ADDR=0x8048c76
break *0x8048c76
run
# main hit
inferior-stdin-write login\n
inferior-stdin-write admin\n
inferior-stdin-write DoYouThinkThisIsPassword\n

# LOGIN_COMMAND=0x80488fd
#break *0x80488fd

# SPECIAL_DATA_INIT_END=0x8048c74
break *0x8048c74
continue
printf "eax: 0x%x, SPECIAL_DATA: 0x%x, TIME_AT_INIT: 0x%x\n", $eax, *(int*)0x804a548, *(int*)0x804a54c
p/a $eax

# MAGIC_SEQUENCE=0x8048a41
# MUTATE_PASSWORD_LOOP=0x80489c5
# MAGIC_SEQUENCE2=0x8048aa7
# LOGGED_IN=0x8048a87
# PASSWORD_STRCMP=0x8048a5e
# CHANGE_PASSWORD=0x80489f0
# CHANGE_PASSWORD1=0x8048a39

break *0x80489f0
commands
printf "CHANGE_PASSWORD\n"
# dump LOGIN_FGETS_BUF_FOR_PASSWORD
p (char*)$ebp + (-0x54)
x/24xc (char*)$ebp + (-0x54)
# quit
end

break *0x8048a39
commands
printf "CHANGE_PASSWORD1\n"
# dump LOGIN_FGETS_BUF_FOR_PASSWORD
p (char*)$ebp + (-0x54)
x/24xc (char*)$ebp + (-0x54)
# quit
end

break *0x8048a5e
commands
printf "PASSWORD_STRCMP\n"
printf "strcmp(\"%s\", \"%s\")\n", *(char**)$esp, *(char**)($esp+4)
end

continue

# watch *0xffffcdf4
# until PASSWORD_STRCMP
# until *0x8048a5e

# inferior-stdin-write flag\n
# inferior-stdin-write exit\n
# quit

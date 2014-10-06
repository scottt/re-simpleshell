set disassemble-next-line 1

set target-async 1
set non-stop 1
set pagination 0

source gdbstdioredirect.py
inferior-stdin-redirect

file simpleshell

break time

# MAIN_ADDR=0x8048c76
break *0x8048c76
run
# main hit
inferior-stdin-write login\n
inferior-stdin-write admin\n
inferior-stdin-write DoYouThinkThisIsPassWord\n

continue

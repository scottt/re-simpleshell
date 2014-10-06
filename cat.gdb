set disassemble-next-line 1

set target-async 1
set non-stop 1
set pagination 0

source gdbstdinredirect.py
inferior-stdin-redirect

file /bin/cat

start
# main hit
inferior-stdin-write hello\n
continue

set disassemble-next-line 1

file simpleshell
break *0x80488fd
run
watch *0xffffcdf4
continue

from __future__ import print_function

import sys
import os
import pty
import logging
import threading

# source this script from GDB
import gdb

gdb.execute('set python print-stack full')

def _inferior_stdin_switch():
    '-> master_pty_fd'
    (master_fd, slave_fd) = pty.openpty()
    slave_pty_name = os.ttyname(slave_fd)
    # https://sourceware.org/gdb/onlinedocs/gdb/Input_002fOutput.html#index-inferior-tty
    logging.debug('set inferior-tty %s' % (slave_pty_name,))
    gdb.execute('set inferior-tty %s' % (slave_pty_name,))
    return master_fd

inferior_pty_master_fd = None
inferior_pty_thread = None

def dump_fd_forever(fd):
    while 1:
        d = os.read(fd, 4096)
        if d == '':
            time.sleep(1)
        # hard coding dump to STDOUT, i.e. file descriptor 1
        os.write(1, d)

class InferiorStdinRedirect(gdb.Command):
    def __init__(self):
        gdb.Command.__init__(self, 'inferior-stdin-redirect', gdb.COMMAND_USER, gdb.COMPLETE_NONE, prefix=False)

    def invoke(self, arg, from_tty):
        global inferior_pty_master_fd
        global inferior_pty_thread
        inferior_pty_master_fd = _inferior_stdin_switch()
        inferior_pty_thread = threading.Thread(name='inferior-pty', target=dump_fd_forever, args=(inferior_pty_master_fd,))
        inferior_pty_thread.setDaemon(True)
        inferior_pty_thread.start()

class InferiorStdinWrite(gdb.Command):
    'inferior-stdin-write STRING. STRING can contain escape sequences like \\n'
    def __init__(self):
        gdb.Command.__init__(self, 'inferior-stdin-write', gdb.COMMAND_DATA, gdb.COMPLETE_NONE, prefix=False)

    def invoke(self, arg, from_tty):
        global inferior_pty_master_fd
        logging.debug('inferior-stdin-write: arg: %r' % (arg,))
        data = arg.decode('string_escape') 
        logging.debug('inferior-stdin-write: %r' % (data,))
        i = gdb.selected_inferior()
        if inferior_pty_master_fd is None:
            gdb.write('inferior-stdin-write: must invoke inferior-stdin-redirect first\n', gdb.STDERR)
            return
        os.write(inferior_pty_master_fd, data)

InferiorStdinRedirect()
InferiorStdinWrite()

logging.basicConfig(level=logging.INFO)

from __future__ import print_function

TIME_AT_INIT = 0x97

def special_data(TIME_AT_INIT):
    SPECIAL_DATA = ((TIME_AT_INIT << 0x10) - TIME_AT_INIT + 0x7a69) & 0xffffffff
    return SPECIAL_DATA

for i in xrange(1, 65536):
    if special_data(i) & 0xff == 0:
        print(i)

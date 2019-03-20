#!/usr/bin/env python
# -*- coding:utf-8 -*-

import fileinput
import re
import base64
import mimetypes
import os


def replacement(match):

    fn = match.groups()[0]

    if os.path.isfile(fn):
        return 'src="data:%s;base64,%s"' % (mimetypes.guess_type(fn)[0], base64.b64encode(open(fn, 'rb').read()))

    return match.group()



def main():

    fi = fileinput.FileInput(openhook=fileinput.hook_encoded("utf8"))

    while True:
        line = fi.readline()
        if not line:
            break
        print re.sub(r'src="(.*?)"', replacement, line).encode('utf-8'),



if __name__ == '__main__':
    main()

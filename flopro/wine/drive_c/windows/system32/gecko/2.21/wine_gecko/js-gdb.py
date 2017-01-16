""" GDB Python customization auto-loader for js shell """

import os.path
sys.path[0:0] = [os.path.join('/tmp/buildd/wine-gecko-2.21-2.21+dfsg2/js/src', 'gdb')]

import mozilla.autoload
mozilla.autoload.register(gdb.current_objfile())

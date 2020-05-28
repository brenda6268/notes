# python signal


wp_id: 632
Status: publish
Date: 2017-07-24 19:15:00
Modified: 2017-07-24 19:15:00


Any thread can perform an alarm(), getsignal(), pause(), setitimer() or getitimer(); only the main thread can set a new signal handler, and the main thread will be the only one to receive signals

# default handlers:

signal.SIG_DFL

This is one of two standard signal handling options; it will simply perform the default function for the signal. For example, on most systems the default action for SIGQUIT is to dump core and exit, while the default action for SIGCHLD is to simply ignore it.

signal.SIG_IGN

This is another standard signal handler, which will simply ignore the given signal.

# assign handerls:
signal.signal(signalnum, handler)

Set the handler for signal signalnum to the function handler. handler can be a callable Python object taking two arguments

handler: handler(signum, frame)

# example

```
import signal, os

def handler(signum, frame):
    print 'Signal handler called with signal', signum
    raise IOError("Couldn't open device!")

# Set the signal handler and a 5-second alarm
signal.signal(signal.SIGALRM, handler)
signal.alarm(5)

# This open() may hang indefinitely
fd = os.open('/dev/ttyS0', os.O_RDWR)

signal.alarm(0)          # Disable the alarm
```

Reference:

1. https://docs.python.org/2/library/signal.html
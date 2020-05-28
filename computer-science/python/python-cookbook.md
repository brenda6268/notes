# 阅读《Python Cookbook》笔记


wp_id: 648
Status: draft
Date: 2018-06-22 09:04:00
Modified: 2020-05-16 11:12:50


packing

unpack, If mismatch, you will get an error
you can use star expression a, *b, c = vals 

naming a slice

s = slice(0, 100, 2)
s.start, s.stop, s.step

itertools.groupby

ChainMap
if you want to use a combined dict, but you don't want actrually update one with another, 

strings

re.split

startswith and endswith accept multi-arguments

for shell like globing, us fnmatch.fnmatch

notice re.DOTALL

use str.transform if you have too many characters to replace

use textwrap.fill to fix text in fixed columns

tokenize strings

use re.compile(ptn).scanner.

numbers

use the builtin `round` function

use int.from_bytes and int.to_bytes to convert integer from and to bytes representaion

use the pytz module

iterators

zip and itertools.zip_longest

use itertools.chain

use pipelining

`yield` acts like a kind of data producer whereas a `for loop` acts as a data consumer

files

use gzip or bz2.open to open compressed files

use PySerial for serail communication

use base64.b64decode / base64.b64encode

use the pandas lib

functions

docorators

one problem with decorator is that there arguments are given at define time, not run time. use adjustable attributes to overcome this.

defining decorator as class methods is just the same as defining them as normal functions

using class as decorators is not a good idea.

when applying decorators to methods, make sure `classmethod` or `staticmethod` is the last.

using decorators to add dryrun ability is pretty cool

writing decorators for classes is the same as for functions: A = dec(A)

consider replacing single-method-classes with functions than return a function

classes

context-manager protocol

implement the __enter__ and __exit__ functions.

__enter__ returns the context variable __exit__(self, exception_type, exception_val, trace_back) may return True to indicate the exception has already been handled.

using __slots__ = [*attribs] to save class memory

the dismond problem is solved with MRO with C3 serialization

inheriting from collections' abcs, rather than inheriting from builtins

when you want a __init__ to have multiple functions, consider using a class constructor

using __new__ precedes __init__

when two objects are cyclic referring each other, use weakref.ref

python mainly uses naive referrence counting for gc, and a peroidically collector for cyclic refs

import

use relative import in packages

no __init__.py means a namespace package

use imp.reload to reload packages

add __main__.py to run a directory or zip file as a python script

use pkgutil.get_data(__package__, datafilename) to read package data

use setup.py to distribute your package

from distutils.core import setup

setup(name='projectname',
        version='1.0',
        author='Yifei Kong',
        author_email='kongyifei@gmail.com',
        url='',
        package=['projectname', 'projectname.utils']
)

then

python setup.py sdist # you will get a zip file

networks

use the ipaddress module to create ip address

net = ipaddress.ip_network('192.168.0.1/24')
ip = ipaddress.ip_address('192.168.0.1')
ip in net # True

use hmac to do simple process authentication

ssl mixin

class SSLMixin(object):
    '''Mixin class that adds support for ssl to existing servers based on the socketserver module'''

    def __init__(self, *args, keyfile=None, certfile=None, ca_certs=None, cert_reqs=ssl.NONE, **kwargs):
        self.ssl_options = {
                'keyfile': keyfile,
                'certfile': certfile,
                'ca_cert': ca_cert,
                'cert_reqs': cert_reqs
        }
        super().__init__(*args, **kwargs)

    def get_request(self):
        client, addr = super().get_request()
        client_ssl = ssl.wrap_socket(client, **self._ssl_options, server_side=True)
        return client_ssl, addr

concurrency

using queue to communicate between threads.

use a sentinel value to flag the queue has been ended. `sentinel = object()`

sentinel = object()

def producer(q):
    while running:
        q.put(data)
    q.put(sentinel)

def consumer1(q):
    while True:
        data = q.get()
        if data is sentinel:
            q.put(sentinel)  # NOTE place it back, so other consumers knows thsi
            break

if you want to know paticular message has been consumed, pair the data with an Event object.

def producer(q):
    while running:
        evt = Event()
        q.put((data, evt))
        ...
        evt.wait()


def consumer(q):
    while True:
        data, evt = q.get()
        ....
        evt.set()


the best practice is to pass only immutable data structure in thread, so that no object reference is copied.

if you encounter a qsize problem. it's not good.

locking

use threading.Lock for each object to lock, each new instance gets its own lock. if one thread holds more than one lock, there maybe a deadlock problem.

class SharedCounter(object):
    def __init__(self, value):
        self._value = value
        self._lock = threading.Lock()
    def incr(self, delta):
        with self._lock:
            self._value += delta

or you could use a threading.RLock as a class variable not object variable, in this implementation, only one lock is created for all instances of this class. but it's not as fine-grained as above.

class SharedCounter(object):
    _lock = threading.RLock()
    def __init__(self, value):
        self._value = value
    def incr(self, delta):
        with self._lock:
            self._value += delta

a threading.Semaphore is a synchronization primitive based on a shared counter, if the counter is nonzero, the with statement decrements the count and a thread is allowed to proceed.

work_sema = threading.semaphore(5) # max 5 workers

def work(value)
    with work_sema:
        do_work(value)

deadlock

cause of deadlock: threads trying to acquire more than one lock

solution: each thread acquires locks in a pre-defined order

other solution: use a watch dog timer, if the process does not reset the timer, then it must be deadlocked

# define a ordered lock acquirer
_local = threading.local()

@contextmanager
def acquire(*locks):
    # sort locks by object identifier
    locks = sorted(locks, key=lambda: x: id(x))
    # make sure lock order of previously acquired locks is not violated
    acquired = getattr(_local, 'acquired', [])
    if acquired and max(id(lock) for lock in acquired) >= id(locks[0]):
        raise RuntimeError('Lock Order Violation')
    # acquire all of the locks
    acquired.extend(locks)
    _local.acquired = acquired
    try:
        for lock in locks:
            lock.acquire()
        yeild
    finally:
        # release locks in reverse order of acquistion
        for lock in reversed(locks):
            lock.release()
        del acquired[-len(locks):]

# usage
with acquire(lock1, lock2):
    do_work()

use threading.local to store thread specific values

when using multiprocessing, remember that data and function has to be serialized to call in another process. i.e. only plain `def` functions can be used, no lambdas, no closures, no callable instances, etc.

Actor model

an actor is a concurrently executing task that simply acts upon messages sent to it. communication with actors is one-way and asynchronous.

it can be defined using a thread and a queue.

# sentinel used for shutdown
class ActorExit(Exception):
    pass

class Actor(object):
    def __init__(self):
        self._mailbox = queue.Queue()
    def send(self, msg):
        self._mailbox.put(msg)
    def recv(self):
        msg = self._mailbox.get()
        if msg is ActorExit:
            raise ActorExit()
        return msg
    def close(self):
        self.send(ActorExit)
    def start(self):
        self._terminated = threading.Event()
        t = threading.Thread(target=self._bootstrap)
        t.daemon = True
        t.start()
    def _bootstrap(self):
        try:
            self.run()
        except ActorExit:
            pass
        finally:
            self._terminated.set()
    def join(self):
        self._terminated.wait()
    def run(self):
        while True:
            msg = self.recv():
            print 'Got: ' + msg

# Usage
p = Actor()
p.start()
p.send('hello')  # prints hello
p.send('world')  # prints world
p.close()
p.join()

by using actors, you simply send a message to the actor using `send`. subclassing actor and reimplement `run` to get your own actors. actors are very easy to scale up in systems using message queues.

Yifei: one way to extend actor may be using select to poll multiple queues.

Pollable Queues

create a queue that can be polled using select, which is very efficient.

class PollableQueue(queue.Queue):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._putsocket, self._getsocket = socke.sockepair()
    def fileno(self):
        return self._getsocket.fileno()
    def _put(self, item):
        super()._put(item)
        self._putsocket.send(b'x')
    def _get(self):
        self._getsocket.recv(1)
        return super._get()

def consumer(queues):
    while True:
        can_read, _, _ = select.select(queues, [], [])
        fro r in can_read:
            item = r.get()
            print('Got: ' + item)

Launching a daemon process

Utilities

use fileinput.input() to recv input from file or stdin

prefer raise SystemExit(msg) over sys.exit

use getpass.getuser and getpass.getpass to recv user input

use os.get_terminal_size to get terminal size

use subprocess.check_output to call external commands.

try:
    out_bytes = subprocess.check_output(cmd, stderr=subprocess.STDOUT, shell=True, timeout=5)
except subprocess.CalledProcessError as e:
    print e.output
    print e.returncode

by default, check_output only captures stdout, not stderr

if you want to send input to external program, you will have to use subprocess.Popen

p = subprocess.Popen(['wc'], stdout=subprocess.PIPE, stdin=subprocess.PIPE)
stdout, stderr = p.communicate('hello, world')

use shutil to copy and move files

shutil.copy(src, dst)
shutil.copy2(src, dst)  # perseves meta
shutil.copytree(src, dst)
shutil.move(src, dst)
shutil.make_archive()
shutil.unpack_archive()

os.walk(dir) iterates the dir

logging.basicConfig can only be called once in your program, it outputs to stderr by default.
use logging.getLogger().level = logging.DEBUG to configure the level if basicConfig has been called.

logging in a library

log = logging.getLogger(__name__)
log.addHandler(logging.NullHandler())

log.debug(...)

logging can be independently configured for the lib.

logging.getLogger('lib').level = ...

use resource.setrlimit to limit cpu and memory usage

C interface

ctypes is just too hard to use, use cffi
# Python `-m`


ID: 688
Status: publish
Date: 2017-05-30 13:19:00
Modified: 2017-05-30 13:19:00


## How `-m` is invoked

if you have a module foo

write
foo/
    __init__.py
    __main__.py

then python -m foo will execute __main__.py

https://pythonwise.blogspot.sg/2015/01/python-m.html

json pretty print

cat some_json_file | python -m json.tool

zipfile

zipfile.py -l zipfile.zip        # Show listing of a zipfile
zipfile.py -t zipfile.zip        # Test if a zipfile is valid
zipfile.py -e zipfile.zip target # Extract zipfile into target dir
zipfile.py -c zipfile.zip src ... # Create zipfile from sources

gzip

python -m gzip wordlist.txt  # Will create wordlist.txt.gz
python -m gzip -d wordlist.txt.gz  # Will extract to wordlist.txt

filecmp

compare two directories

$ python -m filecmp /tmp/a /tmp/b
diff /tmp/a /tmp/b
Only in /tmp/a : ['1']
Only in /tmp/b : ['2']
Identical files : ['4']
Differing files : ['3']


Several modules lets you encode/decode in various formats:
	• base64
	• uu
	• encodings.rot_13
	• binhex
	• mimify
	• quopri
For example
$ echo 'secertpassword' | python -m encodings.rot_13
frpregcnffjbeq

servers

python -m SimpleHTTPServer # 2
python -m http.server #3

python -m pydoc {module/func}

Profiling

python -m cProfile script.py
python -m timeit script.py
python -m pstats script.py
python -m trace script.py
# Python 中的序列化库


wp_id: 641
Status: publish
Date: 2017-05-30 01:47:00
Modified: 2020-05-16 12:06:34


## basic usage

```
pickle.dumps(obj)  # dumps a object to a bytes, not binary safe
pickle.loads(bytes)  # loads a object from a bytes.
```

## tricks

pickling dict is stable

```
In [5]: pickle.dumps({"a": "b", "1": "2"})
Out[5]: b"\x80\x03}q\x00(X\x01\x00\x00\x001q\x01X\x01\x00\x00\x002q\x02X\x01\x00\x00\x00aq\x03X\x01\x00\x00\x00bq\x04u."

In [6]: pickle.dumps({"1": "2", "a": "b"})
Out[6]: b"\x80\x03}q\x00(X\x01\x00\x00\x001q\x01X\x01\x00\x00\x002q\x02X\x01\x00\x00\x00aq\x03X\x01\x00\x00\x00bq\x04u."
```

## json
```
json.dumps(dict,
    sort_keys=True,  # keys will be in order
)
```
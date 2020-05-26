# Python 中的序列化库


ID: 641
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
In [5]: pickle.dumps({&#039;a&#039;: &#039;b&#039;, &#039;1&#039;: &#039;2&#039;})
Out[5]: b&#039;\x80\x03}q\x00(X\x01\x00\x00\x001q\x01X\x01\x00\x00\x002q\x02X\x01\x00\x00\x00aq\x03X\x01\x00\x00\x00bq\x04u.&#039;

In [6]: pickle.dumps({&#039;1&#039;: &#039;2&#039;, &#039;a&#039;: &#039;b&#039;})
Out[6]: b&#039;\x80\x03}q\x00(X\x01\x00\x00\x001q\x01X\x01\x00\x00\x002q\x02X\x01\x00\x00\x00aq\x03X\x01\x00\x00\x00bq\x04u.&#039;
```

## json
```
json.dumps(dict,
    sort_keys=True,  # keys will be in order
)
```
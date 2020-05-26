# Gracefully shutdown inside a event loop


ID: 690
Status: publish
Date: 2017-06-18 08:37:00
Modified: 2017-06-18 08:37:00


```
try:
    loop.run_forever()
finally:
    loop.run_until_complete(loop.shutdown_asyncgens())
    loop.close()
```
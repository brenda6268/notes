# Gracefully shutdown inside a event loop

<!--
ID: 922ead23-e96e-43a4-93a1-8e6d6102de2a
Status: publish
Date: 2017-06-18T08:37:00
Modified: 2017-06-18T08:37:00
wp_id: 690
-->

```
try:
    loop.run_forever()
finally:
    loop.run_until_complete(loop.shutdown_asyncgens())
    loop.close()
```
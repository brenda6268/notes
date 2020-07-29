# Python 读写 CSV 文件

<!--
ID: 68e0d1d1-6b5f-49d5-9876-8d07ecafd6ad
Status: publish
Date: 2017-05-29T14:14:00
Modified: 2020-05-16T12:08:46
wp_id: 664
-->

## typical usage


注意dictwriter需要提供fieldnames

```py
with open("csvfile", "wt", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=[], extrasaction="ignore")
    writer.writeheader()
    writer.writerow(d) # list of dict if writerows

with open("csvfile", "wt", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(l) # list of list if writerows

with open("csvfile", "rt") as f:
    reader = csv.reader(f)
    for row in reader:
        print(row)
```
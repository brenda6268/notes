# Python 读写 CSV 文件


wp_id: 664
Status: publish
Date: 2017-05-29 14:14:00
Modified: 2020-05-16 12:08:46


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
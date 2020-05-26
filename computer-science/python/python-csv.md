# Python 读写 CSV 文件


ID: 664
Status: publish
Date: 2017-05-29 14:14:00
Modified: 2020-05-16 12:08:46


## typical usage


注意dictwriter需要提供fieldnames
```
with open(&#039;csvfile&#039;, &#039;wt&#039;, newline=&#039;&#039;) as f:
    writer = csv.DictWriter(f, fieldnames=[], extrasaction=&#039;ignore&#039;)
    writer.writeheader()
    writer.writerow(d) # list of dict if writerows

with open(&#039;csvfile&#039;, &#039;wt&#039;, newline=&#039;&#039;) as f:
    writer = csv.writer(f)
    writer.writerow(l) # list of list if writerows

with open(&#039;csvfile&#039;, &#039;rt&#039;) as f:
    reader = csv.reader(f)
    for row in reader:
        print(row)
```
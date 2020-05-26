# 安卓的 AsyncTask


ID: 534
Status: publish
Date: 2017-11-15 05:05:00
Modified: 2020-05-16 11:54:08


asynchronusally run task without explicitly creating thread.

# Usage

```
doInBackground(Params...)
onProgressUpdate(Progress...)
onPostExecute(Result)
```

Here is an example of subclassing:

```
 private class DownloadFilesTask extends AsyncTask&lt;URL, Integer, Long&gt; {
     protected Long doInBackground(URL... urls) {
         int count = urls.length;
         long totalSize = 0;
         for (int i = 0; i &lt; count; i++) {
             totalSize += Downloader.downloadFile(urls[i]);
             publishProgress((int) ((i / (float) count) * 100));
             // Escape early if cancel() is called
             if (isCancelled()) break;
         }
         return totalSize;
     }

     protected void onProgressUpdate(Integer... progress) {
         setProgressPercent(progress[0]);
     }

     protected void onPostExecute(Long result) {
         showDialog(&quot;Downloaded &quot; + result + &quot; bytes&quot;);
     }
 }
```
 
Once created, a task is executed very simply: 

```
new DownloadFilesTask().execute(url1, url2, url3);
```

template parameters can be `Void, Void, Void`


see https://developer.android.com/reference/android/os/AsyncTask.html
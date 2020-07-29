# 安卓的 AsyncTask

<!--
ID: a45289be-460b-42eb-b296-0d04fbb419cc
Status: publish
Date: 2017-11-15T05:05:00
Modified: 2020-05-16T11:54:08
wp_id: 534
-->

asynchronusally run task without explicitly creating thread.

## Usage

```java
doInBackground(Params...)
onProgressUpdate(Progress...)
onPostExecute(Result)
```

Here is an example of subclassing:

```java
private class DownloadFilesTask extends AsyncTask<URL, Integer, Long> {
    protected Long doInBackground(URL... urls) {
        int count = urls.length;
        long totalSize = 0;
        for (int i = 0; i < count; i++) {
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
        showDialog("Downloaded " + result + " bytes");
    }
}
```
 
Once created, a task is executed very simply: 

```java
new DownloadFilesTask().execute(url1, url2, url3);
```

template parameters can be `Void, Void, Void`


see https://developer.android.com/reference/android/os/AsyncTask.html
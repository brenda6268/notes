# Android Service

<!--
ID: d4f47569-bf83-4642-912d-b712e01e1dbf
Status: draft
Date: 2018-04-04T05:57:00
Modified: 2020-05-16T11:33:24
wp_id: 531
-->

Yifei's Notes

by default, normal services run in the main thread, consider moving it's heavy work to another thread.
Service can also be killed by the system, if you want it to be long running, start it as a foreground service, which will show a notification bar.
good but somewhat outdated tutorial: http://blog.csdn.net/guolin_blog/article/details/11952435

Usually, foreground service is enough

Service vs IntentService

There are two kinds of service:

	1. IntentService, you have only to care one method, this class implements a queue and a thread, and will process each intent one by one, and stop self automatically. runs in a different thread.
	
	2. normal Service, runs the  same thread as the UI.

The three primary features of an IntentService are:
	• the background thread
	• the automatic queuing of Intents delivered to onStartCommand(), so if one Intent is being processed by onHandleIntent() on the background thread, other commands queue up waiting their turn
	• the automatic shutdown of the IntentService, via a call to stopSelf(), once the queue is empty
[1] http://stackoverflow.com/questions/15524280/service-vs-intentservice

we will be talking about normal services from now on.
	
System Service vs Local Service

use Context.getSystemService(Constant) to get predefined system service


Foreground Service vs Service

Notification notification = new Notification(R.drawable.icon, getText(R.string.ticker_text), System.currentTimeMillis());
Intent notificationIntent = new Intent(this, ExampleActivity.class);
PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, 0);
notification.setLatestEventInfo(this, getText(R.string.notification_title), getText(R.string.notification_message), pendingIntent);
startForeground(ONGOING_NOTIFICATION_ID, notification);


Implementing a service

 you have to implement onStart/onStartCommand/onDestroy
Service.onCreate	like the onCreate of Activity	called the first time startService is called	
Service.onStartCommand	return code to determine service should be recreated after being killed	will be called each time startService is called	just return super.onStartCommand, which returns START_STICKY
Service.onDestroy	release your resources here	called when stopService() is called*	
Service.onBind()		called when an activity bind to the service	

Note: *

start_sticky will not stop the service from dying , use foreground service

<service android:name="com.example.servicetest.MyService" >

public class MyService extends Service {  
  
    public static final String TAG = "MyService";  
  
    @Override  
    public void onCreate() {  
        super.onCreate();  
        Log.d(TAG, "onCreate() executed");  
    }  
  
    @Override  
    public int onStartCommand(Intent intent, int flags, int startId) {  
        Log.d(TAG, "onStartCommand() executed");  
        return super.onStartCommand(intent, flags, startId);  
    }  
      
    @Override  
    public void onDestroy() {  
        super.onDestroy();  
        Log.d(TAG, "onDestroy() executed");  
    }  
  
    @Override  
    public IBinder onBind(Intent intent) {  
        return null;  
    }  
  
}  


Start a service

from any activity, call Context.startService(Intent)

Activity.startService(intent)	start a service
Avtivity.bindService()	bind a service
Acitvity.stopService(intent)	stop a service

if the service is started using bindService,  you have to call unbindService to end the servcie
if the service is started using startService, you have to call stopServcie to end the servcie.
if a service is started by startService and later bound to an activity, you have to call both.


Foreground Service

put this is onCreate method of Service

Intent notificationIntent = new Intent(this, MainActivity.class);
PendingIntent pendingIntent = PendingIntent.getActivity(this, 0,
                notificationIntent, 0);
Notification notification = new NotificationCompat.Builder(this)
                .setSmallIcon(R.mipmap.app_icon)
                .setContentTitle("My Awesome App")
                .setContentText("Doing some work...")
                .setContentIntent(pendingIntent).build();
startForeground(1337, notification);

Notification notification = new Notification(R.drawable.icon, getText(R.string.ticker_text),
        System.currentTimeMillis());
Intent notificationIntent = new Intent(this, ExampleActivity.class);
PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, 0);
notification.setLatestEventInfo(this, getText(R.string.notification_title),
        getText(R.string.notification_message), pendingIntent);
startForeground(ONGOING_NOTIFICATION_ID, notification);



Note the 1337 is just some random unique apk-wide id


• use startForeground, the system considers it's something the user is using, thus not likely to be killed.
• set a guardian process to restart your service once it's killed
	a. if not rooted, install a helper apk receive PACKAGE_RESTARTED
	b. if rooted, start an shell to restart your service

• use alarm manager to start service periodically

https://stackoverflow.com/questions/2785843/how-can-i-prevent-my-android-app-service-from-being-killed-from-a-task-manager

check a service is running or not

https://stackoverflow.com/questions/600207/how-to-check-if-a-service-is-running-on-android

private boolean isMyServiceRunning(Class<?> serviceClass) {
    ActivityManager manager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
    for (RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
        if (serviceClass.getName().equals(service.service.getClassName())) {
            return true;
        }
    }
    return false;
}
# android intent


wp_id: 541
Status: publish
Date: 2017-07-06 11:40:00
Modified: 2017-07-06 11:40:00


You should use intent to communicate between activities and services

# intent extra
## package data from activity

create a intent instance

Intent intent = new Intent(getBaseContext(), SignoutActivity.class);
intent.putExtra("key", value);
startActivity(intent);

## package data from service

Intent intent = new Intent(context, SignoutActivity.class);
intent.putExtra("key", value);
startService(intent);


## Access data in activity

Access that intent on next activity
String s = getIntent().getStringExtra("EXTRA_SESSION_ID");
The docs for Intents has more information (look at the section titled "Extras").

## Access data in Service

just use the Intent parameter from onStartCommand

public int onStartCommand (Intent intent, int flags, int startId) {
    String userID = intent.getStringExtra("UserID");
    return START_STICKY;
}

# intent plags

see http://stackoverflow.com/questions/21833402/difference-between-intent-flag-activity-clear-task-and-intent-flag-activity-task

# intent action
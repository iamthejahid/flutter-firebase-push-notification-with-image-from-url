import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> _fireHandler(RemoteMessage msg) async {
  print('A big messeage receiived $msg');

  AwesomeNotifications().createNotificationFromJsonData(
    msg.data,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_fireHandler);
  await FirebaseMessaging.instance.subscribeToTopic('all');
  AwesomeNotifications().initialize(
    'resource://drawable/ic_launcher',
    [
      NotificationChannel(
        channelKey: 'key1',
        channelName: 'Basic Chnl',
        channelDescription: 'Basic Testing',
        enableLights: true,
        enableVibration: true,
      )
    ],
  );
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var stream = AwesomeNotifications().actionStream;

  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      print('|------------------------------- > On message');
      RemoteNotification? notification = msg.notification;
      var x;

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          channelKey: 'key1',
          id: 10,
          body: msg.notification!.body,
          title: msg.notification!.title,
          bigPicture: msg.notification!.android?.imageUrl,
          largeIcon: "resource://drawable/ic_launcher",
          notificationLayout: NotificationLayout.BigPicture,
        ),
      );
      x = AwesomeNotifications().actionStream.listen((rcv) => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => NotoficationPage(
                    title: msg.notification!.title,
                    body: msg.notification!.body,
                    imageUrl: msg.notification!.android?.imageUrl,
                  ))).then((value) => x.cancel()));
    });
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      print('|------------------------------- > On messageOpend App');

      RemoteNotification? notification = msg.notification;
      var x;

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          channelKey: 'key1',
          id: 10,
          body: msg.notification!.body,
          title: msg.notification!.title,
          largeIcon: "resource://drawable/ic_launcher",
          bigPicture: msg.notification!.android?.imageUrl,
          notificationLayout: NotificationLayout.BigPicture,
        ),
      );
      x = AwesomeNotifications().actionStream.listen((rcv) => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => NotoficationPage(
                    title: msg.notification!.title,
                    body: msg.notification!.body,
                    imageUrl: msg.notification!.android?.imageUrl,
                  ))).then((value) => x.cancel()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: TextButton(
                onPressed: () {
                  notify();
                },
                child: Text('Press Me For a Notification'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void notify() async {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      channelKey: 'key1',
      id: 10,
      body: "Big Notification Change",
      title: "This is Title",
      largeIcon: "resource://drawable/ic_launcher",
      bigPicture:
          "https://protocoderspoint.com/wp-content/uploads/2021/06/firebase-cloud-push-notifiation-message-example-min-696x485.jpeg?ezimgfmt=ng:webp/ngcb13",
      notificationLayout: NotificationLayout.BigPicture,
    ),
  );
}

class NotoficationPage extends StatefulWidget {
  final String? title;
  final String? body;
  final String? imageUrl;
  NotoficationPage({Key? key, this.title, this.body, this.imageUrl})
      : super(key: key);

  @override
  _NotoficationPageState createState() => _NotoficationPageState();
}

class _NotoficationPageState extends State<NotoficationPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notification For You'),
        ),
        body: Column(
          children: [
            Text(widget.title ?? ""),
            Text(widget.body ?? ""),
            if (widget.imageUrl != null) Image.network(widget.imageUrl!),
          ],
        ),
      ),
    );
  }
}

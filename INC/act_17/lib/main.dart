// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'firebase_options.dart';

// Future<void> _messageHandler(RemoteMessage message) async {
//   print('background message ${message.notification!.body}');
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   FirebaseMessaging.onBackgroundMessage(_messageHandler);
//   runApp(MessagingTutorial());
// }

// class MessagingTutorial extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Firebase Messaging',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: MyHomePage(title: 'Firebase Messaging'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, this.title}) : super(key: key);
//   final String? title;
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late FirebaseMessaging messaging;
//   String? notificationText;
//   @override
//   void initState() {
//     super.initState();
//     messaging = FirebaseMessaging.instance;
//     messaging.subscribeToTopic("messaging");
//     messaging.getToken().then((value) {
//       print(value);
//     });
//     FirebaseMessaging.onMessage.listen((RemoteMessage event) {
//       print("message recieved");
//       print(event.notification!.body);
//       print(event.data.values);
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Notification"),
//             content: Text(event.notification!.body!),
//             actions: [
//               TextButton(
//                 child: Text("Ok"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       print('Message clicked!');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.title!)),
//       body: Center(child: Text("Messaging Tutorial")),
//     );
//   }
// }

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('Background message: ${message.notification?.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(MessagingTutorial());
}

class MessagingTutorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Messaging',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'Firebase Messaging'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String? title;
  MyHomePage({Key? key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.subscribeToTopic("messaging");
    messaging.getToken().then((value) => print("FCM Token: $value"));

    // Handle messages while app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received: ${message.notification?.title}");
      _handleMessage(message);
    });

    // Handle when user taps notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
      _handleMessage(message);
    });
  }

  void _handleMessage(RemoteMessage message) {
    final String? type = message.data['type']; // "special" or "normal"
    final String body = message.notification?.body ?? "No message body";

    if (type == "special") {
      _showStyledDialog("🌟 Special Quote 🌟", body, Colors.deepPurple);
    } else {
      _showStyledDialog("💬 Normal Quote", body, Colors.blue);
    }
  }

  void _showStyledDialog(String title, String message, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          actions: [
            TextButton(
              child: Text("OK", style: TextStyle(color: color)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title!)),
      body: Center(
        child: Text(
          "Waiting for cool quotes...",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

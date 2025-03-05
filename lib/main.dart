import 'dart:io';
import 'package:club_app/controllers/event_controller.dart';
import 'package:club_app/controllers/post_controller.dart';
import 'package:club_app/screens/server_down_page.dart';
import 'package:club_app/utils/repositories/user_repository.dart';
import 'package:club_app/utils/shared_prefs.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:club_app/screens/home_page.dart';
import 'package:club_app/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'config/theme.dart';
import 'controllers/global_bindings.dart';
import 'controllers/network_controller.dart';
import 'controllers/theme_controller.dart';
import 'controllers/unread_post_controller.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Save Notification large icon
Future<String> _downloadAndSaveFile(String url) async {
  String filename = '${DateTime.now().millisecondsSinceEpoch}.png';
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$filename';
  final http.Response response = await http.get(Uri.parse(url));
  final File file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

/// Show local notification
Future<void> showLocalNotification(RemoteMessage message) async {
  final Map<String, dynamic> data = message.data;

  if (data != null) {
    if(kDebugMode){
      print("largeIcon ${data['largeIcon']}");
      print("image ${data['image']}");
      print("title ${data['title']}");
      print("body ${data['body']}");
      print("postId ${data['postId']}");
      print("clubId ${data['clubId']}");
    }
    final String largeIcon = await _downloadAndSaveFile(data['largeIcon']);
    String image;
    if (data['image'] != '') {
      image = await _downloadAndSaveFile(data['image']);
      flutterLocalNotificationsPlugin.show(
          data.hashCode,
          data['title'],
          data['body'],
          NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                icon: 'launch_background',
                largeIcon: FilePathAndroidBitmap(largeIcon),
                color: Colors.deepPurple,
                colorized: true,
                actions: [const AndroidNotificationAction('view', 'View')],
                styleInformation: BigPictureStyleInformation(
                  FilePathAndroidBitmap(image),
                )),
          ));
    } else {
      flutterLocalNotificationsPlugin.show(
          data.hashCode,
          data['title'],
          data['body'],
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: 'launch_background',
              largeIcon: FilePathAndroidBitmap(largeIcon),
              color: Colors.deepPurple,
              colorized: true,
            ),
          ));
    }
  }
}

/// Local Notifications Initialization
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.',
  // description
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Getting Firebase Messaging Instance
FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

/// Firebase initialization
Future<void> firebaseInitializations() async {
  // Firebase initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.requestPermission();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // onMessage: When the app is open and it receives a push notification
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    showLocalNotification(message);

    final Map<String, dynamic> data = message.data;
    final eventController = Get.put(EventController());
    eventController.fetchEvents();
    if (data['postId'] == null || data['clubId'] == null) return;
    final unreadPostController = Get.put(UnreadPostController());
    await unreadPostController.getUnreadPosts();
    await unreadPostController.addUnreadPost(data['postId'], data['clubId']);
    await unreadPostController.getUnreadPosts();
    // final postId = data['postId'];
    // SharedPrefs.setUnreadPosts(postId);
    final postController = Get.put(PostController());
    postController.fetchPosts();
  });

  // replacement for onResume: When the app is in the background and opened directly from the push notification.
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    // await onNotificationClick(message);
  });

  // Firebase message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.subscribeToTopic("clubs-app-fcm-testing-2");
  FirebaseMessaging.instance.getInitialMessage().then((message) async {
    // await onNotificationClick(message, 'get_init');
  });

  // Getting the FCM token
  final token = await FirebaseMessaging.instance.getToken();
}

/// Callback for handling background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  showLocalNotification(message);

  final Map<String, dynamic> data = message.data;
  final eventController = Get.put(EventController());
  eventController.fetchEvents();
  if (data['postId'] == null || data['clubId'] == null) return;
  final unreadPostController = Get.put(UnreadPostController());
  await unreadPostController.getUnreadPosts();
  await unreadPostController.addUnreadPost(data['postId'], data['clubId']);
  await unreadPostController.getUnreadPosts();
  final postController = Get.put(PostController());
  postController.fetchPosts();
}

/// App Initialization
void appInitialization() async {
  final networkController = Get.put(NetworkController());
  final isOnline = networkController.isOnline.value;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final networkController = Get.put(NetworkController());
  await networkController.onInit();
  print(networkController.isOnline.value);

  // Initializing Firebase Messaging for iOS (Not functional)
  if (Platform.isIOS) {
    print('IOS');
  } else {
    networkController.isOnline.value ? await firebaseInitializations() : null;
  }

  StatelessWidget landingPage;

  // Login check
  final token = await SharedPrefs.getToken();
  if (token != '') {
    final user = await SharedPrefs.getUserDetails();
    if (networkController.isOnline.value) {
      try {
        final updatedUser = await UserRepository().getUserDetails(user.email);
        await SharedPrefs.saveUserDetails(updatedUser);
        landingPage = HomePage();
      } catch (e) {
        print('error: $e');
        landingPage = const ServerDownPage();
      }
    }
  } else {
    landingPage = LoginPage();
  }

  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp(
    landingPage: landingPage,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.landingPage});

  final Widget landingPage;
  final themeController = Get.put(ThemeController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (logic) {
      return GetMaterialApp(
        title: 'Flutter Demo',
        initialBinding: GlobalBindings(),

        // theme: AppTheme.darkTheme,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode.value,
        home: landingPage,
      );
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin notifications =
    FlutterLocalNotificationsPlugin();

//1. 앱로드시 실행할 기본설정
initNotification(context) async {
  //안드로이드용 아이콘파일 이름
  var androidSetting = AndroidInitializationSettings('app_icon');

  // android permission
  notifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();

  //ios에서 앱 로드시 유저에게 권한요청하려면
  var iosSetting = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: (id, title, body, payload) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Text('새로운페이지')));
    },
  );

  var initializationSettings =
      InitializationSettings(android: androidSetting, iOS: iosSetting);
  await notifications.initialize(
    initializationSettings,
    //알림 누를때 함수실행하고 싶으면
    onDidReceiveNotificationResponse: (payload) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Text('새로운페이지')));
    },
  );
}

const String darwinNotificationCategoryText = 'textCategory';

//2. 이 함수 원하는 곳에서 실행하면 알림 뜸
showNotification() async {
  var androidDetails = AndroidNotificationDetails(
    '유니크한 알림 채널 ID',
    '알림종류 설명',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );

  var iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  const DarwinNotificationDetails darwinNotificationDetails =
      DarwinNotificationDetails(
    categoryIdentifier: darwinNotificationCategoryText,
  );

  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: darwinNotificationDetails,
    macOS: darwinNotificationDetails,
  );

  // NotificationDetails _detail = const NotificationDetails(
  //   android: AndroidNotificationDetails('alarm 1', '1번 푸시'),
  //   iOS: DarwinNotificationDetails(
  //     presentAlert: true,
  //     presentBadge: true,
  //     presentSound: true,
  //   ),
  // );

  // 알림 id, 제목, 내용 맘대로 채우기
  notifications.show(1, '제목', '내용', notificationDetails);
}

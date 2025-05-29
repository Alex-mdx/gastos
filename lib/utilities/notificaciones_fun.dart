import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificacionesFun {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static Future<void> init() async {
    // Inicializar timezone
    tz.initializeTimeZones();

    // Configuración para Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuración para iOS
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true);

    // Configuración inicial
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {
      // Manejar cuando se toca la notificación
    });
  }

  static Future<void> periodico() async {
    // Configurar detalles de la notificación para Android
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'periodic_channel_id', 'Notificaciones periódicas',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
            enableVibration: true,
            color: LightTheme.primary,
            colorized: true,
            largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
            icon: '@mipmap/ic_launcher', // Usa el icono adaptativo
            styleInformation: BigPictureStyleInformation(
                DrawableResourceAndroidBitmap('ic_launcher'),
                hideExpandedLargeIcon: false));

    // Configurar detalles para iOS
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    // Configuración completa
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

    // Programar notificación diaria a las 9:00 AM
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0, // ID de la notificación
        'Control de Gastos',
        '¡Es hora de ingresar tus gastos!',
        nextTime(9, 0), // 9:00 AM
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  static tz.TZDateTime nextTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<void> show() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'instant_channel_id', 'Notificaciones instantáneas',
            enableVibration: true,
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
            color: LightTheme.green,
            colorized: true,
            largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
            icon: '@mipmap/ic_launcher');

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(1, 'Notificación instantánea',
        'Esta es una notificación de prueba', platformChannelSpecifics);
  }
}

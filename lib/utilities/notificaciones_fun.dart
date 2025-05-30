import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gastos/utilities/theme/theme_color.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificacionesFun {
  static List<String> names = [
    "¡Ey! ¿Dónde quedó ese billete que tenías ayer?",
    "Si no lo anotas, tu dinero se evaporará como tu motivación un lunes.",
    "Registra tus gastos o no dejes que tu billetera llore en silencio",
    "¿Sabes qué no vuelve? El dinero que gastaste y no apuntaste.",
    "Si no lo escribes, técnicamente no gastaste nada… ¿o sí?",
    "¿'No sé en qué se me fue el dinero'? ¡Apúntalo y deja de adivinar!",
    "El único misterio aceptable es el de las pirámides, no el de tus finanzas",
    "Registra ahora o llora después",
    "¿Vas a postergarlo? Tu cuenta de banco no es tu tarea de la escuela",
    "Si no lo haces ahora, tu yo del futuro te odiará",
    "Tu dinero está muy seguro",
    "¡Activa el modo 'adulto responsable' y apunta ese gasto!"
  ];
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

  static Future<void> periodico(int hora, int minuto, int id) async {
    // Configurar detalles de la notificación para Android
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'channel_periodic', 'Notificaciones instantáneas',
            enableVibration: true,
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
            color: LightTheme.green,
            colorized: true,
            channelShowBadge: true,
            setAsGroupSummary: true,
            styleInformation: BigTextStyleInformation('',
                htmlFormatContentTitle: true,
                htmlFormatBigText: true,
                summaryText: 'Resumen',
                htmlFormatSummaryText: true),
            largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
            icon: '@mipmap/ic_launcher');

    // Configurar detalles para iOS
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    // Configuración completa
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

    // Programar notificación diaria a las 9:00 AM
    names.shuffle();
    await flutterLocalNotificationsPlugin.zonedSchedule(id, 'Control de Gastos',
        names.first, nextTime(hora, minuto), platformChannelSpecifics,
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
            channelShowBadge: true,
            setAsGroupSummary: true,
            styleInformation: BigTextStyleInformation('',
                htmlFormatContentTitle: true,
                htmlFormatBigText: true,
                summaryText: 'Resumen',
                htmlFormatSummaryText: true),
            largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
            icon: '@mipmap/ic_launcher');

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    names.shuffle();
    await flutterLocalNotificationsPlugin.show(
        1, 'Notificación instantánea', names.first, platformChannelSpecifics);
  }
}

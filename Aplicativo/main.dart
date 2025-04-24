import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:http/http.dart' as http;
import 'screens/splash_screen.dart';

// Configuração do flutter_local_notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Configuração do serviço em segundo plano
Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'face_detection_channel',
      initialNotificationTitle: 'BabySafe Monitoramento',
      initialNotificationContent: 'Verificando detecção de rostos...',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  try {
    await service.startService();
    print('Serviço em segundo plano iniciado');
  } catch (e) {
    print('Erro ao iniciar serviço em segundo plano: $e');
  }
}

// Função executada em segundo plano
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Garantir que o serviço entre no modo foreground imediatamente
  if (service is AndroidServiceInstance) {
    await service.setAsForegroundService();
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // Configurar notificações
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'face_detection_channel',
    'Detecção de Rostos',
    channelDescription: 'Notificações para ausência de rostos detectados',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
  );
  const DarwinNotificationDetails iOSPlatformChannelSpecifics =
  DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  // Verificar face_count periodicamente
  const faceCountUrl = 'https://5da4-209-14-22-215.ngrok-free.app/face_count';
  DateTime? lastNotification;
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    try {
      final response = await http
          .get(Uri.parse(faceCountUrl))
          .timeout(const Duration(seconds: 5), onTimeout: () {
        throw TimeoutException('Tempo limite ao acessar /face_count');
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final count = data['faceCount'] as int;
        if (count == 0 &&
            (lastNotification == null ||
                DateTime.now().difference(lastNotification!).inSeconds > 60)) {
          await flutterLocalNotificationsPlugin.show(
            0,
            'Atenção: Berço Vazio!',
            'Nenhum bebê detectado no berço. Verifique imediatamente!',
            platformChannelSpecifics,
            payload: 'face_detection_alert',
          );
          print('Main: Notificação disparada: Nenhum rosto detectado');
          lastNotification = DateTime.now();
        }
      } else {
        print('Main: Erro ao acessar /face_count: ${response.statusCode}');
        // Se o servidor não estiver acessível, esperar mais antes de tentar novamente
        await Future.delayed(const Duration(seconds: 30));
      }
    } catch (e) {
      print('Main: Erro ao acessar /face_count: $e');
      // Se houver erro, esperar mais antes de tentar novamente
      await Future.delayed(const Duration(seconds: 30));
    }
  });
}

// Função para iOS em segundo plano
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  return true;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar notificações
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsDarwin =
  DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );
  try {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    print('Main: Notificações inicializadas');
  } catch (e) {
    print('Main: Erro ao inicializar notificações: $e');
  }

  // Solicitar permissão para notificações no Android 13+
  try {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    print('Main: Permissão de notificações solicitada');
  } catch (e) {
    print('Main: Erro ao solicitar permissão de notificações: $e');
  }

  // Inicializar serviço em segundo plano
  await initializeService();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BabySafe',
      theme: ThemeData(
        primaryColor: const Color(0xFF0277BD),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const SplashScreen(),
    );
  }
}
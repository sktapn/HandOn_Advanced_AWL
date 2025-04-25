import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';

// Configuração do flutter_local_notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Função para obter o IP salvo
Future<String> getServerIp() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('server_ip') ?? '192.168.1.100'; // IP padrão se não houver um salvo
}

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
  DateTime? lastNotification;
  int consecutiveErrors = 0;
  bool isServerOffline = false;

  Timer.periodic(const Duration(seconds: 10), (timer) async {
    // Obter o IP do servidor
    final serverIp = await getServerIp();
    final faceCountUrl = 'http://$serverIp/face_count';

    // Se o servidor estiver offline, esperar mais tempo antes de tentar novamente
    if (isServerOffline) {
      print('Main: Servidor offline. Tentando reconectar em 1 minuto...');
      await Future.delayed(const Duration(minutes: 1));
    }

    try {
      final response = await http
          .get(Uri.parse(faceCountUrl))
          .timeout(const Duration(seconds: 5), onTimeout: () {
        throw TimeoutException('Tempo limite ao acessar /face_count');
      });

      if (response.statusCode == 200) {
        consecutiveErrors = 0;
        isServerOffline = false; // Servidor está online
        print('Main: Servidor online. Processando face_count...');
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
        consecutiveErrors++;
      }
    } catch (e) {
      print('Main: Erro ao acessar /face_count: $e');
      consecutiveErrors++;
      if (consecutiveErrors >= 3) {
        isServerOffline = true; // Considerar o servidor offline após 3 erros consecutivos
        print('Main: Servidor considerado offline após $consecutiveErrors erros consecutivos');
      }
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
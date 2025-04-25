import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../painters/medical_pattern_painter.dart';
import '../painters/wave_painter.dart';
import '../painters/bottom_wave_painter.dart';
import '../widgets/health_icon.dart';
import 'server_config_screen.dart'; // Mantido para referência, caso precise em outra tela

class HealthScreen extends StatefulWidget {
  const HealthScreen({Key? key}) : super(key: key);

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  double heartRate = 130;
  double oxygenLevel = 93;
  double temperature = 36.8;
  double humidity = 60;
  bool smokeDetected = false;

  final Random _random = Random();

  String streamUrl = '';
  String faceCountUrl = '';
  bool isStreamAvailable = true;
  bool isServerOffline = false;
  int faceCount = 0;
  Timer? faceCountTimer;
  Timer? retryStreamTimer;
  Timer? healthDataTimer;

  @override
  void initState() {
    super.initState();
    _loadServerIpAndInitializeUrls();

    healthDataTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _simulateHealthData();
    });

    faceCountTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchFaceCount();
    });

    retryStreamTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!isStreamAvailable || isServerOffline) {
        _updateStreamAvailability(true);
        fetchFaceCount();
      }
    });
  }

  // Carrega o IP salvo e inicializa as URLs
  Future<void> _loadServerIpAndInitializeUrls() async {
    final prefs = await SharedPreferences.getInstance();
    final serverIp = prefs.getString('server_ip') ?? '192.168.1.100'; // IP padrão
    setState(() {
      streamUrl = 'http://$serverIp/video_feed_with_faces';
      faceCountUrl = 'http://$serverIp/face_count';
    });
  }

  @override
  void dispose() {
    faceCountTimer?.cancel();
    retryStreamTimer?.cancel();
    healthDataTimer?.cancel();
    super.dispose();
  }

  void _simulateHealthData() {
    setState(() {
      heartRate = (120 + _random.nextInt(51)).toDouble(); // 120–170 bpm
      oxygenLevel = (90 + _random.nextInt(6)).toDouble(); // 90–95%
      temperature = (365 + _random.nextInt(11)) / 10.0; // 36.5–37.5°C
      humidity = (50 + _random.nextInt(21)).toDouble(); // 50–70%
      smokeDetected = false; // ou _random.nextInt(60) == 0;
    });
  }

  void _updateStreamAvailability(bool available) {
    if (mounted) {
      setState(() {
        isStreamAvailable = available;
      });
    }
  }

  Future<void> fetchFaceCount() async {
    try {
      final response = await http
          .get(Uri.parse(faceCountUrl))
          .timeout(const Duration(seconds: 5), onTimeout: () {
        throw TimeoutException('Tempo limite ao acessar /face_count');
      });

      if (response.statusCode == 200) {
        setState(() {
          isServerOffline = false;
          final data = jsonDecode(response.body);
          faceCount = data['faceCount'] as int;
        });
      } else {
        setState(() {
          isServerOffline = true;
          faceCount = 0;
        });
      }
    } catch (e) {
      setState(() {
        isServerOffline = true;
        faceCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: MedicalPatternPainter())),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: WavePainter(
                colors: [
                  const Color(0xFF0277BD).withOpacity(0.15),
                  const Color(0xFF00BCD4).withOpacity(0.15),
                ],
              ),
              size: Size(screenWidth, MediaQuery.of(context).size.height * 0.3),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: BottomWavePainter(
                colors: [
                  const Color(0xFF00BCD4).withOpacity(0.15),
                  const Color(0xFF4CAF50).withOpacity(0.15),
                ],
              ),
              size: Size(screenWidth, MediaQuery.of(context).size.height * 0.3),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF0277BD)),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text(
                            'Monitoramento de Saúde',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0277BD),
                            ),
                          ),
                          const SizedBox(width: 48), // Espaço reservado para manter o layout
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: screenWidth,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Stack(
                              children: [
                                isServerOffline
                                    ? _buildOfflinePlaceholder()
                                    : isStreamAvailable
                                    ? Container(
                                  color: Colors.black,
                                  child: Mjpeg(
                                    stream: streamUrl,
                                    isLive: true,
                                    timeout: const Duration(seconds: 10),
                                    error: (context, error, stack) {
                                      Future.microtask(() {
                                        _updateStreamAvailability(false);
                                      });
                                      return _buildErrorPlaceholder();
                                    },
                                  ),
                                )
                                    : _buildErrorPlaceholder(),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Rostos: $faceCount',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildHealthCard('Batimentos Cardíacos', '$heartRate bpm', Icons.monitor_heart, const Color(0xFF0277BD)),
                      _buildHealthCard('Oximetria', '$oxygenLevel%', Icons.favorite, const Color(0xFF00BCD4)),
                      _buildHealthCard('Temperatura Corporal', '$temperature°C', Icons.thermostat_outlined, const Color(0xFF4CAF50)),
                      _buildHealthCard('Umidade Ambiente', '$humidity%', Icons.water_drop_outlined, const Color(0xFF0277BD)),
                      _buildHealthCard(
                        'Detecção de Fumaça',
                        smokeDetected ? 'Detectada' : 'Não Detectada',
                        Icons.warning_amber_rounded,
                        smokeDetected ? Colors.red : const Color(0xFF4CAF50),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ..._buildHealthIcons(context),
        ],
      ),
    );
  }

  Widget _buildHealthCard(String title, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              Text(
                value,
                style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.videocam_off, size: 48, color: Colors.white),
            const SizedBox(height: 8),
            const Text('Câmera não disponível', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const Text('Verificando conexão com a câmera...', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                _updateStreamAvailability(true);
              },
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflinePlaceholder() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: Colors.white),
            const SizedBox(height: 8),
            const Text('Servidor Offline', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const Text('Tentando reconectar automaticamente...', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                _updateStreamAvailability(true);
                fetchFaceCount();
              },
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildHealthIcons(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return [
      const HealthIcon(icon: Icons.favorite, color: Color(0xFF0277BD), position: Offset(50, 150), size: 20),
      HealthIcon(icon: Icons.monitor_heart, color: const Color(0xFF00BCD4), position: Offset(screenWidth - 70, 180), size: 24),
      HealthIcon(icon: Icons.health_and_safety, color: const Color(0xFF4CAF50), position: Offset(80, screenHeight - 150), size: 22),
      HealthIcon(icon: Icons.medical_services, color: const Color(0xFF0277BD), position: Offset(screenWidth - 100, screenHeight - 180), size: 18),
    ];
  }
}
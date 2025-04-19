import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import '../painters/medical_pattern_painter.dart';
import '../painters/wave_painter.dart';
import '../painters/bottom_wave_painter.dart';
import '../widgets/health_icon.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({Key? key}) : super(key: key);

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  double heartRate = 130;
  double oxygenLevel = 97;
  double temperature = 36.8;
  double humidity = 60;
  bool smokeDetected = false;

  late VlcPlayerController _vlcPlayerController;

  @override
  void initState() {
    super.initState();
    _vlcPlayerController = VlcPlayerController.network(
      'rtsp://admin:N3T1PD56@192.168.1.192:554/cam/realmonitor?channel=1&subtype=0&unicast=true&proto=Onvif',
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
  }

  @override
  void dispose() {
    _vlcPlayerController.dispose();
    super.dispose();
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
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Color(0xFF0277BD)),
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
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // RTSP Stream Display
                      Container(
                        width: screenWidth,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: VlcPlayer(
                              controller: _vlcPlayerController,
                              aspectRatio: 16 / 9,
                              placeholder: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildHealthCard(
                        'Batimentos Cardíacos',
                        '$heartRate bpm',
                        Icons.monitor_heart,
                        const Color(0xFF0277BD),
                      ),
                      _buildHealthCard(
                        'Oximetria',
                        '$oxygenLevel%',
                        Icons.favorite,
                        const Color(0xFF00BCD4),
                      ),
                      _buildHealthCard(
                        'Temperatura Corporal',
                        '$temperature°C',
                        Icons.thermostat_outlined,
                        const Color(0xFF4CAF50),
                      ),
                      _buildHealthCard(
                        'Umidade Ambiente',
                        '$humidity%',
                        Icons.water_drop_outlined,
                        const Color(0xFF0277BD),
                      ),
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

  Widget _buildHealthCard(
      String title, String value, IconData icon, Color color) {
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
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14)),
              Text(value,
                  style: TextStyle(
                      fontSize: 16, color: color, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildHealthIcons(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return [
      const HealthIcon(
        icon: Icons.favorite,
        color: Color(0xFF0277BD),
        position: Offset(50, 150),
        size: 20,
      ),
      HealthIcon(
        icon: Icons.monitor_heart,
        color: const Color(0xFF00BCD4),
        position: Offset(screenWidth - 70, 180),
        size: 24,
      ),
      HealthIcon(
        icon: Icons.health_and_safety,
        color: const Color(0xFF4CAF50),
        position: Offset(80, screenHeight - 150),
        size: 22,
      ),
      HealthIcon(
        icon: Icons.medical_services,
        color: const Color(0xFF0277BD),
        position: Offset(screenWidth - 100, screenHeight - 180),
        size: 18,
      ),
    ];
  }
}
import 'package:flutter/material.dart';
import '../painters/medical_pattern_painter.dart';
import '../painters/wave_painter.dart';
import '../painters/bottom_wave_painter.dart';
import '../widgets/health_icon.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  Widget _buildHistoryItem(
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
              Text(value, style: TextStyle(fontSize: 16, color: color)),
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
          size: 20),
      HealthIcon(
          icon: Icons.monitor_heart,
          color: const Color(0xFF00BCD4),
          position: Offset(screenWidth - 70, 180),
          size: 24),
      HealthIcon(
          icon: Icons.health_and_safety,
          color: const Color(0xFF4CAF50),
          position: Offset(80, screenHeight - 150),
          size: 22),
      HealthIcon(
          icon: Icons.medical_services,
          color: const Color(0xFF0277BD),
          position: Offset(screenWidth - 100, screenHeight - 180),
          size: 18),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          // Fundo com padrão
          Positioned.fill(child: CustomPaint(painter: MedicalPatternPainter())),
          // Onda no topo
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
              size: Size(screenWidth, screenHeight * 0.3),
            ),
          ),
          // Onda na base
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
              size: Size(screenWidth, screenHeight * 0.3),
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
                      // Barra superior
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Color(0xFF0277BD)),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text(
                            'Histórico',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0277BD)),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Seção "MÉDIA DIÁRIA" centralizada
                      Center(
                        child: const Text(
                          'MÉDIA DIÁRIA',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildHistoryItem('Batimentos Cardíacos', '118 bpm',
                          Icons.monitor_heart, const Color(0xFF0277BD)),
                      _buildHistoryItem('Temperatura Corporal', '36.7°C',
                          Icons.thermostat_outlined, const Color(0xFF4CAF50)),
                      _buildHistoryItem('Umidade Ambiente', '54%',
                          Icons.water_drop_outlined, const Color(0xFF00BCD4)),
                      const SizedBox(height: 24),
                      // Seção "EVENTOS" centralizada
                      Center(
                        child: const Text(
                          'EVENTOS',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildHistoryItem(
                          'Alerta de Fumaça',
                          '12/03/2025 - 14:30',
                          Icons.warning_amber_rounded,
                          Colors.red),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Ícones decorativos
          ..._buildHealthIcons(context),
        ],
      ),
    );
  }
}

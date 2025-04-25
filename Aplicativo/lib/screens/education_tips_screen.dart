import 'package:flutter/material.dart';
import '../painters/medical_pattern_painter.dart';
import '../painters/wave_painter.dart';
import '../painters/bottom_wave_painter.dart';
import '../widgets/health_icon.dart';

class EducationTipsScreen extends StatelessWidget {
  const EducationTipsScreen({Key? key}) : super(key: key);

  // Widget para cada dica
  Widget _buildTipCard(String title, String content) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // Ícones decorativos (os mesmos das outras interfaces)
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          // Fundo: Pattern de "cruzinhas"
          Positioned.fill(
            child: CustomPaint(painter: MedicalPatternPainter()),
          ),
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
          // Conteúdo
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Barra superior com botão de voltar
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Color(0xFF0277BD)),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'DICAS E EDUCAÇÃO',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0277BD),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          // Um espaço vazio para equilibrar o layout
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Lista de dicas
                      _buildTipCard(
                        "Cuidados com o Recém-Nascido",
                        "Mantenha os cuidados com higiene, alimentação e sono. Consulte o pediatra para orientações.",
                      ),
                      _buildTipCard(
                        "Alimentação Saudável",
                        "Introduza alimentos conforme orientação, garantindo uma dieta equilibrada e adequada para o bebê.",
                      ),
                      _buildTipCard(
                        "Desenvolvimento Motor",
                        "Estimule o bebê com atividades que promovam o desenvolvimento motor e cognitivo.",
                      ),
                      _buildTipCard(
                        "Vacinação",
                        "Mantenha o calendário de vacinação atualizado para proteger o seu bebê.",
                      ),
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

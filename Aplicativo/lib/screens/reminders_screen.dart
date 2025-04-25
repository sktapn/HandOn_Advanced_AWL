import 'package:flutter/material.dart';
import '../painters/medical_pattern_painter.dart';
import '../painters/wave_painter.dart';
import '../painters/bottom_wave_painter.dart';
import '../widgets/health_icon.dart';
import '../extensions/snackbar_extension.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({Key? key}) : super(key: key);

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final List<Map<String, String>> reminders = [
    {
      'title': 'Consulta com Pediatra',
      'date': '15/03/2025 - 10:30',
      'status': 'Pendente'
    },
    {'title': 'Vacina BCG', 'date': '20/03/2025 - 09:00', 'status': 'Pendente'},
  ];

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
          // Fundo com pattern
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
                            'Lembretes',
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

                      // Lista de lembretes
                      ...reminders.map((reminder) {
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
                                  color:
                                      const Color(0xFF0277BD).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.calendar_today,
                                    color: Color(0xFF0277BD), size: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      reminder['title']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      reminder['date']!,
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF4CAF50).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: const Color(0xFF4CAF50), width: 1),
                                ),
                                child: Text(
                                  reminder['status']!,
                                  style: const TextStyle(
                                    color: Color(0xFF4CAF50),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      const Spacer(), // empurra o conteúdo para ocupar a tela
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.showSnackBar(
              'Funcionalidade de adicionar lembrete em desenvolvimento!');
        },
        backgroundColor: const Color(0xFF0277BD),
        child: const Icon(Icons.add),
      ),
    );
  }
}

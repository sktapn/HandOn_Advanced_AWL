import 'dart:io';
import 'package:flutter/material.dart';
import 'package:babysafe/screens/education_tips_screen.dart';
import '../models/baby_profile.dart';
import '../painters/medical_pattern_painter.dart';
import '../painters/wave_painter.dart';
import '../painters/bottom_wave_painter.dart';
import '../widgets/health_icon.dart';
import '../widgets/menu_card.dart';
import '../widgets/large_menu_card.dart';
import 'health_screen.dart';
import 'profile_screen.dart';
import 'history_screen.dart';
import 'reminders_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  /// Índice da “aba” selecionada para conteúdo interno
  /// (0 = Dashboard, 1 = Monitor, 2 = Relatórios).
  int selectedIndex = 0;

  /// Lista única com TODOS os itens que ficarão na mesma linha (superior).
  /// - type: 'content' => muda o selectedIndex (exibe conteúdo interno).
  /// - type: 'navigate' => navega para outra tela diretamente.
  final List<Map<String, dynamic>> _topItems = [
    {
      'icon': Icons.dashboard,
      'label': 'Dashboard',
      'type': 'content',
      'contentIndex': 0,
    },
    {
      'icon': Icons.monitor,
      'label': 'Monitor',
      'type': 'content',
      'contentIndex': 1,
    },
    {
      'icon': Icons.report,
      'label': 'Relatórios',
      'type': 'content',
      'contentIndex': 2,
    },
    {
      'icon': Icons.monitor_heart,
      'label': 'Saúde',
      'type': 'navigate',
      'route': HealthScreen(),
    },
    {
      'icon': Icons.child_care,
      'label': 'Perfil',
      'type': 'navigate',
      'route': ProfileScreen(),
    },
    {
      'icon': Icons.history,
      'label': 'Histórico',
      'type': 'navigate',
      'route': HistoryScreen(),
    },
    {
      'icon': Icons.notifications_active,
      'label': 'Lembretes',
      'type': 'navigate',
      'route': RemindersScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Sugestão: paleta de cores atualizada para alto contraste e modernidade
    final primaryColor = const Color(0xFF01579B); // Azul escuro
    final secondaryColor = const Color(0xFF0288D1); // Azul médio
    final accentColor = const Color(0xFFFFA000); // Laranja

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          /// Fundo com pattern e ondas
          Positioned.fill(
            child: CustomPaint(painter: MedicalPatternPainter()),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: WavePainter(
                colors: [
                  primaryColor.withOpacity(0.15),
                  secondaryColor.withOpacity(0.15),
                ],
              ),
              size: Size(screenWidth, screenHeight * 0.3),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: BottomWavePainter(
                colors: [
                  secondaryColor.withOpacity(0.15),
                  accentColor.withOpacity(0.15),
                ],
              ),
              size: Size(screenWidth, screenHeight * 0.3),
            ),
          ),

          /// Conteúdo principal
          SafeArea(
            child: Column(
              children: [
                /// --- BARRA SUPERIOR COM TODOS OS BOTÕES (CENTRALIZADA) ---
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_topItems.length, (index) {
                      final item = _topItems[index];
                      final bool isContent = (item['type'] == 'content');
                      final bool isSelected =
                          (isContent && item['contentIndex'] == selectedIndex);

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () {
                            if (isContent) {
                              setState(() {
                                selectedIndex = item['contentIndex'];
                              });
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => item['route'],
                                ),
                              );
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? primaryColor : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: primaryColor, width: 1),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  item['icon'],
                                  color:
                                      isSelected ? Colors.white : primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  item['label'],
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                /// --- ÁREA QUE MUDA CONFORME selectedIndex (DASHBOARD, MONITOR, RELATÓRIOS) ---
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: _buildContentForTab(selectedIndex),
                  ),
                ),
              ],
            ),
          ),

          /// Ícones de saúde em overlay (mantidos os antigos)
          ..._buildHealthIcons(context),
        ],
      ),
    );
  }

  /// Constrói o conteúdo de cada “aba interna” (Dashboard, Monitor, Relatórios)
  Widget _buildContentForTab(int index) {
    switch (index) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return _buildMonitorContent();
      case 2:
        return _buildReportsContent();
      default:
        return Container();
    }
  }

  /// --- ABA 0: DASHBOARD ---
  Widget _buildDashboardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card com estatísticas rápidas
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickStat(
                Icons.monitor_weight_outlined,
                '6.5 kg',
                'Peso',
                const Color(0xFF01579B),
              ),
              _buildQuickStat(
                Icons.height,
                '65 cm',
                'Altura',
                const Color(0xFF0288D1),
              ),
              _buildQuickStat(
                Icons.thermostat_outlined,
                '36.5°C',
                'Temp.',
                const Color(0xFFFFA000),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Exemplo de card de agendamento
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
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
                  color: const Color(0xFF01579B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF01579B),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dra. Sarah Johnson - Pediatra',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '15 de Março, 2025 - 10:30',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF4CAF50),
                    width: 1,
                  ),
                ),
                child: const Text(
                  'Confirmada',
                  style: TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  /// --- ABA 1: MONITOR ---
  Widget _buildMonitorContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Monitor',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Informações detalhadas sobre o monitor e status do hardware/incubadora.',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  /// --- ABA 2: RELATÓRIOS ---
  Widget _buildReportsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Relatórios',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Relatórios e análises detalhadas do sistema.',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  /// Ícones de saúde em overlay (mantidos os antigos)
  List<Widget> _buildHealthIcons(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return [
      const HealthIcon(
        icon: Icons.favorite,
        color: Color(0xFF01579B),
        position: Offset(50, 150),
        size: 20,
      ),
      HealthIcon(
        icon: Icons.monitor_heart,
        color: const Color(0xFF0288D1),
        position: Offset(screenWidth - 70, 180),
        size: 24,
      ),
      HealthIcon(
        icon: Icons.health_and_safety,
        color: const Color(0xFFFFA000),
        position: Offset(80, screenHeight - 150),
        size: 22,
      ),
      HealthIcon(
        icon: Icons.medical_services,
        color: const Color(0xFF01579B),
        position: Offset(screenWidth - 100, screenHeight - 180),
        size: 18,
      ),
    ];
  }

  /// Estatísticas rápidas (Peso, Altura, etc.)
  Widget _buildQuickStat(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF333333),
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}

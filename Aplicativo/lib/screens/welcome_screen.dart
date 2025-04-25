import 'package:flutter/material.dart';
import '../painters/medical_pattern_painter.dart';
import '../painters/wave_painter.dart';
import '../painters/bottom_wave_painter.dart';
import '../widgets/health_icon.dart';
import '../widgets/feature_item.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'dashboard_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          Positioned.fill(child: CustomPaint(painter: MedicalPatternPainter())),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: WavePainter(
                colors: [
                  const Color(0xFF0277BD).withOpacity(0.15),
                  const Color(0xFF00BCD4).withOpacity(0.15)
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
                  const Color(0xFF00BCD4).withOpacity(0.15),
                  const Color(0xFF4CAF50).withOpacity(0.15)
                ],
              ),
              size: Size(screenWidth, screenHeight * 0.3),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.07),
                  Image.asset('assets/babysafe_logo.png',
                      height: screenHeight * 0.25, width: screenWidth * 0.5),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.01),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text('Monitoramento de saúde infantil',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4CAF50),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5)),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Column(
                    children: [
                      FeatureItem(
                          icon: Icons.monitor_heart,
                          title: 'Monitoramento em tempo real',
                          description: 'Acompanhe os sinais vitais do seu bebê',
                          color: Color(0xFF0277BD)),
                      SizedBox(height: screenHeight * 0.03),
                      FeatureItem(
                          icon: Icons.notifications_active,
                          title: 'Alertas instantâneos',
                          description: 'Receba notificações de emergência',
                          color: Color(0xFF00BCD4)),
                      SizedBox(height: screenHeight * 0.03),
                      FeatureItem(
                          icon: Icons.history,
                          title: 'Histórico completo',
                          description:
                              'Acesse dados de saúde a qualquer momento',
                          color: Color(0xFF4CAF50)),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.07),
                  PrimaryButton(
                    text: 'ENTRAR',
                    icon: Icons.login_rounded,
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LoginScreen())),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  SecondaryButton(
                    text: 'CRIAR CONTA',
                    icon: Icons.person_add_rounded,
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const RegisterScreen())),
                  ),
                  // Aqui foi removido o TextButton "Acessar demonstração"
                  SizedBox(height: screenHeight * 0.04),
                ],
              ),
            ),
          ),
          ..._buildHealthIcons(context),
        ],
      ),
    );
  }
}

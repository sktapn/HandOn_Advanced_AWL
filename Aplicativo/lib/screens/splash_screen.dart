import 'package:flutter/material.dart';
import '../painters/medical_pattern_painter.dart';
import '../painters/wave_painter.dart';
import '../painters/bottom_wave_painter.dart';
import '../painters/heartbeat_line_painter.dart';
import '../widgets/health_icon.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        );
      }
    });
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
                  const Color(0xFF4CAF50).withOpacity(0.15),
                ],
              ),
              size: Size(screenWidth, screenHeight * 0.3),
            ),
          ),
          Positioned(
            top: screenHeight * 0.4,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: HeartbeatLinePainter(
                progress: _controller.value,
                color: const Color(0xFF0277BD).withOpacity(0.2),
              ),
              size: Size(screenWidth, screenHeight * 0.05),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(scale: _scaleAnimation, child: child),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/babysafe_logo.png',
                    height: screenHeight * 0.25,
                    width: screenWidth * 0.5,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'Monitoramento de saúde infantil',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  SizedBox(
                    width: screenWidth * 0.1,
                    height: screenWidth * 0.1,
                    child: CircularProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF00BCD4),
                      ),
                      strokeWidth: 3,
                      backgroundColor: const Color(0xFF00BCD4).withOpacity(0.2),
                    ),
                  ),
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

import 'package:flutter/material.dart';
import 'dart:io';
import '../painters/medical_pattern_painter.dart';
import '../painters/wave_painter.dart';
import '../painters/bottom_wave_painter.dart';
import '../widgets/health_icon.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import '../extensions/snackbar_extension.dart';
import '../services/local_auth.dart';
import 'register_screen.dart';
import 'dashboard_screen.dart';
import 'AdminDashboardScreen.dart'; // Importando a tela do admin

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      context.showSnackBar(
        'Por favor, preencha todos os campos',
        isError: true,
      );
      setState(() => _isLoading = false);
      return;
    }

    final success = await LocalAuth.signIn(email, password);
    if (success) {
      if (mounted) {
        context.showSnackBar('Login bem-sucedido!');
        // Se o e-mail for do admin, redireciona para a tela do admin
        if (email == 'neres@admin.com') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }
      }
    } else {
      if (mounted)
        context.showSnackBar('Email ou senha incorretos', isError: true);
    }
    if (mounted) setState(() => _isLoading = false);
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
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.07),
                  Image.asset(
                    'assets/babysafe_logo.png',
                    height: screenHeight * 0.25,
                    width: screenWidth * 0.5,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'Faça login para continuar',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'seu@email.com',
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Color(0xFF0277BD),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: const Color(0xFF0277BD).withOpacity(0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF0277BD),
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      hintText: '••••••••',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF0277BD),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: const Color(0xFF0277BD).withOpacity(0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF0277BD),
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Esqueceu a senha?',
                        style: TextStyle(
                          color: Color(0xFF0277BD),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  PrimaryButton(
                    text: 'ENTRAR',
                    icon: Icons.login_rounded,
                    onPressed: _isLoading ? () {} : _signIn,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  SecondaryButton(
                    text: 'CRIAR CONTA',
                    icon: Icons.person_add_rounded,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RegisterScreen(),
                      ),
                    ),
                  ),
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

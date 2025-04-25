import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../painters/medical_pattern_painter.dart';
import '../painters/wave_painter.dart';
import '../painters/bottom_wave_painter.dart';
import '../widgets/health_icon.dart';

class ServerConfigScreen extends StatefulWidget {
  const ServerConfigScreen({Key? key}) : super(key: key);

  @override
  State<ServerConfigScreen> createState() => _ServerConfigScreenState();
}

class _ServerConfigScreenState extends State<ServerConfigScreen> {
  final TextEditingController _ipController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSavedIp();
  }

  // Carrega o IP salvo, se existir
  Future<void> _loadSavedIp() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIp = prefs.getString('server_ip');
    if (savedIp != null) {
      _ipController.text = savedIp;
    }
  }

  // Valida e salva o IP inserido
  Future<void> _saveIp() async {
    final ip = _ipController.text.trim();
    if (ip.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, insira um IP válido.';
      });
      return;
    }

    // Validação de formato de IP
    final ipPattern = RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$');
    if (!ipPattern.hasMatch(ip) ||
        ip.split('.').any((part) => int.parse(part) > 255)) {
      setState(() {
        _errorMessage = 'Formato de IP inválido (ex: 192.168.1.100).';
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_ip', ip);
    setState(() {
      _errorMessage = null;
    });

    // Mostra um feedback ao usuário
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('IP salvo com sucesso!')),
    );

    // Volta para a tela anterior
    Navigator.pop(context);
  }

  // Lista de ícones decorativos
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          // Padrão de fundo
          Positioned.fill(child: CustomPaint(painter: MedicalPatternPainter())),
          // Onda superior (opcional, não visível na imagem, mas mantida por consistência)
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
          // Onda inferior
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
          // Conteúdo principal
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar personalizada
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Color(0xFF0277BD)),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Configuração do Servidor',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0277BD),
                        ),
                      ),
                      const SizedBox(width: 48), // Espaço para alinhamento
                    ],
                  ),
                ),
                // Conteúdo do formulário
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Insira o IP do servidor:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _ipController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              labelText: 'IP do Servidor (ex: 192.168.1.100)',
                              labelStyle:
                              const TextStyle(color: Colors.grey),
                              errorText: _errorMessage,
                              errorStyle: const TextStyle(color: Colors.red),
                              suffixIcon: const Icon(
                                Icons.computer,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                            keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: _saveIp,
                            icon: const Icon(Icons.save, color: Colors.white, size: 20),
                            label: const Text(
                              'Salvar',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0277BD),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              shadowColor: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Ícones decorativos
          ..._buildHealthIcons(context),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }
}
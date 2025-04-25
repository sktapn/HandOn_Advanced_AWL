import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Para formatar datas
import '../models/baby_profile.dart';
import '../painters/medical_pattern_painter.dart';
import '../painters/wave_painter.dart';
import '../painters/bottom_wave_painter.dart';
import '../widgets/health_icon.dart';
import '../widgets/primary_button.dart';
import '../extensions/snackbar_extension.dart';
import 'dashboard_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController(text: BabyProfile.name);
  final _birthDateController =
      TextEditingController(text: BabyProfile.birthDate);
  final _fatherNameController =
      TextEditingController(text: BabyProfile.fatherName);
  final _motherNameController =
      TextEditingController(text: BabyProfile.motherName);
  String? _gender;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  void _saveProfile() {
    if (_nameController.text.isEmpty) {
      context.showSnackBar('Por favor, insira o nome da criança.');
      return;
    }
    if (_birthDateController.text.isEmpty) {
      context.showSnackBar('Por favor, insira a data de nascimento.');
      return;
    }

    BabyProfile.updateProfile(
      newName: _nameController.text,
      newPhotoPath: _imageFile?.path,
      newBirthDate: _birthDateController.text,
      newGender: _gender ?? 'Não especificado',
      newFatherName: _fatherNameController.text,
      newMotherName: _motherNameController.text,
    );
    context.showSnackBar('Perfil salvo com sucesso!');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF0277BD)),
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          // Fundo com pattern
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
                constraints: BoxConstraints(minHeight: screenHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Barra superior com botão de voltar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Color(0xFF0277BD)),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text(
                            'Perfil da Criança',
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

                      // Cartão com foto e campos
                      Container(
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
                        child: Column(
                          children: [
                            // Foto: se não existir imagem, exibe um ícone neutro
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: _imageFile != null
                                      ? FileImage(_imageFile!)
                                      : (BabyProfile.photoPath != null
                                          ? FileImage(
                                              File(BabyProfile.photoPath!))
                                          : null),
                                  child: (_imageFile == null &&
                                          BabyProfile.photoPath == null)
                                      ? const Icon(Icons.person,
                                          size: 40, color: Colors.white)
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => SafeArea(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading: const Icon(
                                                    Icons.camera_alt,
                                                    color: Color(0xFF0277BD)),
                                                title: const Text('Tirar Foto'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _pickImage(
                                                      ImageSource.camera);
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                    Icons.photo_library,
                                                    color: Color(0xFF0277BD)),
                                                title: const Text(
                                                    'Escolher da Galeria'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _pickImage(
                                                      ImageSource.gallery);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF0277BD),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.camera_alt,
                                          color: Colors.white, size: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Nome
                            TextField(
                              controller: _nameController,
                              decoration: _buildInputDecoration(
                                  'Nome e Sobrenome', Icons.person_outline),
                            ),
                            const SizedBox(height: 16),

                            // Data de nascimento (com DatePicker)
                            TextField(
                              controller: _birthDateController,
                              decoration: _buildInputDecoration(
                                  'Data de Nascimento', Icons.calendar_today),
                              readOnly: true,
                              onTap: () async {
                                final DateTime? pickedDate =
                                    await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  final formattedDate = DateFormat('dd/MM/yyyy')
                                      .format(pickedDate);
                                  setState(() {
                                    _birthDateController.text = formattedDate;
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 16),

                            // Sexo
                            DropdownButtonFormField<String>(
                              value: _gender,
                              decoration:
                                  _buildInputDecoration('Sexo', Icons.wc),
                              items: ['Masculino', 'Feminino', 'Outro']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) =>
                                  setState(() => _gender = value),
                            ),
                            const SizedBox(height: 16),

                            // Nome do Pai
                            TextField(
                              controller: _fatherNameController,
                              decoration: _buildInputDecoration(
                                  'Nome do Pai', Icons.person_outline),
                            ),
                            const SizedBox(height: 16),

                            // Nome da Mãe
                            TextField(
                              controller: _motherNameController,
                              decoration: _buildInputDecoration(
                                  'Nome da Mãe', Icons.person_outline),
                            ),
                            const SizedBox(height: 24),

                            // Botão Salvar
                            PrimaryButton(
                              text: 'SALVAR',
                              icon: Icons.save,
                              onPressed: _saveProfile,
                            ),
                          ],
                        ),
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

<div align="center">
    <img src="https://github.com/user-attachments/assets/d58b6c82-e74b-40e3-99a5-e115656a481a" width="250" height="250" alt="Logo do BabySafe App">
    <br>
    <em>"O aplicativo BabySafe é uma solução voltada para clínicas, maternidades e pais de recém-nascidos, oferecendo recursos especializados para atender às necessidades desse público."</em>
    <br>
    <br>
    <img src="https://img.shields.io/badge/Framework-Flutter-blue?style=flat&logo=flutter&logoColor=white" alt="Framework">
    <img src="https://img.shields.io/badge/Language-Dart-0175C2?style=flat&logo=dart&logoColor=white" alt="Language">
    <img src="https://img.shields.io/badge/Cloud-Supabase-3ECF8E?style=flat&logo=supabase&logoColor=white" alt="Cloud">
    <img src="https://img.shields.io/badge/Cloud-Firebase-yellow?style=flat&logo=firebase&logoColor=black" alt="Cloud">
</div>

# Estrutura do Projeto

## main.dart
- **Tela de Splash** (tela inicial enquanto o app carrega)
- **Tela de Dashboard**
  - **Cabeçalho**:
    - Avatar (foto do usuário ou ícone neutro se não houver foto)
    - Saudação (ex.: "Olá, [nome]!")
  - **Estatísticas rápidas** (ex.: Peso, Altura, Temperatura)
  - **Menus de navegação**:
    - Menu: **Saúde** → Navega para Tela de Monitoramento
    - Menu: **Perfil** → Navega para Tela de Perfil
    - Menu: **Histórico** → Navega para Tela de Histórico
    - Menu: **Lembretes** → Navega para Tela de Lembretes
    - Menu: **Dicas e Educação** → Navega para Tela de Dicas e Educação
  - **Card de agendamento** (exemplo de consulta)

## Módulos do App
- **Modelos**:
  - `BabyProfile` (dados do perfil do bebê)
- **Serviços**:
  - `LocalAuth` (autenticação e simulação de banco de dados local)
- **Widgets**:
  - `PrimaryButton`, `SecondaryButton`, `MenuCard`, `LargeMenuCard`, `HealthIcon`, etc.
- **Painters**:
  - `MedicalPatternPainter` (padrão de fundo)
  - `WavePainter` (onda no topo)
  - `BottomWavePainter` (onda na base)

## Tela de Perfil
- Exibe campos para editar nome, data de nascimento, nome do pai/mãe, etc.
- Utiliza `DatePicker` para selecionar a data de nascimento
- Utiliza `ImagePicker` para escolher/atualizar a foto de perfil

## Outras Telas
- **Tela de Monitoramento** (exibe dados de saúde em tempo real)
- **Tela de Histórico** (exibe média diária e eventos; títulos centralizados)
- **Tela de Lembretes** (lista de agendamentos e lembretes)
- **Tela de Dicas e Educação** (lista de dicas e orientações para os pais)

### Diagrama da Estrutura do Projeto
<div align="center">
    <a href="https://github.com/user-attachments/assets/64a2876a-87e0-417d-aee5-8be38f14fd51">
        <img src="https://github.com/user-attachments/assets/64a2876a-87e0-417d-aee5-8be38f14fd51" width="3000" alt="Diagrama do BabySafe App">
    </a>
    <br>
    <em>Clique na imagem para visualizar em tamanho real.</em>
</div>

---

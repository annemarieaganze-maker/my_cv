import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MonCV());
}

class MonCV extends StatelessWidget {
  const MonCV({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CV Anne-Marie',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D2B52),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D2B52),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 3,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          color: Colors.white,
        ),
      ),
      home: const ConnexionPage(),
    );
  }
}

// We store the image as bytes so it works on Web + Mobile
Uint8List? profileImageBytes;

class ConnexionPage extends StatelessWidget {
  const ConnexionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D2B52), Color(0xFF1A3A6B), Color(0xFF0A1F3A)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Card(
                elevation: 16,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 40, 28, 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_outline_rounded, size: 52, color: Color(0xFF0D2B52)),
                      const SizedBox(height: 20),
                      const Text(
                        'Connexion',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D2B52),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Accédez à mon parcours inspirant',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 36),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Identifiant',
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                title: const Text('Mot de passe oublié'),
                                content: const Text(
                                  'Fonctionnalité non connectée pour le moment.\n\nCliquez simplement sur « Se connecter ».',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text(
                            'Mot de passe oublié ?',
                            style: TextStyle(color: Color(0xFF0D2B52)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D2B52),
                            foregroundColor: Colors.white,
                            elevation: 6,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const AccueilPage()),
                            );
                          },
                          child: const Text(
                            'Se connecter',
                            style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key});

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  Future<void> _changePhoto() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
      maxWidth: 800,
    );

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        profileImageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Anne-Marie Aganze', style: TextStyle(fontWeight: FontWeight.w600)),
          actions: [
            IconButton(
              icon: const Icon(Icons.camera_alt_outlined),
              onPressed: _changePhoto,
              tooltip: 'Changer la photo',
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.home_rounded), text: 'Accueil'),
              Tab(icon: Icon(Icons.people_alt_rounded), text: 'Famille'),
              Tab(icon: Icon(Icons.contact_mail_rounded), text: 'Contact'),
              Tab(icon: Icon(Icons.person_rounded), text: 'Profil'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CVPage(onPhotoTap: _changePhoto),
            const FamillePage(),
            const ContactPage(),
            ProfilPage(onPhotoTap: _changePhoto),
          ],
        ),
      ),
    );
  }
}

// ==================== PAGE CV ====================
class CVPage extends StatelessWidget {
  final VoidCallback onPhotoTap;
  const CVPage({super.key, required this.onPhotoTap});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 40),
      children: [
        // Photo + Name
        Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: onPhotoTap,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF0D2B52), width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0D2B52).withOpacity(0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: profileImageBytes != null
                            ? Image.memory(
                                profileImageBytes!,
                                fit: BoxFit.cover,
                                width: 150,
                                height: 150,
                              )
                            : Container(
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.person, size: 80, color: Colors.grey),
                              ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D2B52),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Aganze Rukomeza Anne-Marie',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D2B52),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D2B52).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'Entrepreneure  •  Tech  •  Impact social',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF0D2B52),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        _buildCard(
          title: 'MON HISTOIRE',
          child: const Text(
            'Je suis une jeune femme animée par une vision claire : utiliser la technologie et le leadership pour créer un impact réel dans ma communauté.\n\n'
            'Chaque défi est pour moi une opportunité d’apprendre, de grandir et d’inspirer les autres.',
            style: TextStyle(fontSize: 15.5, height: 1.65),
          ),
        ),
        _buildCard(
          title: 'FORMATION',
          child: Column(
            children: const [
              _InfoRow(year: '2024 – 2026', text: 'Informatique de Gestion'),
              _InfoRow(year: '2022 – 2023', text: 'Entrepreneuriat et Leadership'),
              _InfoRow(year: '2020 – 2022', text: 'Anglais et Développement personnel'),
            ],
          ),
        ),
        _buildCard(
          title: 'EXPÉRIENCE',
          child: Column(
            children: const [
              _Bullet('Volontariat en Logistique'),
              _Bullet('Stage en Informatique'),
              _Bullet('Projets à impact social'),
            ],
          ),
        ),
        _buildCard(
          title: 'COMPÉTENCES',
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _Chip(text: 'Excel', dark: true),
              _Chip(text: 'HTML & CSS', dark: true),
              _Chip(text: 'Base de données', dark: true),
            ],
          ),
        ),
        _buildCard(
          title: 'LANGUES',
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _Chip(text: 'Français'),
              _Chip(text: 'Anglais'),
              _Chip(text: 'Kiswahili'),
            ],
          ),
        ),
        _buildCard(
          title: 'CE QUI M’ANIME',
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _Chip(text: 'Entrepreneuriat social'),
              _Chip(text: 'Lecture'),
              _Chip(text: 'Art'),
              _Chip(text: 'Technologie'),
              _Chip(text: 'Sport'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 5,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D2B52),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D2B52),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String year;
  final String text;
  const _InfoRow({required this.year, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(year, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0D2B52))),
          ),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: Color(0xFF0D2B52)),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final bool dark;
  const _Chip({required this.text, this.dark = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF0D2B52) : const Color(0xFF0D2B52).withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: dark ? Colors.white : const Color(0xFF0D2B52),
          fontWeight: FontWeight.w600,
          fontSize: 13.5,
        ),
      ),
    );
  }
}

// ==================== PAGE FAMILLE ====================
class FamillePage extends StatelessWidget {
  const FamillePage({super.key});

  @override
  Widget build(BuildContext context) {
    final list = [
      {'name': 'Emmanuella Mwamba', 'relation': 'Nièce'},
      {'name': 'Bibisha', 'relation': 'Tante'},
      {'name': 'Martial', 'relation': 'Frère'},
    ];

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text('Ma Famille', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0D2B52))),
        const SizedBox(height: 16),
        ...list.map((person) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF0D2B52),
                child: Text(person['name']![0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              title: Text(person['name']!, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('Lien familial : ${person['relation']}'),
            ),
          );
        }),
      ],
    );
  }
}

// ==================== PAGE CONTACT ====================
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text('Me contacter', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0D2B52))),
        const SizedBox(height: 16),
        _tile(Icons.phone, 'Téléphone', '+243 991 089 655'),
        _tile(Icons.email, 'Email', 'annemarieaganze@gmail.com'),
        _tile(Icons.code, 'GitHub', 'annemariemaker'),
        _tile(Icons.link, 'LinkedIn', 'Anna'),
      ],
    );
  }

  Widget _tile(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0D2B52)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(value),
      ),
    );
  }
}

// ==================== PAGE PROFIL ====================
class ProfilPage extends StatelessWidget {
  final VoidCallback onPhotoTap;
  const ProfilPage({super.key, required this.onPhotoTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: onPhotoTap,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF0D2B52), width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0D2B52).withOpacity(0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: profileImageBytes != null
                          ? Image.memory(
                              profileImageBytes!,
                              fit: BoxFit.cover,
                              width: 180,
                              height: 180,
                            )
                          : Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.person, size: 100, color: Colors.grey),
                            ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0D2B52),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Aganze Anne-Marie',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D2B52)),
            ),
            const SizedBox(height: 8),
            Text(
              'Une vision. Une ambition. Un impact.',
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
import 'services/api_service.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';

void main() {
  runApp(const MonCV());
}

class MembreFamille {
  String nom;
  String lien;
  String telephone;

  MembreFamille({
    required this.nom,
    required this.lien,
    required this.telephone,
  });
}

class MonCV extends StatefulWidget {
  const MonCV({super.key});

  @override
  State<MonCV> createState() => _MonCVState();
}

class _MonCVState extends State<MonCV> {
  bool _estConnecte = false;
  String _utilisateurConnecte = '';
  int _indexActuel = 0;

  final List<MembreFamille> _membres = [
    MembreFamille(nom: 'Jean Aganze', lien: 'Père', telephone: '+243 ...'),
    MembreFamille(nom: 'Marie Kavira', lien: 'Mère', telephone: '+243 ...'),
  ];

  void _seConnecter(String identifiant) {
    setState(() {
      _utilisateurConnecte = identifiant;
      _estConnecte = true;
      _indexActuel = 0;
    });
  }
  Future<void> _soumettreConnexion(String email, String password) async {
  try {
    final res = await ApiService.login(
      email: email.trim(),
      password: password,
    );

    final user = res['data'];
    final nomAffiche = (user is Map && user['name'] != null)
        ? user['name'].toString()
        : email.trim();

    if (!mounted) return;
    _seConnecter(nomAffiche);
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur : $e')),
    );
  }
}

  void _seDeconnecter() {
    setState(() {
      _estConnecte = false;
      _utilisateurConnecte = '';
      _indexActuel = 0;
    });
  }

  void _allerVers(int index) {
    setState(() => _indexActuel = index);
  }

  void _ajouterMembre(MembreFamille m) {
    setState(() => _membres.add(m));
  }

  void _modifierMembre(int index, MembreFamille m) {
    setState(() => _membres[index] = m);
  }

  void _supprimerMembre(int index) {
    setState(() => _membres.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      AccueilPage(
        utilisateur: _utilisateurConnecte,
        nombreMembres: _membres.length,
        onAllerProfil: () => _allerVers(1),
        onAllerFamille: () => _allerVers(1),
      ),
      ProfilEtFamillePage(
        membres: _membres,
        onAjouter: _ajouterMembre,
        onModifier: _modifierMembre,
        onSupprimer: _supprimerMembre,
      ),
      const ContactPage(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mon CV - TP2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 6, 13, 72)),
        useMaterial3: true,
      ),
      home: !_estConnecte
          ? ConnexionPage(onConnecte: (identifiant){
            _soumettreConnexion(identifiant,'');
            }
          )
          : Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 16, 4, 71),
                foregroundColor: Colors.white,
                title: const Text('Aganze Anne-Marie'),
                actions: [
                  IconButton(
                    tooltip: 'Déconnexion',
                    onPressed: _seDeconnecter,
                    icon: const Icon(Icons.logout),
                  ),
                ],
              ),
              body: pages[_indexActuel],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _indexActuel,
                selectedItemColor: const Color.fromARGB(255, 3, 12, 66),
                unselectedItemColor: const Color.fromARGB(255, 234, 242, 247),
                onTap: _allerVers,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Accueil',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profil',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.contact_mail),
                    label: 'Contact',
                  ),
                ],
              ),
            ),
    );
  }
}

class ConnexionPage extends StatefulWidget {
  final void Function(String identifiant) onConnecte;

  const ConnexionPage({super.key, required this.onConnecte});

  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final _identifiantCtrl = TextEditingController();
  final _motDePasseCtrl = TextEditingController();
  String? _messageErreur;

  void _validerConnexion() {
    final identifiant = _identifiantCtrl.text.trim();
    final motDePasse = _motDePasseCtrl.text.trim();

    if (identifiant.isEmpty || motDePasse.isEmpty) {
      setState(() {
        _messageErreur =
            'Veuillez saisir votre identifiant et votre mot de passe.';
      });
      return;
    }

    setState(() => _messageErreur = null);
    widget.onConnecte(identifiant);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 14, 71),
        foregroundColor: Colors.white,
        title: const Text('Connexion'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Votre login',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Connectez-vous pour accéder à Notre CV.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _identifiantCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nom d\'utilisateur ou email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _motDePasseCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    if (_messageErreur != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        _messageErreur!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: _validerConnexion,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Se connecter'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Page Accueil dédiée uniquement à la bienvenue
class AccueilPage extends StatelessWidget {
  final String utilisateur;
  final int nombreMembres;
  final VoidCallback onAllerProfil;
  final VoidCallback onAllerFamille;

  const AccueilPage({
    super.key,
    required this.utilisateur,
    required this.nombreMembres,
    required this.onAllerProfil,
    required this.onAllerFamille,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenue',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              utilisateur.isEmpty
                  ? 'Bienvenue sur le CV numérique d\'Aganze .'
                  : 'Karibu, $utilisateur.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onAllerProfil,
              icon: const Icon(Icons.person),
              label: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Text('Voir notre Profil '),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Page Profil avec Photo, Membres de la famille attachés via bouton, et Expérience CV en bas
class ProfilEtFamillePage extends StatefulWidget {
  final List<MembreFamille> membres;
  final void Function(MembreFamille) onAjouter;
  final void Function(int, MembreFamille) onModifier;
  final void Function(int) onSupprimer;

  const ProfilEtFamillePage({
    super.key,
    required this.membres,
    required this.onAjouter,
    required this.onModifier,
    required this.onSupprimer,
  });

  @override
  State<ProfilEtFamillePage> createState() => _ProfilEtFamillePageState();
}

class _ProfilEtFamillePageState extends State<ProfilEtFamillePage> {
  bool _afficherMembresFamille = false;

  void _ouvrirFormulaire(
    BuildContext context, {
    MembreFamille? membre,
    int? index,
  }) {
    final nomCtrl = TextEditingController(text: membre?.nom ?? '');
    final lienCtrl = TextEditingController(text: membre?.lien ?? '');
    final telCtrl = TextEditingController(text: membre?.telephone ?? '');

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(membre == null ? 'Ajouter un membre' : 'Modifier le membre'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomCtrl,
              decoration: const InputDecoration(labelText: 'Nom complet'),
            ),
            TextField(
              controller: lienCtrl,
              decoration: const InputDecoration(labelText: 'Lien familial'),
            ),
            TextField(
              controller: telCtrl,
              decoration: const InputDecoration(labelText: 'Téléphone'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final nom = nomCtrl.text.trim();
              if (nom.isEmpty) return;

              final nouveau = MembreFamille(
                nom: nom,
                lien: lienCtrl.text.trim(),
                telephone: telCtrl.text.trim(),
              );

              if (index != null) {
                widget.onModifier(index, nouveau);
              } else {
                widget.onAjouter(nouveau);
              }

              Navigator.pop(dialogCtx);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _ouvrirDetail(BuildContext context, int index) {
    final pageContext = context;
    final membre = widget.membres[index];

    showModalBottomSheet(
      context: pageContext,
      builder: (sheetCtx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              membre.nom,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text('Lien : ${membre.lien}'),
            Text('Téléphone : ${membre.telephone}'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(sheetCtx);
                    widget.onSupprimer(index);
                  },
                  child: const Text(
                    'Supprimer',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(sheetCtx);
                    _ouvrirFormulaire(
                      pageContext,
                      membre: membre,
                      index: index,
                    );
                  },
                  child: const Text('Modifier'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // En-tête Profil avec Photo de Anne
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.indigo.shade100,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/profile.jpg',
                        width: 76,
                        height: 76,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.person,
                          size: 40,
                          color: Color.fromARGB(255, 18, 30, 101),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aganze Anne-Marie',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'une jeune Entrepreneure passionner par la Technologie,le Leadership Ethique et le Developpement communautaire',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Bouton attaché pour afficher ou masquer les membres de la famille
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Membres de la famille (${widget.membres.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _afficherMembresFamille = !_afficherMembresFamille;
                          });
                        },
                        icon: Icon(
                          _afficherMembresFamille
                              ? Icons.visibility_off
                              : Icons.people,
                        ),
                        label: Text(
                          _afficherMembresFamille ? 'Masquer' : 'Afficher',
                        ),
                      ),
                    ],
                  ),
                  if (_afficherMembresFamille) ...[
                    const SizedBox(height: 10),
                    const Divider(),
                    if (widget.membres.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('Aucun membre enregistré.'),
                      )
                    else
                      ...List.generate(widget.membres.length, (index) {
                        final m = widget.membres[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(m.nom),
                          subtitle: Text('${m.lien} • ${m.telephone}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _ouvrirDetail(context, index),
                        );
                      }),
                    const SizedBox(height: 6),
                    OutlinedButton.icon(
                      onPressed: () => _ouvrirFormulaire(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Ajouter un membre'),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Section Expérience (CV) en bas de page
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expérience & Parcours (CV)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.school, color: Colors.indigo),
                    title: Text('Informatique & Gestion'),
                    subtitle: Text(
                      'Développement d\'applications, bases de données et gestion de projets.',
                    ),
                  ),
                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.volunteer_activism, color: Colors.indigo),
                    title: Text('Initiatives numériques & communautaires'),
                    subtitle: Text(
                      'Accompagnement des jeunes filles au numérique, leadership et projets sociaux.',
                    ),
                  ),
                  
                   Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.volunteer_activism, color: Color.fromARGB(255, 10, 20, 77)),
                    title: Text('Volontariat'),
                    subtitle: Text(
                      'Logistique.',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 11, 23, 90),
        foregroundColor: Colors.white,
        onPressed: () => _ouvrirFormulaire(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nomCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  void _envoyerMessage() {
    if (_nomCtrl.text.trim().isEmpty || _messageCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir votre nom et votre message.'),
        ),
      );
      return;
    }
    final nom = _nomCtrl.text.trim();
    _nomCtrl.clear();
    _messageCtrl.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Message envoyé par $nom.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Me contacter',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('Goma, République démocratique du Congo'),
        const SizedBox(height: 16),
        TextField(
          controller: _nomCtrl,
          decoration: const InputDecoration(
            labelText: 'Votre nom',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _messageCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Votre message',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: _envoyerMessage,
          child: const Text('Envoyer'),
        ),
      ],
    );
  }
}


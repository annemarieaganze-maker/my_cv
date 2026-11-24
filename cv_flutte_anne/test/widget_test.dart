// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:cv_flutte_anne/main.dart';
 // 1.Charger et afficher votre application mon cv
void main() {
  testWidgets("Verification de l'affichage de la page CV", (WidgetTester tester) async {
await tester.pumpWidget(const MonCV());

    // Verifie que l'application demarre bien sans ecran blanc ni erreur.
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsWidgets);

  
    
  });
}

import 'package:flutter/material.dart';
import 'BottomSheet.dart';

class Charges extends StatelessWidget {
  const Charges({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FEFD), // Un fond très clair
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. HEADER (Bouton retour + Titre) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 16),
              child: Row(
                children: [
                  // Bouton retour personnalisé
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9F5F4), // Fond gris clair
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 12),
                      color: const Color(0xFF00423C),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  
                  const Expanded(
                    child: Text(
                      "Charges et Dettes",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00423C),
                      ),
                    ),
                  ),

                  const SizedBox(width: 40),
                ],
              ),
            ),

            // const SizedBox(height: 30),

            // --- 2. SECTION SOLDE ---
            const Text(
              "Total cumulé",
              style: TextStyle(
                color: Color(0x8000423C),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            // const SizedBox(height: 8),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "12 451 ",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00423C),
                    ),
                  ),
                  TextSpan(
                    text: "FCFA",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0x9900423C),
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE5FCC7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(image: AssetImage('assets/logos/mdi_chart-line.png'), height: 20, width: 20, color: Color(0xFF00423C)),
                  SizedBox(width: 8),
                  Text(
                    "Analyser mes dépenses",
                    style: TextStyle(
                      color: Color(0xFF004D47),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right, size: 20, color: Color(0xFF004D47)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- 3. BOUTONS D'ACTION (Ajouter / Payer) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  // Bouton Ajouter
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF078B7E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true, // Important pour que le sheet puisse prendre de la hauteur
                          backgroundColor: Colors.transparent, // Pour voir les coins arrondis du sheet
                          builder: (context) => const AddChargeSheet(),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Ajouter",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Bouton Payer
                  Expanded(
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFE3FFFC),
                        foregroundColor: const Color(0x80078B7E),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(color: Color(0xFFB2EBF2)),
                        ),
                      ),
                      onPressed: () {},
                      icon: const Image(image: AssetImage('assets/logos/money-hand.png'), height: 20, width: 20, color: Color(0xFF177C73)),
                      label: const Text("Payer",
                        style: TextStyle(
                          color: Color(0xFF177C73),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- 4. DIVIDER ---
            const Divider(height: 1, color: Colors.black12),

            // --- 5. ETAT VIDE (Empty State) ---
            Expanded(
              child: Center(
                child: Text(
                  "Aucunes charges ou dettes pour le moment",
                  style: TextStyle(
                    color: Color(0xFFAEBCBB),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
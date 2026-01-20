import 'package:flutter/material.dart';

class AddChargeSheet extends StatefulWidget {
  const AddChargeSheet({super.key});

  @override
  State<AddChargeSheet> createState() => _AddChargeSheetState();
}

class _AddChargeSheetState extends State<AddChargeSheet> {
  // Equivalent de tes data() dans Vue.js
  bool isChargesSelected = true; // Pour gérer l'onglet actif

  @override
  Widget build(BuildContext context) {
    // On récupère la taille du clavier pour éviter que les champs soient cachés
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        // Ajoute du padding en bas si le clavier est ouvert, sinon 20
        bottom: bottomPadding + 20, 
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        border: Border(
          top: BorderSide(
            color: Color(0xFF00423C),
            width: 1,
          ),
        ),
      ),
      // SingleChildScrollView permet de scroller si le clavier cache des champs
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Le sheet prend juste la hauteur nécessaire
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // --- 1. LES ONGLETS (Charges / Dettes) ---
            Container(
              height: 39,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE9F5F4),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  // Onglet Charges
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isChargesSelected = true;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          // Si sélectionné : Vert Lime, sinon transparent
                          color: isChargesSelected ? const Color(0xFFB2E623) : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Charges",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF004D47),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Onglet Dettes
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isChargesSelected = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: !isChargesSelected ? const Color(0xFFB2E623) : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Dettes",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF004D47),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // --- 2. LES CHAMPS DU FORMULAIRE ---
            
            // Champ Libellé
            _buildLabel("Libellé"),
            _buildTextField(hint: "Motif (Facultatif)"),

            const SizedBox(height: 10),

            // Champ Montant
            _buildLabel("Montant"),
            _buildTextField(hint: "Montant", suffixText: "FCFA"),

            const SizedBox(height: 10),

            // Champ Date
            _buildLabel("Date de début"),
            _buildTextField(
              hint: "Date",
              suffixIcon: Icons.calendar_today_outlined,
            ),

            const SizedBox(height: 10),

            // Champ Fréquence (Select)
            _buildLabel("Fréquence"),
            _buildTextField(
              hint: "Fréquence",
              isDropdown: true, // Un petit flag pour changer le style du bout
            ),

            const SizedBox(height: 40),

            // --- 3. BOUTON AJOUTER ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE0E0E0), // Gris (état désactivé visuel)
                  foregroundColor: Colors.grey[600],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // Action d'ajout ici
                },
                child: const Text(
                  "Ajouter",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
             const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // --- Helpers (Composants réutilisables internes) ---

  // Petit widget pour le titre au dessus de l'input
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF004D47),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  // Widget pour l'input (TextField)
  Widget _buildTextField({
    required String hint, 
    String? suffixText, 
    IconData? suffixIcon,
    bool isDropdown = false,
  }) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        // Bordure normale
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF004D47), width: 1.2),
        ),
        // Bordure quand on clique dedans
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFB2E623), width: 2),
        ),
        // Gestion de la partie droite (Suffix)
        suffixIcon: isDropdown 
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("Mois", style: TextStyle(color: Color(0xFF004D47), fontSize: 12)),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF004D47))
                  ],
                ),
              ),
            )
          : suffixIcon != null 
            ? Icon(suffixIcon, color: const Color(0xFF004D47), size: 20)
            : null,
        suffixText: suffixText,
        suffixStyle: const TextStyle(color: Color(0xFF004D47), fontWeight: FontWeight.bold),
      ),
    );
  }
}
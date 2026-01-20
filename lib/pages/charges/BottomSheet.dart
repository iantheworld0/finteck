import 'package:flutter/material.dart';

class AddChargeSheet extends StatefulWidget {
  const AddChargeSheet({super.key});

  @override
  State<AddChargeSheet> createState() => _AddChargeSheetState();
}

class _AddChargeSheetState extends State<AddChargeSheet> {
  // --- VARIABLES ---
  bool isChargesSelected = true;
  
  final TextEditingController _libelleController = TextEditingController();
  final TextEditingController _montantController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime? _selectedDate;
  String _selectedFrequency = "Mois"; 
  final List<String> frequencyOptions = ["Jour", "Mois", "Année"];

  // --- FONCTION DATE ---
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF004D47), 
              onPrimary: Colors.white,
              onSurface: Color(0xFF004D47),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: bottomPadding + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        border: Border(top: BorderSide(color: Color(0xFF00423C), width: 1)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // --- 1. ONGLETS ---
            Container(
              height: 39,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE9F5F4),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isChargesSelected = true),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isChargesSelected ? const Color(0xFFB2E623) : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        alignment: Alignment.center,
                        child: const Text("Charges", style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF004D47), fontSize: 16)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isChargesSelected = false),
                      child: Container(
                        decoration: BoxDecoration(
                          color: !isChargesSelected ? const Color(0xFFB2E623) : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        alignment: Alignment.center,
                        child: const Text("Dettes", style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF004D47), fontSize: 16)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // --- 2. CHAMPS ---
            
            // Libellé
            _buildLabel("Libellé"),
            TextField(
              controller: _libelleController,
              decoration: _inputDecoration("Motif (Facultatif)"),
            ),

            const SizedBox(height: 10),

            // Montant
            _buildLabel("Montant"),
            TextField(
              controller: _montantController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration("Montant").copyWith(
                suffixText: "FCFA",
                suffixStyle: const TextStyle(color: Color(0xFF004D47), fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            // Date
            _buildLabel("Date de début"),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: _selectDate,
              decoration: _inputDecoration("Date").copyWith(
                suffixIcon: const Icon(Icons.calendar_today_outlined, color: Color(0xFF004D47), size: 20),
              ),
            ),

            const SizedBox(height: 10),

          // --- FRÉQUENCE ---
            _buildLabel("Fréquence"),

            Container(
              height: 60,
              // Padding pour le texte à gauche
              padding: const EdgeInsets.only(left: 15, right: 10), 
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF004D47), width: 1.2),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  // 1. Le texte sélectionné s'affichera à gauche grâce à isExpanded
                  isExpanded: true,
                  value: _selectedFrequency,
                  
                  // 2. Le style du texte à GAUCHE (la valeur choisie)
                  style: const TextStyle(
                    color: Colors.black87, // Couleur du texte (ex: "Mois")
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),

                  // 3. L'icône à DROITE (On la remplace par votre bloc gris)
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0), // Le fond gris
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_down, 
                      size: 20, 
                      color: Color(0xFF004D47)
                    ),
                  ),

                  // 4. La liste des options
                  items: frequencyOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),

                  // 5. Mise à jour
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFrequency = newValue!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 40),

            // --- 3. BOUTON ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004D47),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  print("Ajouté: ${_libelleController.text}, Fréquence: $_selectedFrequency");
                },
                child: const Text(
                  "Ajouter",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
             const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // --- Helpers ---

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

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF004D47), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFB2E623), width: 2),
      ),
    );
  }
}
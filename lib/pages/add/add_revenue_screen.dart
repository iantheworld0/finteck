import 'package:fintecks/data/transaction_data.dart';
import 'package:fintecks/models/category_data.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:fintecks/models/transaction_model.dart'; 


class AddRevenueScreen extends StatefulWidget {
  const AddRevenueScreen({Key? key}) : super(key: key);

  @override
  State<AddRevenueScreen> createState() => _AddRevenueScreenState();
}

class _AddRevenueScreenState extends State<AddRevenueScreen> {
 
  final Color darkTeal = const Color(0xFF00695C); // Vert foncé texte
  final Color tealColor = const Color(0xFF00BFA5); // Vert vif
  final Color lightTealBg = const Color(0xFFF0FDFC); // Fond écran
  
  
  final TextEditingController _motifController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _montantController = TextEditingController();

  CategoryItem? selectedCategoryItem;
  DateTime? _selectedDate;

  void _saveTransaction() {
    if (selectedCategoryItem == null || _montantController.text.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir la catégorie, le montant et la date")),
      );
      return;
    }

    final newTransaction = TransactionModel(
      type: "Revenu",
      montant: double.tryParse(_montantController.text) ?? 0.0,
      date: _selectedDate!,
      categorie: selectedCategoryItem!.name, 
      motif: _motifController.text.isEmpty ? "Aucun motif" : _motifController.text,
    );

    final box = Hive.box<TransactionModel>('transactionsBox');
    box.add(newTransaction); 

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(backgroundColor: Colors.green, content: Text("Revenu ajouté !")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightTealBg, // Le fond cyan très clair
      body: SafeArea(
        bottom: false, 
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                      color: Colors.black87,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Ajout de revenus",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkTeal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), 
                ],
              ),
            ),

            const SizedBox(height: 10),
            Column(
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: darkTeal, 
                      fontFamily: 'Roboto', 
                    ),
                    children: [
                      TextSpan(text: "${totalIncome().toStringAsFixed(0)}"),
                      TextSpan(
                        text: "FCFA",
                        style: TextStyle(fontSize: 22, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_drop_up, color: Colors.green, size: 20),
                    const Text(
                      "+7,6% ",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "10 280 FCFA de plus",
                      style: TextStyle(color: darkTeal.withOpacity(0.7), fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      
                      _buildLabel("Catégorie"),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15), // Bordure arrondie
                          border: Border.all(color: darkTeal), // Bordure colorée
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<CategoryItem>(
                            value: selectedCategoryItem,
                            hint: Text("Sélectionnez une catégorie", style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                            isExpanded: true,
                            icon: Icon(Icons.keyboard_arrow_down, color: darkTeal),
                            items: addCategories.map((CategoryItem category) {
                              return DropdownMenuItem<CategoryItem>(
                                value: category,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(color: category.color.withOpacity(0.1), shape: BoxShape.circle),
                                      child: Icon(category.icon, size: 16, color: category.color),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(category.name, style: TextStyle(color: Colors.grey[800], fontSize: 14)),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => selectedCategoryItem = val),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),

                     
                      _buildLabel("Motif"),
                      TextField(
                        controller: _motifController,
                        decoration: _inputDecoration("Motif (Facultatif)"),
                      ),

                      const SizedBox(height: 20),

                      
                      _buildLabel("Date"),
                      TextField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: _inputDecoration("Date").copyWith(
                          suffixIcon: Icon(Icons.calendar_today_outlined, color: darkTeal, size: 20),
                        ),
                        onTap: () async {
                           DateTime? pickedDate = await showDatePicker(
                             context: context, initialDate: DateTime.now(),
                             firstDate: DateTime(2000), lastDate: DateTime(2101),
                             builder: (context, child) {
                               return Theme(
                                 data: Theme.of(context).copyWith(
                                   colorScheme: ColorScheme.light(primary: darkTeal, onPrimary: Colors.white, onSurface: darkTeal),
                                 ),
                                 child: child!,
                               );
                             }
                           );
                           if(pickedDate != null){
                             setState(() {
                               _selectedDate = pickedDate;
                               _dateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                             });
                           }
                        },
                      ),

                      const SizedBox(height: 20),

                      
                      _buildLabel("Montant"),
                      TextField(
                        controller: _montantController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration("Montant").copyWith(
                          suffixText: "FCFA",
                          suffixStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ),

                      const SizedBox(height: 40),

                      
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _saveTransaction,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkTeal, // Couleur vert foncé
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Ajouter",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper pour les titres (Catégorie, Motif...)
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 2),
      child: Text(
        text,
        style: TextStyle(
          color: darkTeal,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }

  // Helper pour le style des champs (Bordures arrondies fines)
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: darkTeal, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: darkTeal, width: 2), 
      ),
    );
  }
}
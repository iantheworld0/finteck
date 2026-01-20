import 'package:flutter/material.dart';

class AddTransactionBottomSheet extends StatefulWidget {
  const AddTransactionBottomSheet({super.key});

  
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: Colors.transparent, 
      builder: (context) => const AddTransactionBottomSheet(),
    );
  }

  @override
  State<AddTransactionBottomSheet> createState() => _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends State<AddTransactionBottomSheet> {
  
  final Color _primaryColor = const Color(0xFF00796B); 

  final TextEditingController _motifController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String? _selectedCategory;
  final List<String> _categories = ['Alimentation', 'Transport', 'Loisir', 'Santé', 'Autre'];

  @override
  void dispose() {
    _motifController.dispose();
    _dateController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: _primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final OutlineInputBorder _borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey),
    );

    final OutlineInputBorder _focusedBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: _primaryColor, width: 2),
    );

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 25,
        
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            
            _buildLabel("Catégorie"),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                hintText: "Sélectionnez une catégorie",
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: _borderStyle,
                enabledBorder: _borderStyle,
                focusedBorder: _focusedBorderStyle,
              ),
              items: _categories.map((String category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val),
            ),
            const SizedBox(height: 15),

            
            _buildLabel("Motif"),
            TextField(
              controller: _motifController,
              decoration: InputDecoration(
                hintText: "Motif (Facultatif)",
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: _borderStyle,
                enabledBorder: _borderStyle,
                focusedBorder: _focusedBorderStyle,
              ),
            ),
            const SizedBox(height: 15),

            
            _buildLabel("Date"),
            TextField(
              controller: _dateController,
              readOnly: true, 
              onTap: _selectDate,
              decoration: InputDecoration(
                hintText: "Date",
                suffixIcon: Icon(Icons.calendar_today_outlined, color: _primaryColor),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: _borderStyle,
                enabledBorder: _borderStyle,
                focusedBorder: _focusedBorderStyle,
              ),
            ),
            const SizedBox(height: 15),

            
            _buildLabel("Montant"),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Montant",
                suffixText: "FCFA", 
                suffixStyle: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: _borderStyle,
                enabledBorder: _borderStyle,
                focusedBorder: _focusedBorderStyle,
              ),
            ),
            const SizedBox(height: 30),

            
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  
                  Navigator.pop(context); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Ajouter",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D3E40),
          fontSize: 14,
        ),
      ),
    );
  }
}
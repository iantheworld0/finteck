import 'package:flutter/material.dart';

class CalendarButton extends StatelessWidget {
  final Function(DateTime) onDateSelected;

  const CalendarButton({Key? key, required this.onDateSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFEEF5F5), // Fond gris clair
        shape: BoxShape.circle,
      ),
      // IconButton a une zone de clic parfaite et un effet visuel intégré
      child: IconButton(
        icon: const Icon(Icons.calendar_today_outlined, size: 20),
        color: const Color(0xFF004D40), // Vert foncé
        onPressed: () async {
          // DEBUG : Pour voir si le clic part
          print("Bouton cliqué !"); 
          
          final DateTime now = DateTime.now();
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: now,
            firstDate: DateTime(2020),
            lastDate: DateTime(2030), // Important : doit être après 2026
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Color(0xFF004D40),
                    onPrimary: Colors.white,
                    onSurface: Color(0xFF004D40),
                  ),
                ),
                child: child!,
              );
            },
          );

          if (picked != null) {
            onDateSelected(picked);
          }
        },
      ),
    );
  }
}
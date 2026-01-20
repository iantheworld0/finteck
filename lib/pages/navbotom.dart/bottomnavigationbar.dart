import 'package:fintecks/pages/analyse/analysescreen.dart';
import 'package:fintecks/pages/home/HomeScreen.dart';
import 'package:flutter/material.dart';

class Bottom extends StatefulWidget {
  const Bottom({Key? key}) : super(key: key);

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int index_color = 0;

  
  final List<Widget> screens = [
    HomePage(),
    StatisticsPage(),       
    HomePage(),
    HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: screens[index_color],

      
      bottomNavigationBar: Container(
        height: 80, 
        decoration: BoxDecoration(
          color: Colors.white,
          
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            
            _buildNavItem(Icons.home, "Accueil", 0),
            _buildNavItem(Icons.bar_chart, "Analyse", 1),
            _buildNavItem(Icons.account_balance_wallet, "Portefeuille", 2),
            _buildNavItem(Icons.widgets_outlined, "Plus", 3),
          ],
        ),
      ),
    );
  }


  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = index_color == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          index_color = index;
        });
      },
      child: Container(
        color: Colors.transparent, 
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? Color(0xff368983) : Colors.grey,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Color(0xff368983) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
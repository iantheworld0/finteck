import 'package:fintecks/pages/add/add_expense_screen.dart';
import 'package:fintecks/pages/add/add_revenue_screen.dart';
import 'package:fintecks/widgets/calendar_button.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  
  final Color bgLightColor = const Color(0xFFF0F8F8); 
  final Color limeGreen = const Color(0xFFDCE775); 
  final Color darkGreen = const Color(0xFF004D40); 
  final Color barGrey = const Color(0xFFE0E0E0); 

 
  int _selectedTabIndex = 0; 
  int _selectedTimeIndex = 1; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLightColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context), 
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black54),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Analyses",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40), 
                  ],
                ),
              ),
              
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    _buildTopTab("Dépenses", 0),
                    _buildTopTab("Revenus", 1),
                    _buildTopTab("Objectifs", 2),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        
                        _selectedTabIndex == 1 ? "676 000 FCFA" : "102 000 FCFA",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: darkGreen,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            _selectedTabIndex == 1 ? Icons.arrow_drop_up : Icons.arrow_drop_down, 
                            color: _selectedTabIndex == 1 ? Colors.green : Colors.red, 
                            size: 20
                          ),
                          Text(
                            _selectedTabIndex == 1 ? "+7,6% " : "-2,6% ",
                            style: TextStyle(
                              color: _selectedTabIndex == 1 ? Colors.green : Colors.red, 
                              fontWeight: FontWeight.bold, 
                              fontSize: 13
                            ),
                          ),
                          Text(
                            _selectedTabIndex == 1 ? "de plus" : "de moins",
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  ),
                  
                  
                  GestureDetector(
                    onTap: () {
                      if (_selectedTabIndex == 1) {
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddRevenueScreen()),
                        );
                      } else if (_selectedTabIndex == 0) {
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
                        );
                      } else {
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Ajout d'objectif à venir...")),
                        );
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFF009688),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))
                        ]
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                  _buildTimeFilter("Jour", 0),
                  _buildTimeFilter("Semaine", 1),
                  _buildTimeFilter("Mois", 2),
                  _buildTimeFilter("Année", 3),
                  
                  CalendarButton(
                    onDateSelected: (DateTime date) {
                      print("Date choisie : $date");
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              SizedBox(
                height: 180,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28, 
                          getTitlesWidget: (value, meta) {
                            if (value == 0 || value == 25 || value == 50 || value == 75 || value == 100) {
                              return Text(
                                value == 0 ? "1k" : "${value.toInt()}k",
                                style: TextStyle(color: Colors.grey[400], fontSize: 9),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"];
                            if (value.toInt() < days.length) {
                              bool isSelected = value.toInt() == 5;
                              return Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text(
                                  days[value.toInt()],
                                  style: TextStyle(
                                    color: isSelected ? darkGreen : Colors.grey,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 11,
                                  ),
                                ),
                              );
                            }
                            return const Text("");
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                    barGroups: [
                      _makeBarGroup(0, 40, false),
                      _makeBarGroup(1, 25, false),
                      _makeBarGroup(2, 80, false),
                      _makeBarGroup(3, 50, false),
                      _makeBarGroup(4, 60, false),
                      _makeBarGroup(5, 95, true), 
                      _makeBarGroup(6, 55, false),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              _buildCategoryItem("Transport", "3 925 FCFA", const Color(0xFF7986CB)),
              _buildCategoryItem("Nourriture", "8 650 FCFA", const Color(0xFFFFB74D)),
              _buildCategoryItem("Charges (Dettes, et autres)", "13 925 FCFA", const Color(0xFFDCE775)),
              
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTopTab(String text, int index) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? limeGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? darkGreen : Colors.grey[600],
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeFilter(String text, int index) {
    bool isSelected = _selectedTimeIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTimeIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), 
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDCE775) : const Color(0xFFEEF5F5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: darkGreen,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, String amount, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87, fontSize: 13),
              ),
            ],
          ),
          Text(
            amount,
            style: TextStyle(fontWeight: FontWeight.bold, color: darkGreen, fontSize: 13),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, bool isActive) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isActive ? const Color(0xFFC6FF00) : const Color(0xFFE0E0E0),
          width: 25,
          borderRadius: BorderRadius.circular(4),
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFFDCE775), Color(0xFFC6FF00)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                )
              : null,
        ),
      ],
    );
  }
}

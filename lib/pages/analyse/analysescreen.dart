import 'package:fintecks/data/transaction_data.dart';
import 'package:fintecks/models/transaction_model.dart';
import 'package:fintecks/pages/add/add_expense_screen.dart';
import 'package:fintecks/pages/add/add_revenue_screen.dart';
import 'package:fintecks/widgets/calendar_button.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; 

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

  

  List<double> getChartValues(List<TransactionModel> allTransactions) {
    bool isYearView = _selectedTimeIndex == 3;
    int barCount = isYearView ? 12 : 7;
    List<double> values = List.filled(barCount, 0.0);

    DateTime now = DateTime.now();
    String targetType = _selectedTabIndex == 1 ? "Revenu" : "Dépense";

    for (var transaction in allTransactions) {
      if (transaction.type != targetType) continue;

      if (isYearView) {

        if (transaction.date.year == now.year) {
          int monthIndex = transaction.date.month - 1; 
          values[monthIndex] += transaction.montant;
        }
      } else {
        DateTime transactionDate = transaction.date;
        int diffDays = now.difference(transactionDate).inDays;
        
        
        int dayIndex = transactionDate.weekday - 1; 
        values[dayIndex] += transaction.montant;
      }
    }
    return values;
  }

  double getMaxY(List<double> values) {
    double max = 0;
    for (var v in values) {
      if (v > max) max = v;
    }
    return max == 0 ? 100 : max * 1.2;
  }

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
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black54),
                      ),
                    ),
                    Expanded(
                      child: Text("Analyses", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkGreen)),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              
              const SizedBox(height: 10),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                child: Row(
                  children: [
                    _buildTopTab("Dépenses", 0),
                    _buildTopTab("Revenus", 1),
                    _buildTopTab("Objectifs", 2),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),

              ValueListenableBuilder(
                valueListenable: Hive.box<TransactionModel>('transactionsBox').listenable(),
                builder: (context, Box<TransactionModel> box, _) {
                  double displayTotal = _selectedTabIndex == 1 ? totalIncome() : totalExpenses();

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${displayTotal.toStringAsFixed(0)} FCFA",
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: darkGreen),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(_selectedTabIndex == 1 ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: _selectedTabIndex == 1 ? Colors.green : Colors.red, size: 20),
                              Text(_selectedTabIndex == 1 ? "+7,6% " : "-2,6% ", style: TextStyle(color: _selectedTabIndex == 1 ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          )
                        ],
                      ),
                      
                      GestureDetector(
                        onTap: () {
                          if (_selectedTabIndex == 1) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddRevenueScreen()));
                          } else if (_selectedTabIndex == 0) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddExpenseScreen()));
                          }
                        },
                        child: Container(
                          width: 40, height: 40,
                          decoration: const BoxDecoration(color: Color(0xFF009688), shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))]),
                          child: const Icon(Icons.add, color: Colors.white, size: 22),
                        ),
                      ),
                    ],
                  );
                }
              ),
              
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTimeFilter("Jour", 0),
                  _buildTimeFilter("Semaine", 1), 
                  _buildTimeFilter("Mois", 2),
                  _buildTimeFilter("Année", 3),
                  CalendarButton(onDateSelected: (DateTime date) {}),
                ],
              ),
              
              const SizedBox(height: 20),
              SizedBox(
                height: 180,
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<TransactionModel>('transactionsBox').listenable(),
                  builder: (context, Box<TransactionModel> box, _) {
                    
                    List<TransactionModel> allData = box.values.toList();
                    
                    List<double> chartValues = getChartValues(allData);
                    
                    double dynamicMaxY = getMaxY(chartValues);

                    return BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: dynamicMaxY, 
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            
                            getTooltipColor: (group) => Colors.blueGrey,
                           
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                "${rod.toY.round()} FCFA",
                                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), // On cache les chiffres à gauche pour être clean
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                
                                if (_selectedTimeIndex == 3) {
                                  
                                   const months = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"];
                                   if (value.toInt() < months.length) {
                                     return Padding(padding: const EdgeInsets.only(top: 6), child: Text(months[value.toInt()], style: TextStyle(color: Colors.grey, fontSize: 10)));
                                   }
                                } else {
                                   
                                   const days = ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"];
                                   if (value.toInt() < days.length) {
                                    
                                     bool isToday = value.toInt() == (DateTime.now().weekday - 1);
                                     return Padding(
                                       padding: const EdgeInsets.only(top: 6.0),
                                       child: Text(
                                         days[value.toInt()],
                                         style: TextStyle(
                                           color: isToday ? darkGreen : Colors.grey,
                                           fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                           fontSize: 11,
                                         ),
                                       ),
                                     );
                                   }
                                }
                                return const Text("");
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: false),
                        
                        barGroups: List.generate(chartValues.length, (index) {
                          return _makeBarGroup(
                            index, 
                            chartValues[index], 
                            
                            chartValues[index] > 0 
                          );
                        }),
                      ),
                    );
                  }
                ),
              ),

              const SizedBox(height: 20),
              _buildCategoryItem("Transport", "3 925 FCFA", const Color(0xFF7986CB)),
              _buildCategoryItem("Nourriture", "8 650 FCFA", const Color(0xFFFFB74D)),
              _buildCategoryItem("Charges", "13 925 FCFA", const Color(0xFFDCE775)),
              
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
        child: Text(text, style: TextStyle(color: darkGreen, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontSize: 12)),
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
              Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87, fontSize: 13)),
            ],
          ),
          Text(amount, style: TextStyle(fontWeight: FontWeight.bold, color: darkGreen, fontSize: 13)),
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
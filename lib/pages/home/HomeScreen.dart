import 'package:fintecks/data/transaction_data.dart';
import 'package:fintecks/historiques/transaction_history.dart';
import 'package:fintecks/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final Color tealColor = const Color(0xFF00BFA5);
    final Color darkTealColor = const Color(0xFF00796B);
    final Color lightBgColor = const Color(0xFFF0F8F8);

    return Scaffold(
      backgroundColor: lightBgColor,
      body: SafeArea(
        child: Column(
          children: [           
            ValueListenableBuilder(
              valueListenable: Hive.box<TransactionModel>('transactionsBox').listenable(),
              builder: (context, box, _) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFB2DFDB),
                          tealColor.withOpacity(0.4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                              backgroundColor: Colors.white,
                            ),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(fontSize: 18, color: Colors.black87),
                                children: [
                                  const TextSpan(text: "waoh", style: TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: "finance", style: TextStyle(fontStyle: FontStyle.italic, color: darkTealColor)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.notifications, color: darkTealColor, size: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),                      
                        Text(
                          "Balance",
                          style: TextStyle(color: Colors.grey[700], fontSize: 14),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${totalBalance().toStringAsFixed(0)} FCFA",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF004D40),
                          ),
                        ),
                        const SizedBox(height: 15),                       
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00A693),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Icons.arrow_downward, color: Colors.white, size: 16),
                                        SizedBox(width: 5),
                                        Text("Revenus", style: TextStyle(color: Colors.white, fontSize: 12)),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "${totalIncome().toStringAsFixed(0)} FCFA",
                                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Icons.arrow_upward, color: Colors.grey, size: 16),
                                        SizedBox(width: 5),
                                        Text("Dépenses", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "${totalExpenses().toStringAsFixed(0)} FCFA",
                                      style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    const SizedBox(height: 5),
                    const TransactionHistory(), 
                    
                    const SizedBox(height: 15),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Vos objectifs",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3E40)),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text("Voir tout >", style: TextStyle(color: tealColor)),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Remboursement à Matthieu", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF2D3E40))),
                          Text("22 000 FCFA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: darkTealColor)),
                        ],
                      ),
                    ),

                    
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fintecks/models/transaction_model.dart'; 

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  IconData getIconForCategory(String categoryName) {
    switch (categoryName) {
      case "Salaire": return Icons.account_balance_wallet;
      case "Vente": return Icons.storefront;
      case "Investissement": return Icons.trending_up;
      case "Cadeau": return Icons.card_giftcard;
      case "Freelance": return Icons.laptop_mac;
      case "Autres": return Icons.more_horiz;
      default: return Icons.category; 
    }
  }


  Color getColorForCategory(String categoryName) {
    switch (categoryName) {
      case "Salaire": return const Color(0xFF00695C);
      case "Vente": return const Color(0xFF1E88E5);
      case "Investissement": return const Color(0xFF8E24AA);
      case "Cadeau": return const Color(0xFFD81B60);
      case "Freelance": return const Color(0xFFFB8C00);
      case "Autres": return const Color(0xFF757575);
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color tealColor = const Color(0xFF00BFA5); 

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Historique des Transactions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3E40)),
            ),
            TextButton(
              onPressed: () {
              },
              child: Text("Voir tout >", style: TextStyle(color: tealColor)),
            )
          ],
        ),
        
        const SizedBox(height: 10),
        Divider(color: Colors.grey[300], thickness: 1),
        ValueListenableBuilder(
          valueListenable: Hive.box<TransactionModel>('transactionsBox').listenable(),
          builder: (context, Box<TransactionModel> box, _) {
            
            if (box.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Text("Aucune transaction enregistrée."),
                ),
              );
            }
            List<TransactionModel> transactions = box.values.toList().reversed.toList();

            return ListView.builder(
              shrinkWrap: true, 
              physics: const NeverScrollableScrollPhysics(), 
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];

                return _buildTransactionItem(
                  
                  icon: getIconForCategory(transaction.categorie),
                  color: getColorForCategory(transaction.categorie),
                  
                  iconColor: Colors.white,
                  title: transaction.categorie, 
                  
                  
                  time: "${transaction.date.day}/${transaction.date.month} à ${transaction.date.hour}:${transaction.date.minute.toString().padLeft(2, '0')}",
                  
                  
                  amount: "${transaction.type == 'Revenu' ? '+' : '-'}${transaction.montant.toStringAsFixed(0)} FCFA",
                  
                  
                  type: transaction.motif,
                );
              },
            );
          },
        ),
      ],
    );
  }

  
  Widget _buildTransactionItem({
    required IconData icon,
    required Color color,
    Color iconColor = const Color(0xFF2D3E40),
    required String title,
    required String time,
    required String amount,
    required String type,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color, 
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 15),
          
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D3E40))),
                const SizedBox(height: 4),
                Text(time, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),

          
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  
                  color: amount.contains('+') ? const Color(0xFF00695C) : const Color(0xFF2D3E40), 
                ),
              ),
              const SizedBox(height: 4),
              Text(
                type.length > 15 ? "${type.substring(0, 12)}..." : type, 
                style: TextStyle(color: Colors.grey[500], fontSize: 12)
              ),
            ],
          ),
        ],
      ),
    );
  }
}
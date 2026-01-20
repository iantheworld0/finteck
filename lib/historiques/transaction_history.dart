import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fintecks/models/transaction_model.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  // --- 1. GESTION DES ICÔNES SELON L'IMAGE ---
  IconData getIconForCategory(String categoryName) {
    // On normalise en minuscules pour éviter les soucis de majuscules
    String name = categoryName.toLowerCase();
    
    if (name.contains("loyer")) return Icons.home_outlined;
    if (name.contains("salaire")) return Icons.download; // Icône flèche bas
    if (name.contains("nourriture")) return Icons.fastfood_outlined; // Icône burger
    if (name.contains("transport")) return Icons.directions_bus;
    if (name.contains("vente")) return Icons.storefront;
    
    return Icons.receipt_long; // Par défaut
  }

  // --- 2. GESTION DES COULEURS SELON L'IMAGE ---
  Color getColorForCategory(String categoryName) {
    String name = categoryName.toLowerCase();

    if (name.contains("loyer")) return const Color(0xFFDCE775); // Vert Lime (Image)
    if (name.contains("salaire")) return const Color(0xFF00695C); // Vert Foncé (Image)
    if (name.contains("nourriture")) return const Color(0xFFFFCC80); // Orange (Image)
    if (name.contains("transport")) return const Color(0xFF9FA8DA); // Bleu pâle
    
    return Colors.grey.shade300;
  }

  // --- 3. COULEUR DE L'ICONE (Blanc ou Noir selon le fond) ---
  Color getIconColorForCategory(String categoryName) {
    String name = categoryName.toLowerCase();
    // Sur le vert foncé, l'icone est blanche. Sur le Lime/Orange, elle est sombre.
    if (name.contains("salaire")) return Colors.white;
    return const Color(0xFF2D3E40);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- HEADER ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Historique des Transactions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3E40)),
            ),
            
            // --- BOUTON VOIR TOUT ---
            TextButton(
              onPressed: () {
                // Ouvre le BottomSheet avec toutes les transactions
                _showHistoryBottomSheet(context);
              },
              child: const Text("Voir tout >", style: TextStyle(color: Color(0xFF00BFA5))),
            )
          ],
        ),
        
        const SizedBox(height: 5),
        
        // Petit titre "AUJOURD'HUI" + Ligne
        Row(
          children: [
            Text("AUJOURD'HUI", style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            Expanded(child: Divider(color: Colors.grey[300])),
          ],
        ),
        
        const SizedBox(height: 15),

        // --- LISTE DES 3 DERNIERS ---
        ValueListenableBuilder(
          valueListenable: Hive.box<TransactionModel>('transactionsBox').listenable(),
          builder: (context, Box<TransactionModel> box, _) {
            
            if (box.isEmpty) {
              return const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("Aucune transaction.")));
            }

            // Récupère tout, inverse pour avoir les récents, et prends MAX 3
            List<TransactionModel> allTransactions = box.values.toList().reversed.toList();
            List<TransactionModel> recentTransactions = allTransactions.take(3).toList();

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentTransactions.length,
              itemBuilder: (context, index) {
                final transaction = recentTransactions[index];
                return _buildTransactionItem(transaction);
              },
            );
          },
        ),
      ],
    );
  }

  // --- FONCTION POUR OUVRIR LE BOTTOM SHEET (TOUT L'HISTORIQUE) ---
  void _showHistoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permet de prendre plus de hauteur
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85, // 85% de l'écran
          decoration: const BoxDecoration(
            color: Color(0xFFF0F8F8), // Fond clair
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              // Petite barre de drag
              Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              
              const Text("Toutes les transactions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D3E40))),
              const SizedBox(height: 20),

              // Liste Complète
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<TransactionModel>('transactionsBox').listenable(),
                  builder: (context, Box<TransactionModel> box, _) {
                    List<TransactionModel> allTransactions = box.values.toList().reversed.toList();
                    
                    return ListView.builder(
                      itemCount: allTransactions.length,
                      itemBuilder: (context, index) {
                        return _buildTransactionItem(allTransactions[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- WIDGET HELPER POUR DESSINER UNE LIGNE ---
  Widget _buildTransactionItem(TransactionModel transaction) {
    
    // Logique d'affichage
    String title = transaction.categorie; // Ex: Paiement du loyer
    // Si le motif est rempli, on peut l'utiliser comme titre, sinon la catégorie
    if (transaction.motif.isNotEmpty && transaction.motif != "Aucun motif") {
      title = transaction.motif;
    }

    String typeLabel = transaction.type == "Revenu" ? "Réception" : "Dépense"; 
    // Pour l'image : "Transfert", "Retrait", etc. on peut simuler :
    if (title.toLowerCase().contains("loyer")) typeLabel = "Transfert";
    if (title.toLowerCase().contains("nourriture")) typeLabel = "Retrait";

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // 1. Cercle Icône
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: getColorForCategory(title),
              shape: BoxShape.circle,
            ),
            child: Icon(
              getIconForCategory(title), 
              color: getIconColorForCategory(title), 
              size: 24
            ),
          ),
          const SizedBox(width: 15),

          // 2. Titre et Heure
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D3E40)),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "${transaction.date.hour}:${transaction.date.minute.toString().padLeft(2, '0')}", 
                  style: TextStyle(color: Colors.grey[500], fontSize: 12)
                ),
              ],
            ),
          ),

          // 3. Montant et Type
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${transaction.type == 'Revenu' ? '+' : '-'}${transaction.montant.toStringAsFixed(0)} FCFA",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF004D40), // Toujours foncé sur l'image
                ),
              ),
              const SizedBox(height: 4),
              Text(
                typeLabel, 
                style: TextStyle(color: Colors.grey[500], fontSize: 12)
              ),
            ],
          ),
        ],
      ),
    );
  }
}
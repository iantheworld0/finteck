import 'package:hive/hive.dart';
import 'package:fintecks/models/transaction_model.dart'; // Importe ton modèle

// Accès direct à la boite ouverte
final box = Hive.box<TransactionModel>('transactionsBox');

// ----------------------------------------------------
// 1. CALCULS DES TOTAUX (Solde, Revenus, Dépenses)
// ----------------------------------------------------

// Calcul du solde total (Revenus - Dépenses)
double totalBalance() {
  var history = box.values.toList();
  double total = 0;
  
  for (var i = 0; i < history.length; i++) {
    if (history[i].type == 'Revenu') {
      total += history[i].montant;
    } else {
      // Si c'est une dépense, on soustrait
      total -= history[i].montant;
    }
  }
  return total;
}

// Calcul total des revenus
double totalIncome() {
  var history = box.values.toList();
  double total = 0;
  
  for (var i = 0; i < history.length; i++) {
    if (history[i].type == 'Revenu') {
      total += history[i].montant;
    }
  }
  return total;
}

// Calcul total des dépenses
double totalExpenses() {
  var history = box.values.toList();
  double total = 0;
  
  for (var i = 0; i < history.length; i++) {
    if (history[i].type == 'Dépense') {
      total += history[i].montant;
    }
  }
  return total;
}

// ----------------------------------------------------
// 2. FILTRES PAR DATE (Corrigés et Robustes)
// ----------------------------------------------------

// Liste des transactions d'AUJOURD'HUI
List<TransactionModel> getTodayTransactions() {
  List<TransactionModel> results = [];
  var history = box.values.toList();
  DateTime now = DateTime.now();

  for (var item in history) {
    // On vérifie Année, Mois ET Jour
    if (item.date.year == now.year && 
        item.date.month == now.month && 
        item.date.day == now.day) {
      results.add(item);
    }
  }
  return results;
}

// Liste des transactions de la SEMAINE (7 derniers jours)
List<TransactionModel> getWeekTransactions() {
  List<TransactionModel> results = [];
  var history = box.values.toList();
  DateTime now = DateTime.now();
  
  // On crée une date "propre" sans les heures/minutes pour bien comparer
  DateTime today = DateTime(now.year, now.month, now.day); 

  for (var item in history) {
    DateTime itemDate = DateTime(item.date.year, item.date.month, item.date.day);
    
    // Calcul de la différence en jours
    int difference = today.difference(itemDate).inDays;

    // Si la différence est entre 0 et 7 jours
    if (difference >= 0 && difference <= 7) {
      results.add(item);
    }
  }
  return results;
}

// Liste des transactions du MOIS en cours
List<TransactionModel> getMonthTransactions() {
  List<TransactionModel> results = [];
  var history = box.values.toList();
  DateTime now = DateTime.now();

  for (var item in history) {
    // On vérifie Année ET Mois
    if (item.date.year == now.year && 
        item.date.month == now.month) {
      results.add(item);
    }
  }
  return results;
}


List<TransactionModel> getYearTransactions() {
  List<TransactionModel> results = [];
  var history = box.values.toList();
  DateTime now = DateTime.now();

  for (var item in history) {
    if (item.date.year == now.year) {
      results.add(item);
    }
  }
  return results;
}
import 'package:hive/hive.dart';

// Cette ligne est importante pour la génération automatique du code
part 'transaction_model.g.dart';

@HiveType(typeId: 0) // Chaque modèle doit avoir un ID unique
class TransactionModel extends HiveObject {
  @HiveField(0)
  late String type; // "Revenu" ou "Dépense"

  @HiveField(1)
  late double montant;

  @HiveField(2)
  late DateTime date;

  @HiveField(3)
  late String categorie;

  @HiveField(4)
  late String motif;

  TransactionModel({
    required this.type,
    required this.montant,
    required this.date,
    required this.categorie,
    required this.motif,
  });
}
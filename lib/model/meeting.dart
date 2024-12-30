import 'package:cloud_firestore/cloud_firestore.dart';

class Meeting {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String creatorId; // Champ pour l'ID du créateur
  final String lieu; // Nouveau champ pour le lieu

  Meeting({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.creatorId,
    required this.lieu, // Ajout du paramètre lieu
  });

  // Convertir une Map Firestore en une instance de Meeting
  factory Meeting.fromMap(Map<String, dynamic> data, String id) {
    // Vérifiez que tous les champs nécessaires sont présents, y compris creatorId et lieu
    if (data['title'] == null ||
        data['description'] == null ||
        data['date'] == null ||
        data['creatorId'] == null ||
        data['lieu'] == null) { // Vérifier le champ lieu
      throw Exception('Champs manquants dans les données : $data');
    }
    return Meeting(
      id: id,
      title: data['title'],
      description: data['description'],
      date: (data['date'] as Timestamp).toDate(),
      creatorId: data['creatorId'], // Récupération de creatorId
      lieu: data['lieu'], // Récupération du champ lieu
    );
  }

  // Convertir une instance de Meeting en Map Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'creatorId': creatorId,
      'lieu': lieu, // Inclure lieu dans la Map
    };
  }
}

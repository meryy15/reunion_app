import 'package:application_reunion/service/notification_service.dart'; // Importer le service de notification
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth pour obtenir l'utilisateur actuel
import '../model/meeting.dart';

class MeetingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Ajouter une réunion avec le champ lieu et notification
  Future<void> addMeeting(String title, String description, DateTime date, String lieu) async {
    try {
      // Initialiser les notifications locales
      NotificationService notificationService = NotificationService();
      await notificationService.initializeNotifications(); // Initialiser les notifications

      // Récupérer l'utilisateur actuellement authentifié
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Utilisateur non authentifié');
      }

      // Ajouter la réunion dans Firestore
      await _db.collection('meetings').add({
        'title': title,
        'description': description,
        'date': Timestamp.fromDate(date),
        'creatorId': user.uid,
        'lieu': lieu,
      });

      // Planifier la notification 15 minutes avant la réunion
      await notificationService.scheduleMeetingNotification(date, title);
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'ajout de la réunion: $e');
      }
      throw Exception('Erreur lors de l\'ajout de la réunion');
    }
  }

  // Obtenir les réunions, incluant le champ lieu
  Stream<List<Meeting>> getMeetings() {
    return _db.collection('meetings').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Meeting.fromMap(doc.data(), doc.id); // Le champ lieu sera inclus dans Meeting.fromMap
      }).toList();
    });
  }

  // Supprimer une réunion
  Future<void> deleteMeeting(String meetingId) async {
    try {
      final meetingSnapshot = await _db.collection('meetings').doc(meetingId).get();
      final meetingTitle = meetingSnapshot['title'];
      final creatorId = meetingSnapshot['creatorId']; // Récupérer l'ID du créateur

      // Vérifier si l'utilisateur actuel est le créateur
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null || user.uid != creatorId) {
        throw Exception('Vous n\'êtes pas autorisé à supprimer cette réunion');
      }

      await _db.collection('meetings').doc(meetingId).delete();
      // Afficher une notification après la suppression
      NotificationService notificationService = NotificationService();
      await notificationService.showNotification("Réunion supprimée", "La réunion '$meetingTitle' a été supprimée.");
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la suppression: $e');
      }
      throw Exception('Erreur lors de la suppression de la réunion');
    }
  }

  // Mettre à jour une réunion avec le champ lieu
  Future<void> updateMeeting(String meetingId, String title, String description, DateTime date, String lieu) async {
    try {
      final meetingSnapshot = await _db.collection('meetings').doc(meetingId).get();
      final creatorId = meetingSnapshot['creatorId']; // Récupérer l'ID du créateur

      // Vérifier si l'utilisateur actuel est le créateur
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null || user.uid != creatorId) {
        throw Exception('Vous n\'êtes pas autorisé à modifier cette réunion');
      }

      await _db.collection('meetings').doc(meetingId).update({
        'title': title,
        'description': description,
        'date': Timestamp.fromDate(date),
        'lieu': lieu, // Mettre à jour le champ lieu
      });

      // Afficher une notification après la mise à jour
      NotificationService notificationService = NotificationService();
      await notificationService.showNotification("Réunion mise à jour", "La réunion '$title' a été mise à jour.");
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la mise à jour: $e');
      }
      throw Exception('Erreur lors de la mise à jour de la réunion');
    }
  }
}

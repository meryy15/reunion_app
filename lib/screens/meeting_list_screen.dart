import 'package:flutter/material.dart';
import '../model/meeting.dart';
import '../service/meeting_service.dart';
import 'package:intl/intl.dart'; // Pour formater la date
import 'package:firebase_auth/firebase_auth.dart'; // Pour obtenir l'utilisateur actuel

class MeetingListScreen extends StatelessWidget {
  const MeetingListScreen({super.key});

  void _showAddMeetingDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController lieuController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(selectedDate);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Ajouter une réunion',
            style: TextStyle(color: Color.fromARGB(255, 0, 49, 133), fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Titre',
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 0, 49, 133)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 0, 49, 133)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: lieuController,
                  decoration: const InputDecoration(
                    labelText: 'Lieu',
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 0, 49, 133)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      selectedDate = pickedDate;
                    }
                    final TimeOfDay? pickedTime = await showTimePicker(
                      // ignore: use_build_context_synchronously
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (pickedTime != null && pickedTime != selectedTime) {
                      selectedTime = pickedTime;
                      selectedDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    }
                  },
                  child: const Text(
                    'Choisir la date et l\'heure',
                    style: TextStyle(color: Color.fromARGB(255, 0, 49, 133)),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Date et Heure: ${DateFormat('dd/MM/yyyy HH:mm').format(selectedDate)}',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Annuler',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () async {
                await MeetingService().addMeeting(
                  titleController.text,
                  descriptionController.text,
                  selectedDate,
                  lieuController.text,
                );
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              child: const Text(
                'Ajouter',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditMeetingDialog(BuildContext context, Meeting meeting) {
    final TextEditingController titleController =
        TextEditingController(text: meeting.title);
    final TextEditingController descriptionController =
        TextEditingController(text: meeting.description);
    final TextEditingController lieuController =
        TextEditingController(text: meeting.lieu);
    DateTime selectedDate = meeting.date;
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(meeting.date);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Modifier la réunion',
            style: TextStyle(
                color: Color.fromARGB(255, 0, 49, 133),
                fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Titre',
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 0, 49, 133)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 0, 49, 133)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: lieuController,
                  decoration: const InputDecoration(
                    labelText: 'Lieu',
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 0, 49, 133)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      selectedDate = pickedDate;
                    }
                    final TimeOfDay? pickedTime = await showTimePicker(
                      // ignore: use_build_context_synchronously
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (pickedTime != null && pickedTime != selectedTime) {
                      selectedTime = pickedTime;
                      selectedDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    }
                  },
                  child: const Text(
                    'Choisir la date et l\'heure',
                    style: TextStyle(color: Color.fromARGB(255, 0, 49, 133)),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Date et Heure: ${DateFormat('dd/MM/yyyy HH:mm').format(selectedDate)}',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Annuler',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () async {
                await MeetingService().updateMeeting(
                  meeting.id,
                  titleController.text,
                  descriptionController.text,
                  selectedDate,
                  lieuController.text,
                );
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              child: const Text(
                'Modifier',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteMeeting(BuildContext context, String meetingId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Confirmer la suppression',
            style: TextStyle(color: Colors.red),
          ),
          content:
              const Text('Êtes-vous sûr de vouloir supprimer cette réunion ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Annuler',
                style: TextStyle(color: Color.fromARGB(255, 0, 49, 133)),
              ),
            ),
            TextButton(
              onPressed: () async {
                await MeetingService().deleteMeeting(meetingId);
                // ignore: use_build_context_synchronously
                Navigator.of(context)
                    .pop(); // Fermer la boîte de dialogue après la suppression
              },
              child: const Text(
                'Supprimer',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Réunions',
            style: TextStyle( color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 49, 133),
      ),
      body: StreamBuilder<List<Meeting>>(
        stream: MeetingService().getMeetings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune réunion à afficher.'));
          }

          final meetings = snapshot.data!;
          return ListView.builder(
  itemCount: meetings.length,
  itemBuilder: (context, index) {
    final meeting = meetings[index];
    final currentUser = FirebaseAuth.instance.currentUser;

    bool canEditOrDelete = currentUser != null && currentUser.uid == meeting.creatorId;

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          meeting.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Date: ${DateFormat('dd/MM/yyyy HH:mm').format(meeting.date)}\n'
          'Lieu: ${meeting.lieu}\n' // Ajout du lieu ici
          'Description: ${meeting.description}',
        ),
        trailing: canEditOrDelete
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color.fromARGB(255, 0, 49, 133)),
                    onPressed: () => _showEditMeetingDialog(context, meeting),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteMeeting(context, meeting.id),
                  ),
                ],
              )
            : null,
      ),
    );
  },
);

        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMeetingDialog(context),
        backgroundColor: const Color.fromARGB(255, 0, 49, 133),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

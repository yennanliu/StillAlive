import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/emergency_contact.dart';
import '../../providers/providers.dart';
import '../onboarding/widgets/contact_form.dart';

/// Screen for adding a new emergency contact
class AddContactScreen extends ConsumerWidget {
  const AddContactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Emergency Contact'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ContactForm(
            onSave: (name, phone, relationship) async {
              final contact = EmergencyContact(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: name,
                phoneNumber: phone,
                relationship: relationship,
                createdAt: DateTime.now(),
              );

              await ref
                  .read(contactsNotifierProvider.notifier)
                  .addContact(contact);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$name added as emergency contact')),
                );
                Navigator.of(context).pop();
              }
            },
            onCancel: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}

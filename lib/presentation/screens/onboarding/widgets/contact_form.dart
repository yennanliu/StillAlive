import 'package:flutter/material.dart';
import '../../../../data/models/emergency_contact.dart';

/// Reusable contact form widget for add/edit operations
class ContactForm extends StatefulWidget {
  final EmergencyContact? contact; // null for add, populated for edit
  final Function(String name, String phone, String? relationship) onSave;
  final VoidCallback? onCancel;
  final bool showCancelButton;

  const ContactForm({
    super.key,
    this.contact,
    required this.onSave,
    this.onCancel,
    this.showCancelButton = true,
  });

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _relationshipController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
    _phoneController =
        TextEditingController(text: widget.contact?.phoneNumber ?? '');
    _relationshipController =
        TextEditingController(text: widget.contact?.relationship ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  bool _validatePhoneNumber(String phone) {
    final regex = RegExp(r'^\+[1-9]\d{1,14}$');
    return regex.hasMatch(phone);
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        _nameController.text.trim(),
        _phoneController.text.trim(),
        _relationshipController.text.trim().isEmpty
            ? null
            : _relationshipController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Enter contact name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Name is required';
              }
              if (value.length > 50) {
                return 'Name must be less than 50 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: '+1234567890',
              helperText: 'Format: +[country code][number]',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Phone number is required';
              }
              if (!_validatePhoneNumber(value.trim())) {
                return 'Invalid format. Use: +1234567890';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _relationshipController,
            decoration: const InputDecoration(
              labelText: 'Relationship (Optional)',
              hintText: 'e.g., Family, Friend, Neighbor',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.group),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              if (widget.showCancelButton) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onCancel,
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleSave,
                  child: Text(widget.contact == null ? 'Add Contact' : 'Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../services/firestore_service.dart';
import '../widgets/eco_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_label.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.firestore, required this.auth});

  final FirestoreService firestore;
  final FirebaseAuth auth;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController(text: '+237 ');
  final _locationController = TextEditingController(text: 'Buea, Cameroon');
  final _smsController = TextEditingController();

  String _role = 'generator';
  String _generatorType = 'individual';
  String _vehicleSize = 'Handcart/Tricycle';
  String? _verificationId;
  String? _error;
  bool _codeSent = false;
  bool _loading = false;

  final _vehicleOptions = const [
    'Handcart/Tricycle',
    'Small Pickup Truck',
    'Large Waste Truck',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _smsController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty) {
      setState(() => _error = 'Name, verified phone number, and location are required.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    await widget.auth.verifyPhoneNumber(
      phoneNumber: _phoneController.text.trim(),
      verificationCompleted: (credential) async => _finishWithCredential(credential),
      verificationFailed: (exception) {
        setState(() {
          _error = exception.message ?? 'Phone verification failed.';
          _loading = false;
        });
      },
      codeSent: (verificationId, _) {
        setState(() {
          _verificationId = verificationId;
          _codeSent = true;
          _loading = false;
        });
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> _verifySmsCode() async {
    if (_verificationId == null || _smsController.text.trim().isEmpty) {
      setState(() => _error = 'Enter the SMS verification code.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: _smsController.text.trim(),
    );
    await _finishWithCredential(credential);
  }

  Future<void> _finishWithCredential(PhoneAuthCredential credential) async {
    try {
      final userCredential = await widget.auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) throw Exception('No authenticated Firebase user returned.');
      final user = AppUser(
        uid: firebaseUser.uid,
        name: _nameController.text.trim(),
        phoneNumber: firebaseUser.phoneNumber ?? _phoneController.text.trim(),
        role: _role,
        generatorType: _role == 'generator' ? _generatorType : null,
        generalLocation: _locationController.text.trim(),
      );
      await widget.firestore.saveUser(
        user,
        vehicleSize: _role == 'collector' ? _vehicleSize : null,
      );
    } catch (error) {
      setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EcoBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Re-kollect', style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(height: 6),
                      Text(
                        'Verified phone onboarding for waste generators and collectors in Buea.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      const SectionLabel('Choose your role'),
                      Row(
                        children: [
                          Expanded(child: _RoleButton(label: 'Generator', selected: _role == 'generator', onTap: () => setState(() => _role = 'generator'))),
                          const SizedBox(width: 12),
                          Expanded(child: _RoleButton(label: 'Collector', selected: _role == 'collector', onTap: () => setState(() => _role = 'collector'))),
                        ],
                      ),
                      const SizedBox(height: 18),
                      TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(labelText: 'Phone number'),
                      ),
                      const SizedBox(height: 12),
                      TextField(controller: _locationController, decoration: const InputDecoration(labelText: 'General location')),
                      const SizedBox(height: 18),
                      if (_role == 'generator') ...[
                        const SectionLabel('Generator type'),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _GlassChoice(label: 'Individual', value: 'individual', groupValue: _generatorType, onSelected: (value) => setState(() => _generatorType = value)),
                            _GlassChoice(label: 'Household', value: 'household', groupValue: _generatorType, onSelected: (value) => setState(() => _generatorType = value)),
                            _GlassChoice(label: 'Business', value: 'business', groupValue: _generatorType, onSelected: (value) => setState(() => _generatorType = value)),
                          ],
                        ),
                      ] else ...[
                        const SectionLabel('Vehicle capacity'),
                        DropdownButtonFormField<String>(
                          value: _vehicleSize,
                          dropdownColor: const Color(0xFF064E3B),
                          items: _vehicleOptions.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                          onChanged: (value) => setState(() => _vehicleSize = value ?? _vehicleSize),
                          decoration: const InputDecoration(labelText: 'Vehicle size'),
                        ),
                      ],
                      if (_codeSent) ...[
                        const SizedBox(height: 18),
                        TextField(
                          controller: _smsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'SMS verification code'),
                        ),
                      ],
                      if (_error != null) ...[
                        const SizedBox(height: 14),
                        Text(_error!, style: const TextStyle(color: Color(0xFF4ADE80), fontWeight: FontWeight.w700)),
                      ],
                      const SizedBox(height: 22),
                      FilledButton(
                        onPressed: _loading ? null : (_codeSent ? _verifySmsCode : _sendCode),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(_loading ? 'Please wait...' : (_codeSent ? 'Verify & Continue' : 'Send SMS Code')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  const _RoleButton({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF10B981).withOpacity(0.45) : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(selected ? 0.45 : 0.20)),
        ),
        child: Center(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))),
      ),
    );
  }
}

class _GlassChoice extends StatelessWidget {
  const _GlassChoice({required this.label, required this.value, required this.groupValue, required this.onSelected});

  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(value),
      selectedColor: const Color(0xFF4ADE80).withOpacity(0.35),
      backgroundColor: Colors.white.withOpacity(0.08),
      labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      side: BorderSide(color: Colors.white.withOpacity(0.25)),
    );
  }
}

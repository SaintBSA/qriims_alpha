import 'package:flutter/material.dart';
import 'db_helper.dart';

class AddTechnicianForm extends StatefulWidget {
  const AddTechnicianForm({super.key});

  @override
  _AddTechnicianFormState createState() => _AddTechnicianFormState();
}

class _AddTechnicianFormState extends State<AddTechnicianForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaTeknisiController = TextEditingController();
  final _nikTeknisiController = TextEditingController();
  final _noTeleponController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final DBHelper _dbHelper = DBHelper();

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String namaTeknisi = _namaTeknisiController.text.trim();
    int? nikTeknisi = int.tryParse(_nikTeknisiController.text.trim());
    int? noTelepon = int.tryParse(_noTeleponController.text.trim());
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    try {
      await _dbHelper.addTechnician(
        nama: namaTeknisi,
        nik: nikTeknisi!,
        noTelepon: noTelepon!,
        email: email,
        password: password,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Technician added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add technician: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Technician'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _namaTeknisiController,
                  decoration: const InputDecoration(hintText: 'Technician Name'),
                  validator: (value) => value == null || value.isEmpty ? 'This field is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nikTeknisiController,
                  decoration: const InputDecoration(hintText: 'NIK'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'This field is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _noTeleponController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(hintText: 'Phone Number'),
                  validator: (value) => value == null || value.isEmpty ? 'This field is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'This field is required';
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) return 'Please enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Password'),
                  validator: (value) => value == null || value.isEmpty ? 'This field is required' : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add Technician'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaTeknisiController.dispose();
    _nikTeknisiController.dispose();
    _noTeleponController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
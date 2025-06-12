import 'package:flutter/material.dart';
import 'db_helper.dart';

class AddTechnicianForm extends StatefulWidget {
  const AddTechnicianForm({super.key});

  @override
  _AddTechnicianFormState createState() => _AddTechnicianFormState();
}

class _AddTechnicianFormState extends State<AddTechnicianForm> {
  final _namaTeknisiController = TextEditingController();
  final _nikTeknisiController = TextEditingController();
  final _noTeleponController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final DBHelper _dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Technician'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 16),
              TextField(
                controller: _namaTeknisiController,
                decoration: const InputDecoration(
                  labelText: 'Technician Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nikTeknisiController,
                decoration: const InputDecoration(
                  labelText: 'NIK',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _noTeleponController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () async {
                  String namaTeknisi = _namaTeknisiController.text.trim();
                  int? nikTeknisi = int.tryParse(_nikTeknisiController.text.trim());
                  int? noTelepon = int.tryParse(_noTeleponController.text.trim());
                  String email = _emailController.text.trim();
                  String password = _passwordController.text;

                  if (namaTeknisi.isEmpty || nikTeknisi == null || noTelepon == null || email.isEmpty || password.isEmpty) {
                    _showSnackBar(context, 'Please fill in all fields correctly.', isError: true);
                    return;
                  }

                  try {
                    await _dbHelper.addTechnician(
                      nama: namaTeknisi,
                      nik: nikTeknisi,
                      noTelepon: noTelepon,
                      email: email,
                      password: password,
                    );

                    _showSnackBar(context, 'Technician added successfully!');
                    _namaTeknisiController.clear();
                    _nikTeknisiController.clear();
                    _noTeleponController.clear();
                    _emailController.clear();
                    _passwordController.clear();
                  } catch (e) {
                    _showSnackBar(context, 'Failed to add technician: $e', isError: true);
                  }
                },
                child: const Text('Add Technician'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
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
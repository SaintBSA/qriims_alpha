import 'package:flutter/material.dart';
import 'db_helper.dart';

class EditTechnicianPage extends StatefulWidget {
  final Map<String, dynamic> technician;

  const EditTechnicianPage({super.key, required this.technician});

  @override
  State<EditTechnicianPage> createState() => _EditTechnicianPageState();
}

class _EditTechnicianPageState extends State<EditTechnicianPage> {
  final _formKey = GlobalKey<FormState>();
  final DBHelper _dbHelper = DBHelper();

  late TextEditingController _namaController;
  late TextEditingController _nikController;
  late TextEditingController _teleponController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.technician['nama_teknisi']);
    _nikController = TextEditingController(text: widget.technician['nik_teknisi'].toString());
    _teleponController = TextEditingController(text: widget.technician['no_telepon'].toString());
    _emailController = TextEditingController(text: widget.technician['email_teknisi']);
    _passwordController = TextEditingController(text: widget.technician['pw_teknisi']);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _teleponController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _updateTechnician() async {
    if (_formKey.currentState!.validate()) {
      await _dbHelper.updateTechnician(
        id: widget.technician['id_teknisi'],
        nama: _namaController.text,
        nik: int.parse(_nikController.text),
        noTelepon: int.parse(_teleponController.text),
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Technician data updated successfully')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Technician')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Technician Name'),
                validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
              ),
              TextFormField(
                controller: _nikController,
                decoration: const InputDecoration(labelText: 'NIK'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
              ),
              TextFormField(
                controller: _teleponController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // Menggunakan warna utama dari tema
                  backgroundColor: Theme.of(context).primaryColor,
                  // Menggunakan warna teks yang kontras (hitam)
                  foregroundColor: Colors.white,
                  // Membuat tombol lebih lebar dan tinggi
                  minimumSize: const Size(double.infinity, 50),
                  // Menggunakan radius yang sama dengan tema
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: _updateTechnician,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
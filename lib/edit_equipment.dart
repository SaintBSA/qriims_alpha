import 'package:flutter/material.dart';
import 'db_helper.dart';

class EditEquipmentPage extends StatefulWidget {
  final Map<String, dynamic> equipment;

  const EditEquipmentPage({super.key, required this.equipment});

  @override
  State<EditEquipmentPage> createState() => _EditEquipmentPageState();
}

class _EditEquipmentPageState extends State<EditEquipmentPage> {
  final _formKey = GlobalKey<FormState>();
  final DBHelper _dbHelper = DBHelper();

  late TextEditingController _namaController;
  late TextEditingController _merekController;
  late TextEditingController _seriController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.equipment['nama_alat']);
    _merekController = TextEditingController(text: widget.equipment['merek_alat']);
    // --- PERBAIKAN DI SINI ---
    // Mengubah nilai integer menjadi String sebelum dimasukkan ke controller
    _seriController = TextEditingController(text: widget.equipment['seri_alat'].toString());
  }

  @override
  void dispose() {
    _namaController.dispose();
    _merekController.dispose();
    _seriController.dispose();
    super.dispose();
  }

  Future<void> _updateEquipment() async {
    if (_formKey.currentState!.validate()) {
      await _dbHelper.updateEquipment(
        id: widget.equipment['id_alat'],
        namaAlat: _namaController.text,
        merekAlat: _merekController.text,
        seriAlat: _seriController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Equipment data updated successfully')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Equipment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Equipment Name'),
                validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _merekController,
                decoration: const InputDecoration(labelText: 'Brand'),
                validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _seriController,
                decoration: const InputDecoration(labelText: 'Serial Number'),
                validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 24),
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
                onPressed: _updateEquipment,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
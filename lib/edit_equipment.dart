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
          const SnackBar(
            content: Text('Equipment data updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Equipment')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                // --- MENGGUNAKAN hintText UNTUK TAMPILAN MODERN ---

                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(hintText: 'Equipment Name'),
                  validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _merekController,
                  decoration: const InputDecoration(hintText: 'Brand'),
                  validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _seriController,
                  decoration: const InputDecoration(hintText: 'Serial Number'),
                  validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
                ),
                const SizedBox(height: 512),
                // --- TOMBOL SEKARANG OTOMATIS MENGGUNAKAN TEMA BUBBLY ---
                ElevatedButton(
                  onPressed: _updateEquipment,
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
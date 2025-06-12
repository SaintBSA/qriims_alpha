import 'package:flutter/material.dart';
import 'db_helper.dart';

class AddEquipmentForm extends StatefulWidget {
  const AddEquipmentForm({super.key});

  @override
  State<AddEquipmentForm> createState() => _AddEquipmentFormState();
}

class _AddEquipmentFormState extends State<AddEquipmentForm> {
  final _namaAlatController = TextEditingController();
  final _merekAlatController = TextEditingController();
  final _seriAlatController = TextEditingController();

  final DBHelper _dbHelper = DBHelper();

  void _submitForm() async {
    String nama = _namaAlatController.text.trim();
    String merek = _merekAlatController.text.trim();
    String seri = _seriAlatController.text.trim();

    if (nama.isEmpty || merek.isEmpty || seri.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required!'), backgroundColor: Colors.orangeAccent),
      );
      return;
    }
    try {
      await _dbHelper.insertPeralatan(
        namaAlat: nama,
        merekAlat: merek,
        seriAlat: seri,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Equipment added successfully!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add equipment: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Equipment'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaAlatController,
                decoration: const InputDecoration(hintText: 'Equipment Name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _merekAlatController,
                decoration: const InputDecoration(hintText: 'Brand'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _seriAlatController,
                decoration: const InputDecoration(hintText: 'Serial Number'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Add Equipment'),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaAlatController.dispose();
    _merekAlatController.dispose();
    _seriAlatController.dispose();
    super.dispose();
  }
}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Equipment'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              TextField(
                controller: _namaAlatController,
                decoration: const InputDecoration(
                  labelText: 'Equipment Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _merekAlatController,
                decoration: const InputDecoration(
                  labelText: 'Brand',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _seriAlatController,
                decoration: const InputDecoration(
                  labelText: 'Serial Number',
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
                  String nama = _namaAlatController.text.trim();
                  String merek = _merekAlatController.text.trim();
                  String seri = _seriAlatController.text.trim();

                  if (nama.isEmpty || merek.isEmpty || seri.isEmpty) {
                    _showSnackBar(context, 'All fields are required!', isError: true);
                    return;
                  }

                  try {
                    await _dbHelper.insertPeralatan(
                      namaAlat: nama,
                      merekAlat: merek,
                      seriAlat: seri,
                    );

                    _showSnackBar(context, 'Equipment added successfully!');
                    _namaAlatController.clear();
                    _merekAlatController.clear();
                    _seriAlatController.clear();
                  } catch (e) {
                    _showSnackBar(context, 'Failed to add equipment: $e', isError: true);
                  }
                },
                child: const Text('Add Equipment'),

              )
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
    _namaAlatController.dispose();
    _merekAlatController.dispose();
    _seriAlatController.dispose();
    super.dispose();
  }
}
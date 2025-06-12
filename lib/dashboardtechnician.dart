import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'login.dart';

class TechnicianDashboardPage extends StatefulWidget {
  const TechnicianDashboardPage({super.key});

  @override
  State<TechnicianDashboardPage> createState() => _TechnicianDashboardPageState();
}

class _TechnicianDashboardPageState extends State<TechnicianDashboardPage> {
  final DBHelper _dbHelper = DBHelper();
  final _kategoriController = TextEditingController();
  final _deskripsiController = TextEditingController();

  List<Map<String, dynamic>> _peralatanList = [];
  int? _selectedAlatId; // Changed to store the ID

  @override
  void initState() {
    super.initState();
    _loadPeralatan();
  }

  Future<void> _loadPeralatan() async {
    final data = await _dbHelper.getAllPeralatan();
    setState(() {
      _peralatanList = data;
    });
  }

  void _submitForm() async {
    final kategori = _kategoriController.text.trim();
    final deskripsi = _deskripsiController.text.trim();

    if (_selectedAlatId == null || kategori.isEmpty || deskripsi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    try {
      await _dbHelper.insertHistory(
        idAlat: _selectedAlatId!,
        kategori: kategori,
        deskripsi: deskripsi,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data submitted successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Reset form
      setState(() {
        _selectedAlatId = null;
      });
      _kategoriController.clear();
      _deskripsiController.clear();
      FocusScope.of(context).unfocus(); // Dismiss keyboard
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit data: $e")),
      );
    }
  }

  @override
  void dispose() {
    _kategoriController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Technician Input'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                value: _selectedAlatId,
                decoration: const InputDecoration(
                  labelText: 'Select Equipment',
                  border: OutlineInputBorder(),
                ),
                items: _peralatanList.map((alat) {
                  return DropdownMenuItem<int>(
                    value: alat['id_alat'],
                    child: Text(alat['nama_alat']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAlatId = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _kategoriController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _deskripsiController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
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
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
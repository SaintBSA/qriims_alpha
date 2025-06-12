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
  int? _selectedAlatId;

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
        const SnackBar(
          content: Text("Please fill in all fields"),
          backgroundColor: Colors.orangeAccent,
        ),
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
        _kategoriController.clear();
        _deskripsiController.clear();
      });
      FocusScope.of(context).unfocus(); // Dismiss keyboard
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to submit data: $e"),
          backgroundColor: Colors.redAccent,
        ),
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
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedAlatId,
                decoration: const InputDecoration(
                  hintText: 'Select Equipment',
                ),
                icon: const Icon(Icons.arrow_drop_down_rounded, color: kMutedTextColor),
                dropdownColor: kSurfaceColor,
                items: _peralatanList.map((alat) {
                  return DropdownMenuItem<int>(
                    value: alat['id_alat'],
                    child: Text(
                      alat['nama_alat'],
                      style: const TextStyle(color: kTextColor, fontWeight: FontWeight.w500),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAlatId = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kategoriController,
                decoration: const InputDecoration(
                  hintText: 'Category (e.g., Maintenance, Repair)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deskripsiController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Description of work done...',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit Report'),
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
        backgroundColor: kSurfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Logout', style: TextStyle(fontWeight: FontWeight.w600)),
        content: const Text('Are you sure you want to log out?', style: TextStyle(color: kMutedTextColor)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: kMutedTextColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text('Logout', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
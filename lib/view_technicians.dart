import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'edit_technician.dart';
import 'login.dart'; // Impor untuk mengakses warna tema

class ViewTechniciansPage extends StatefulWidget {
  const ViewTechniciansPage({super.key});

  @override
  State<ViewTechniciansPage> createState() => _ViewTechniciansPageState();
}

class _ViewTechniciansPageState extends State<ViewTechniciansPage> {
  final DBHelper _dbHelper = DBHelper();
  late Future<List<Map<String, dynamic>>> _techniciansFuture;

  @override
  void initState() {
    super.initState();
    _loadTechnicians();
  }

  void _loadTechnicians() {
    setState(() {
      _techniciansFuture = _dbHelper.getAllTechnicians();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Technician List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _techniciansFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No technicians found.'));
          } else {
            final technicians = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: technicians.length,
              itemBuilder: (context, index) {
                final tech = technicians[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: kPrimaryColor,
                          child: Icon(Icons.person_outline, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tech['nama_teknisi'] ?? 'No Name',
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text('Email: ${tech['email_teknisi']}', style: const TextStyle(color: kMutedTextColor)),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: kMutedTextColor),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditTechnicianPage(technician: tech),
                                  ),
                                );
                                _loadTechnicians();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () async {
                                // Dialog konfirmasi tetap sama
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

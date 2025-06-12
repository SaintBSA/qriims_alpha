import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'edit_technician.dart';

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
              itemCount: technicians.length,
              itemBuilder: (context, index) {
                final tech = technicians[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(tech['nama_teknisi'] ?? 'No Name'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NIK: ${tech['nik_teknisi']}'),
                        Text('Phone: ${tech['no_telepon']}'),
                        Text('Email: ${tech['email_teknisi']}'),
                        const Text('Password: ********'), // Password hidden
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.deepPurple),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditTechnicianPage(technician: tech),
                              ),
                            );
                            _loadTechnicians(); // Refresh list after edit
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm'),
                                content: Text('Delete technician "${tech['nama_teknisi']}"?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                  TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await _dbHelper.deleteTechnicianById(tech['id_teknisi']);
                              _loadTechnicians(); // Refresh list after delete
                            }
                          },
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
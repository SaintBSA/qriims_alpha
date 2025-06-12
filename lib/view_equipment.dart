import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'edit_equipment.dart'; // Impor halaman edit yang baru dibuat

class ViewPeralatanPage extends StatefulWidget {
  const ViewPeralatanPage({super.key});

  @override
  State<ViewPeralatanPage> createState() => _ViewPeralatanPageState();
}

class _ViewPeralatanPageState extends State<ViewPeralatanPage> {
  final DBHelper _dbHelper = DBHelper();
  late Future<List<Map<String, dynamic>>> _peralatanFuture;

  @override
  void initState() {
    super.initState();
    _loadPeralatan();
  }

  // Fungsi untuk memuat ulang data dari database
  void _loadPeralatan() {
    setState(() {
      _peralatanFuture = _dbHelper.getAllPeralatan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipment List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _peralatanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No equipment found.'));
          } else {
            final peralatanList = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: peralatanList.length,
              itemBuilder: (context, index) {
                final alat = peralatanList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    // ADD THIS LINE TO ADJUST THE PADDING
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),

                    title: Text(alat['nama_alat'] ?? 'No Name'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4), // You can also add space between text lines
                        Text('Brand: ${alat['merek_alat']}'),
                        Text('Serial No: ${alat['seri_alat']}'),
                      ],
                    ),
                    // Menambahkan tombol edit dan delete
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                          onPressed: () async {
                            // Navigasi ke halaman edit
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditEquipmentPage(equipment: alat),
                              ),
                            );
                            // Muat ulang daftar setelah kembali dari halaman edit
                            _loadPeralatan();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            // Tampilkan dialog konfirmasi
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm Deletion'),
                                content: Text('Are you sure you want to delete "${alat['nama_alat']}"?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              // Hapus item dari database
                              await _dbHelper.deleteEquipmentById(alat['id_alat']);
                              // Muat ulang daftar setelah menghapus
                              _loadPeralatan();
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
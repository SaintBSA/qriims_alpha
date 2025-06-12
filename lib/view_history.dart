// lib/view_history.dart

import 'package:flutter/material.dart';
import 'db_helper.dart'; // Pastikan path ini benar

class ViewHistoryPage extends StatefulWidget {
  const ViewHistoryPage({super.key});

  @override
  State<ViewHistoryPage> createState() => _ViewHistoryPageState();
}

class _ViewHistoryPageState extends State<ViewHistoryPage> {
  final DBHelper _dbHelper = DBHelper();
  late Future<List<Map<String, dynamic>>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _dbHelper.getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Technician Input History'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No history found.'));
          } else {
            final historyList = snapshot.data!;
            return ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final item = historyList[index];
                // Format tanggal agar lebih mudah dibaca
                final DateTime recordDate = DateTime.parse(item['tanggal_input']);
                final String formattedDate =
                    "${recordDate.day}/${recordDate.month}/${recordDate.year} ${recordDate.hour}:${recordDate.minute.toString().padLeft(2, '0')}";

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['nama_alat'] ?? 'Unknown Equipment',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Brand: ${item['merek_alat'] ?? 'N/A'}'),
                        const SizedBox(height: 8),
                        Text(
                          'Category: ${item['kategori']}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text('Description: ${item['deskripsi']}'),
                        const Divider(height: 20),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'Input Date: $formattedDate',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
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
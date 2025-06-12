import 'package:flutter/material.dart';
import 'login.dart';
import 'view_technicians.dart';
import 'add_technician.dart';
import 'add_equipment.dart';
import 'view_equipment.dart';
import 'view_history.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 32),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Admin',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: <Widget>[
                  _buildDashboardButton(context, 'Add Machine', Icons.add_circle_outline, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddEquipmentForm()),
                    );
                  }),
                  _buildDashboardButton(context, 'Add Technician', Icons.person_add_outlined, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddTechnicianForm()),
                    );
                  }),
                  _buildDashboardButton(context, 'View Machines', Icons.devices_outlined, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ViewPeralatanPage()),
                    );
                  }),
                  _buildDashboardButton(context, 'View Technicians', Icons.people_outline, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ViewTechniciansPage()),
                    );
                  }),
                  _buildDashboardButton(context, 'Technician Input History', Icons.history_outlined, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ViewHistoryPage()),
                    );
                  }),
                  _buildDashboardButton(context, 'Log Out', Icons.logout, () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton(BuildContext context, String title, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black87,
        elevation: 2,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 30,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotImplementedDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Not Implemented'),
          content: Text('The "$title" functionality is not yet implemented.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
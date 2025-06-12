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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              const Text('Welcome Back, Admin!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Main Dashboard', style: TextStyle(fontSize: 16, color: kMutedTextColor)),
              const SizedBox(height: 60),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: <Widget>[
                    _DashboardButton(
                      title: 'Add Machine',
                      icon: Icons.add_to_queue_rounded,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEquipmentForm())),
                    ),
                    _DashboardButton(
                      title: 'Add Technician',
                      icon: Icons.person_add_alt_1_rounded,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTechnicianForm())),
                    ),
                    _DashboardButton(
                      title: 'View Machines',
                      icon: Icons.devices_other_rounded,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ViewPeralatanPage())),
                    ),
                    _DashboardButton(
                      title: 'View Technicians',
                      icon: Icons.people_alt_rounded,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ViewTechniciansPage())),
                    ),
                    _DashboardButton(
                      title: 'Input History',
                      icon: Icons.history_rounded,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ViewHistoryPage())),
                    ),
                    _DashboardButton(
                      title: 'Log Out',
                      icon: Icons.logout_rounded,
                      onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage())),
                      isLogout: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom widget untuk tombol dashboard yang lebih bubbly
class _DashboardButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isLogout;

  const _DashboardButton({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  State<_DashboardButton> createState() => _DashboardButtonState();
}

class _DashboardButtonState extends State<_DashboardButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isLogout ? Colors.red.shade400 : Theme.of(context).primaryColor;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Card(
          color: widget.isLogout ? Colors.red.withOpacity(0.1) : kSurfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: widget.isLogout ? BorderSide(color: color, width: 1) : BorderSide.none,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


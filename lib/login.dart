import 'package:flutter/material.dart';
import 'dashboardadmin.dart';
import 'dashboardtechnician.dart';
import 'db_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        // Mengubah warna utama aplikasi menjadi ungu agar konsisten
        primarySwatch: Colors.deepPurple,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              // --- PERUBAHAN DI SINI ---
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // 1. Warna tombol menjadi ungu
                    minimumSize: const Size(double.infinity, 50), // 2. Lebar penuh dan tinggi 50
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50) // Sedikit membulatkan sudut agar lebih bagus
                    )
                ),
                onPressed: () async {
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();

                  if (email == 'admin@gmail.com' && password == 'admin') {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const DashboardPage()),
                    );
                  } else {
                    DBHelper dbHelper = DBHelper();
                    bool success = await dbHelper.login(email, password);

                    if (success) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const TechnicianDashboardPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Incorrect email or password')),
                      );
                    }
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 16, color: Colors.white), // Mengubah warna teks menjadi putih
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
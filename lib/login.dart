import 'package:flutter/material.dart';
import 'dashboardadmin.dart';
import 'dashboardtechnician.dart';
import 'db_helper.dart';

// --- PALET WARNA MINIMALIS ---
const Color kPrimaryColor = Color(0xFF6A5AE0); // Ungu yang lebih vibrant
const Color kBackgroundColor = Color(0xFF1C1C2D);
const Color kSurfaceColor = Color(0xFF26263A);
const Color kTextColor = Colors.white;
const Color kMutedTextColor = Color(0xFF9E9EAD);
// -----------------------------

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QRIIMS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // --- TEMA UTAMA MODERN ---
        brightness: Brightness.dark,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: kBackgroundColor,
        primaryColor: kPrimaryColor,

        colorScheme: const ColorScheme.dark(
          primary: kPrimaryColor,
          secondary: kPrimaryColor,
          background: kBackgroundColor,
          surface: kSurfaceColor,
          onBackground: kTextColor,
          onSurface: kTextColor,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600, color: kTextColor),
          iconTheme: IconThemeData(color: kTextColor),
        ),

        // --- GAYA INPUT BUBBLY ---
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kSurfaceColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: kMutedTextColor, fontSize: 15),
          labelStyle: const TextStyle(color: kMutedTextColor),
        ),

        // --- GAYA TOMBOL BUBBLY ---
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            elevation: 5,
            shadowColor: kPrimaryColor.withOpacity(0.4),
          ),
        ),

        cardTheme: CardTheme(
          color: kSurfaceColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
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

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 70),
                    // --- TEXT BARU DITAMBAHKAN DI SINI ---
                    const Text(
                      'QRIIMS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 100),
                    Icon(Icons.shield_moon, color: kPrimaryColor, size: 60),
                    const SizedBox(height: 20),
                    const Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: kTextColor),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter your credentials',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: kMutedTextColor),
                    ),
                    const SizedBox(height: 45),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'Email'),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(hintText: 'Password'),
                    ),
                    const SizedBox(height: 45),
                    ElevatedButton(
                      child: const Text('Login'),
                      onPressed: () async {
                        // Login logic remains the same
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
                              const SnackBar(
                                content: Text('Incorrect email or password'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
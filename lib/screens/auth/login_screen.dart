import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() { _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  void _login() => Navigator.pushReplacementNamed(context, '/home');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: SingleChildScrollView(
        child: Column(children: [
          // Green header
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
                24, MediaQuery.of(context).padding.top + 48, 24, 48),
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Column(children: [
              Image.network(
                'https://res.cloudinary.com/dbp2s9lc0/image/upload/v1786664816/Plantify_kgpn7b.png',
                width: 130,
                errorBuilder: (_, __, ___) => const Text('Plantify',
                    style: TextStyle(color: Colors.white, fontSize: 32,
                        fontWeight: FontWeight.bold, letterSpacing: 4)),
              ),
              const SizedBox(height: 8),
              // Updated: exclamation mark added
              const Text('Your Green World!',
                  style: TextStyle(color: Colors.white60, fontSize: 13,
                      letterSpacing: 1.5)),
            ]),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 8),
              const Text('Welcome back',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
                      color: AppColors.textDark)),
              const SizedBox(height: 4),
              const Text('Sign in to continue',
                  style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
              const SizedBox(height: 28),

              _label('Email'),
              _field(_emailCtrl, 'Enter your email', Icons.email_outlined),
              const SizedBox(height: 16),

              _label('Password'),
              _field(_passCtrl, 'Enter your password', Icons.lock_outline,
                  obscure: _obscure,
                  suffix: IconButton(
                    icon: Icon(
                        _obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20, color: AppColors.textGrey),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )),
              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/forgot'),
                  child: const Text('Forgot Password?',
                      style: TextStyle(color: AppColors.primaryMed,
                          fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Login',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),

              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Don't have an account? ",
                    style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/register'),
                  child: const Text('Register',
                      style: TextStyle(color: AppColors.primaryMed,
                          fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _label(String t) => Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(t,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
              color: AppColors.textDark)));

  Widget _field(TextEditingController ctrl, String hint, IconData icon,
      {bool obscure = false, Widget? suffix}) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider)),
      child: TextField(
        controller: ctrl, obscureText: obscure,
        style: const TextStyle(fontSize: 13, color: AppColors.textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 13),
          prefixIcon: Icon(icon, size: 20, color: AppColors.textGrey),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

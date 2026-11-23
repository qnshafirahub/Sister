import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/auth_service.dart';
import '../core/app_colors.dart';
import 'main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _user = TextEditingController();
  final _pass = TextEditingController();
  bool _hide = true;
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    if (_user.text.trim().isEmpty || _pass.text.isEmpty) {
      setState(() => _error = 'NIS/Username dan Password wajib diisi');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthService.instance.login(_user.text.trim(), _pass.text);
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const MainShell()));
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _user.dispose();
    _pass.dispose();
    super.dispose();
  }

  InputDecoration _dec(String hint, {Widget? suffix}) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF928F8F), fontSize: 15),
        filled: true,
        fillColor: AppColors.cream,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        suffixIcon: suffix,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFCBEAC7), Colors.white]),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [
              const SizedBox(height: 70),
              Text('SISTER SKANSIKA',
                  style: GoogleFonts.poppins(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: AppColors.greenTitle)),
              Image.asset('assets/sister.png', width: 278, height: 277),
              Container(
                padding: const EdgeInsets.fromLTRB(27, 40, 27, 30),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: Column(children: [
                  TextField(
                      controller: _user,
                      decoration: _dec('Masukan NIS atau Username')),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _pass,
                    obscureText: _hide,
                    decoration: _dec('Masukan Password',
                        suffix: IconButton(
                          icon: Icon(
                              _hide ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _hide = !_hide),
                        )),
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(_error!,
                          style: const TextStyle(
                              color: Color(0xFFAB0101), fontSize: 12)),
                    ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 39,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _login,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green,
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder()),
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Text('LOGIN',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
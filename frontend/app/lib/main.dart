import 'dart:async';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const YakAlimiApp());
}

// ======================= 앱 전체 =======================
class YakAlimiApp extends StatelessWidget {
  const YakAlimiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.teal.shade50,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '약 알리미',
      theme: lightTheme,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignUpPage(),
      },
    );
  }
}

// ======================= 가짜 Auth =======================
class FakeAuth {
  static String? _userId;
  static String? _password;
  static String? currentUserName;

  static String? get userId => _userId;

  static void register({
    required String name,
    required String userId,
    required String password,
  }) {
    currentUserName = name;
    _userId = userId;
    _password = password;
  }

  static bool canLogin({
    required String userId,
    required String password,
  }) {
    if (_userId == null || _password == null) return false;
    return _userId == userId && _password == password;
  }

  static bool get isRegistered => _userId != null && _password != null;

  static void logout() {
    _userId = null;
    _password = null;
    currentUserName = null;
  }
}

// ======================= 스플래시 =======================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.medication,
              size: 80,
              color: Colors.teal,
            ),
            SizedBox(height: 16),
            Text(
              '약 알리미',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(color: Colors.teal),
          ],
        ),
      ),
    );
  }
}

// ======================= 로그인 =======================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  void _login() {
    final id = _idController.text.trim();
    final pw = _pwController.text.trim();

    if (id.isEmpty || pw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이디와 비밀번호를 모두 입력해 주세요.')),
      );
      return;
    }

    if (!FakeAuth.isRegistered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('등록된 계정이 없습니다. 먼저 회원가입을 진행해 주세요.')),
      );
      return;
    }

    final ok = FakeAuth.canLogin(userId: id, password: pw);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이디 또는 비밀번호가 올바르지 않습니다.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('로그인에 성공했습니다.')),
    );
  }

  void _goToSignUp() {
    Navigator.pushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              const Text(
                '로그인',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '아이디와 비밀번호로 로그인합니다.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: '아이디',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _pwController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _login,
                  child: const Text('로그인'),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: _goToSignUp,
                  child: const Text('아직 회원이 아니신가요? 회원가입'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================= 회원가입 =======================
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  void _signUp() {
    final name = _nameController.text.trim();
    final id = _idController.text.trim();
    final pw = _pwController.text.trim();

    if (name.isEmpty || id.isEmpty || pw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이름, 아이디, 비밀번호를 모두 입력해 주세요.')),
      );
      return;
    }

    FakeAuth.register(name: name, userId: id, password: pw);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('회원가입이 완료되었습니다. 로그인 화면으로 돌아갑니다.')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: const Text('회원가입'),
        backgroundColor: Colors.teal.shade50,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '이름',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: '아이디',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _pwController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _signUp,
                  child: const Text('회원가입 완료'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io'; // 사진 미리보기용 (모바일에서 사용)
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // 사진 촬영/선택용
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(const MyApp());
}

/// 앱 루트 위젯
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '시니어 복약 관리',
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'AI 기반 스마트 복약 관리\n더 쉽고 정확하게',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 60),

            // 시작하기 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF4F46E5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("시작하기"),
              ),
            ),

            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text(
                "이미 계정이 있나요?",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
로그인 화면
*/
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite, size: 60, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              '시니어 복약 관리',
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            TextField(
              decoration: InputDecoration(
                hintText: '이메일',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: '비밀번호',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 로그인 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainScaffold()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF4F46E5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("로그인"),
              ),
            ),

            const SizedBox(height: 16),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                );
              },
              child: const Text(
                "회원가입",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
회원가입 화면
*/

// 1) 화면 위젯 선언
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // 컨트롤러
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _passwordConfirm = TextEditingController();

  bool agreeAll = false;
  bool agree1 = false;
  bool agree2 = false;
  bool agree3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text("회원가입"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1/2 단계 표시 (Figma 스타일)
            Text(
              "1/2 단계",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 16),

            // ----------- 개인 정보 --------------
            Text(
              "개인 정보",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: "이름 *"),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _email,
              decoration: const InputDecoration(
                labelText: "이메일 *",
                hintText: "example@email.com",
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _phone,
              decoration: const InputDecoration(
                labelText: "전화번호 *",
                hintText: "010-0000-0000",
              ),
            ),
            const SizedBox(height: 24),

            // ----------- 계정 정보 --------------
            Text(
              "계정 정보",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: "비밀번호 *"),
            ),
            const SizedBox(height: 4),
            Text(
              "8자 이상, 영문/숫자/특수문자 포함",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _passwordConfirm,
              obscureText: true,
              decoration: const InputDecoration(labelText: "비밀번호 확인 *"),
            ),
            const SizedBox(height: 24),

            // ----------- 체크박스 --------------
            Row(
              children: [
                Checkbox(
                  value: agreeAll,
                  onChanged: (v) {
                    setState(() {
                      agreeAll = v!;
                      agree1 = v;
                      agree2 = v;
                      agree3 = v;
                    });
                  },
                ),
                const Text("전체 동의"),
              ],
            ),

            Row(
              children: [
                Checkbox(
                  value: agree1,
                  onChanged: (v) {
                    setState(() {
                      agree1 = v!;
                    });
                  },
                ),
                const Text("[필수] 이용약관 동의"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: agree2,
                  onChanged: (v) {
                    setState(() {
                      agree2 = v!;
                    });
                  },
                ),
                const Text("[필수] 개인정보 처리방침"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: agree3,
                  onChanged: (v) {
                    setState(() {
                      agree3 = v!;
                    });
                  },
                ),
                const Text("[선택] 마케팅 정보 수신"),
              ],
            ),

            const SizedBox(height: 24),

            // 다음 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 필수 입력 체크
                  if (_password.text != _passwordConfirm.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("비밀번호가 일치하지 않습니다.")),
                    );
                    return;
                  }

                  if (!agree1 || !agree2) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("필수 약관을 모두 체크하세요.")),
                    );
                    return;
                  }

                  // TODO: 2단계 화면으로 이동
                },
                child: const Text("다음"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 앱 루트 위젯
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '복약 관리',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(), // ← 여기만 바꾸면 됨!!
    );
  }
}

/// 하단 탭 + 상단 앱바를 관리하는 메인 스캐폴드
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final _titles = const ['복약 관리', '캘린더', '리포트', '내 정보'];

  late final List<Widget> _screens = const [
    HomeScreen(),
    CalendarScreen(),
    ReportsScreen(),
    ProfileScreen(),
  ];

  void _onTabTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex]), centerTitle: true),
      body: IndexedStack(
        // 탭 전환 시 상태 유지용
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTap,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '캘린더',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: '리포트'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 정보'),
        ],
      ),
    );
  }
}

/* ────────────────────────────
   데이터 모델 (더미)
   ──────────────────────────── */

class Senior {
  final String id;
  final String name;
  final String emoji;
  final int age;
  final String birth;
  final String guardianName;
  final String guardianPhone;

  const Senior({
    required this.id,
    required this.name,
    required this.emoji,
    required this.age,
    required this.birth,
    required this.guardianName,
    required this.guardianPhone,
  });
}

class Medicine {
  final String name;
  final String emoji;
  final List<String> times; // ["MORNING", "LUNCH", "DINNER"]

  const Medicine({
    required this.name,
    required this.emoji,
    required this.times,
  });
}

/// 복약 상태 enum (UI 표시용)
enum IntakeStatus { none, taken, missed, late }

/* ────────────────────────────
   시니어 상세 시트
   (DraggableScrollableSheet + 사진 촬영 + 복약 관리 + 약 정보)
   ──────────────────────────── */

/* ────────────────────────────
   홈 탭 (최신 완성본)
   ──────────────────────────── */

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 시니어 목록
  final List<Senior> _seniors = const [
    Senior(
      id: 's1',
      name: '김철수',
      emoji: '🧓',
      age: 79,
      birth: '1946.02.13',
      guardianName: '아들 김민수',
      guardianPhone: '010-1234-5678',
    ),
    Senior(
      id: 's2',
      name: '박영희',
      emoji: '👵',
      age: 83,
      birth: '1942.06.01',
      guardianName: '딸 이지은',
      guardianPhone: '010-2222-3333',
    ),
  ];

  // 더미 약 목록 (약정보 상세보기용)
  final List<Medicine> _medicines = const [
    Medicine(
      name: '고혈압약 A',
      emoji: '💊',
      times: ['MORNING', 'LUNCH', 'DINNER'],
    ),
    Medicine(name: '콜레스테롤약 B', emoji: '💊', times: ['DINNER']),
    Medicine(name: '종합비타민 C', emoji: '💊', times: ['MORNING']),
  ];

  // 시니어별 복약 상태 (아침/점심/저녁)
  final Map<String, Map<String, IntakeStatus>> _intakeStatus = {};

  @override
  void initState() {
    super.initState();
    // 기본값: 기록 없음
    for (final s in _seniors) {
      _intakeStatus[s.id] = {
        'morning': IntakeStatus.none,
        'lunch': IntakeStatus.none,
        'dinner': IntakeStatus.none,
      };
    }
  }

  // 완료된 시니어 수 (아침/점심/저녁 모두 완료)
  int _countDone() {
    int done = 0;
    for (final s in _seniors) {
      final st = _intakeStatus[s.id]!;
      if (st['morning'] == IntakeStatus.taken &&
          st['lunch'] == IntakeStatus.taken &&
          st['dinner'] == IntakeStatus.taken) {
        done++;
      }
    }
    return done;
  }

  // 상단 카드 아이콘 (X / △ / ✔)
  Icon _buildStatusIcon() {
    final done = _countDone();
    final total = _seniors.length;

    if (done == 0) {
      return const Icon(Icons.close, color: Colors.red, size: 40); // X
    } else if (done < total) {
      return const Icon(
        Icons.change_history,
        color: Colors.orange,
        size: 40,
      ); // △
    } else {
      return const Icon(Icons.check_circle, color: Colors.blue, size: 40); // ✔
    }
  }

  // 상태 칩
  Widget _statusChip(IntakeStatus status) {
    late Color color;
    late String text;

    switch (status) {
      case IntakeStatus.taken:
        color = Colors.green;
        text = '완료';
        break;
      case IntakeStatus.late:
        color = Colors.orange;
        text = '지각';
        break;
      case IntakeStatus.missed:
        color = Colors.red;
        text = '미복용';
        break;
      case IntakeStatus.none:
      default:
        color = Colors.grey;
        text = '기록 없음';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  // 시니어 추가 시트 열기 (지금은 UI만, 저장 로직은 TODO)
  void _openAddSenior() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddSeniorSheet(),
    );
  }

  // 시니어 상세 시트 열기
  Future<void> _openSeniorDetail(Senior senior) async {
    final result = await showModalBottomSheet<Map<String, IntakeStatus>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SeniorDetailSheet(
        senior: senior,
        initialStatus: _intakeStatus[senior.id]!,
        medicines: _medicines,
      ),
    );

    if (result != null) {
      setState(() {
        _intakeStatus[senior.id] = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final doneCount = _countDone();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '안녕하세요 👋',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            const Text(
              '김간병 님',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 상단 요약 카드
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFE7EBFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '오늘의 복약 현황',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '완료 $doneCount/${_seniors.length}명',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _buildStatusIcon(),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              '관리 중인 시니어',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 시니어 카드 리스트
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _seniors.length,
              itemBuilder: (context, index) {
                final senior = _seniors[index];
                final status = _intakeStatus[senior.id]!;

                return GestureDetector(
                  onTap: () => _openSeniorDetail(senior),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 6),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          senior.emoji,
                          style: const TextStyle(fontSize: 40),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${senior.name} (${senior.age}세)',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '보호자: ${senior.guardianName}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            _statusChip(status['morning']!),
                            const SizedBox(height: 4),
                            _statusChip(status['lunch']!),
                            const SizedBox(height: 4),
                            _statusChip(status['dinner']!),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _openAddSenior,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                child: const Text('＋ 새 시니어 추가', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ────────────────────────────
   시니어 상세 시트 (사진 + 약정보 + 복약 상태 연동)
   ──────────────────────────── */

class SeniorDetailSheet extends StatefulWidget {
  final Senior senior;
  final Map<String, IntakeStatus> initialStatus;
  final List<Medicine> medicines;

  const SeniorDetailSheet({
    super.key,
    required this.senior,
    required this.initialStatus,
    required this.medicines,
  });

  @override
  State<SeniorDetailSheet> createState() => _SeniorDetailSheetState();
}

class _SeniorDetailSheetState extends State<SeniorDetailSheet> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  late IntakeStatus morningStatus;
  late IntakeStatus lunchStatus;
  late IntakeStatus dinnerStatus;

  @override
  void initState() {
    super.initState();
    morningStatus = widget.initialStatus['morning'] ?? IntakeStatus.none;
    lunchStatus = widget.initialStatus['lunch'] ?? IntakeStatus.none;
    dinnerStatus = widget.initialStatus['dinner'] ?? IntakeStatus.none;
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _pickedImage = image);
    }
  }

  // 상태 선택 시트
  Future<void> _selectStatus(
    String label,
    IntakeStatus current,
    void Function(IntakeStatus) onSelected,
  ) async {
    await showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text(
              '$label 상태 선택',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            RadioListTile<IntakeStatus>(
              title: const Text('기록 없음'),
              value: IntakeStatus.none,
              groupValue: current,
              onChanged: (v) {
                if (v == null) return;
                onSelected(v);
                Navigator.pop(context);
                setState(() {});
              },
            ),
            RadioListTile<IntakeStatus>(
              title: const Text('복용 완료'),
              value: IntakeStatus.taken,
              groupValue: current,
              onChanged: (v) {
                if (v == null) return;
                onSelected(v);
                Navigator.pop(context);
                setState(() {});
              },
            ),
            RadioListTile<IntakeStatus>(
              title: const Text('미복용'),
              value: IntakeStatus.missed,
              groupValue: current,
              onChanged: (v) {
                if (v == null) return;
                onSelected(v);
                Navigator.pop(context);
                setState(() {});
              },
            ),
            RadioListTile<IntakeStatus>(
              title: const Text('지각 복용'),
              value: IntakeStatus.late,
              groupValue: current,
              onChanged: (v) {
                if (v == null) return;
                onSelected(v);
                Navigator.pop(context);
                setState(() {});
              },
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  (Color, String) _statusStyle(IntakeStatus status) {
    switch (status) {
      case IntakeStatus.taken:
        return (Colors.green, '완료');
      case IntakeStatus.late:
        return (Colors.orange, '지각');
      case IntakeStatus.missed:
        return (Colors.red, '미복용');
      case IntakeStatus.none:
      default:
        return (Colors.grey, '기록 없음');
    }
  }

  Widget _buildIntakeCard({
    required String label,
    required String icon,
    required IntakeStatus status,
    required VoidCallback onTap,
  }) {
    final (color, text) = _statusStyle(status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$icon $label', style: const TextStyle(fontSize: 16)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(text, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // 약 리스트 BottomSheet
  void _showMedicineList() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, controller) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.senior.name} 님의 복용 약',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: widget.medicines.length,
                      itemBuilder: (context, index) {
                        final med = widget.medicines[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: Text(
                              med.emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                            title: Text(med.name),
                            subtitle: Text('복용 시간: ${med.times.join(', ')}'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _showMedicineDetail(med),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showMedicineDetail(Medicine med) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(med.emoji, style: const TextStyle(fontSize: 40)),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    med.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  '효능/효과',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text('여기에 효능/효과 설명이 들어갑니다. (더미)'),
                const SizedBox(height: 10),
                const Text(
                  '복용 방법',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text('하루 1~3회, 식후 또는 의사 지시에 따라 복용.'),
                const SizedBox(height: 10),
                const Text(
                  '부작용',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text('어지러움, 두통 등이 나타날 수 있습니다.'),
                const SizedBox(height: 10),
                const Text(
                  '주의사항',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text('다른 약과 병용 시 의사와 상의하세요.'),
                const SizedBox(height: 10),
                const Text(
                  '보관 방법',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text('습기와 직사광선을 피하고 서늘한 곳에 보관.'),
                const SizedBox(height: 10),
                const Text(
                  '제조사',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text('OO제약 주식회사'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomAction({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.black87),
      label: Text(label, style: const TextStyle(color: Colors.black87)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (kIsWeb) {
      return const Text('사진이 선택되었습니다 (웹 미리보기 생략).');
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 120,
        child: Image.file(File(_pickedImage!.path), fit: BoxFit.cover),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        color: Colors.black54,
        child: GestureDetector(
          onTap: () {},
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.45,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 8,
                      bottom: 16 + MediaQuery.of(context).padding.bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Text(
                          widget.senior.emoji,
                          style: const TextStyle(fontSize: 48),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${widget.senior.name} (${widget.senior.age}세)',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('생년월일: ${widget.senior.birth}'),
                        Text(
                          '${widget.senior.guardianName} '
                          '(${widget.senior.guardianPhone})',
                        ),
                        const SizedBox(height: 18),

                        // 약 봉투 촬영
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.blue.withOpacity(0.05),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  '📷  약 봉투 사진 촬영',
                                  style: TextStyle(fontSize: 16),
                                ),
                                if (_pickedImage != null) ...[
                                  const SizedBox(height: 12),
                                  _buildImagePreview(),
                                ],
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        _buildIntakeCard(
                          label: '아침 복약',
                          icon: '🌅',
                          status: morningStatus,
                          onTap: () => _selectStatus(
                            '아침 복약',
                            morningStatus,
                            (v) => morningStatus = v,
                          ),
                        ),
                        _buildIntakeCard(
                          label: '점심 복약',
                          icon: '☀️',
                          status: lunchStatus,
                          onTap: () => _selectStatus(
                            '점심 복약',
                            lunchStatus,
                            (v) => lunchStatus = v,
                          ),
                        ),
                        _buildIntakeCard(
                          label: '저녁 복약',
                          icon: '🌙',
                          status: dinnerStatus,
                          onTap: () => _selectStatus(
                            '저녁 복약',
                            dinnerStatus,
                            (v) => dinnerStatus = v,
                          ),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _showMedicineList,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: const Text('약정보 상세보기'),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildBottomAction(
                              label: '수정',
                              icon: Icons.edit,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('TODO: 시니어 수정 화면'),
                                  ),
                                );
                              },
                            ),
                            _buildBottomAction(
                              label: '삭제',
                              icon: Icons.delete,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('TODO: 시니어 삭제 로직'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // 👉 여기서 HomeScreen으로 복약 상태 전달
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, {
                                'morning': morningStatus,
                                'lunch': lunchStatus,
                                'dinner': dinnerStatus,
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: const Text('저장 후 닫기'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class AddSeniorSheet extends StatefulWidget {
  const AddSeniorSheet({super.key});

  @override
  State<AddSeniorSheet> createState() => _AddSeniorSheetState();
}

class _AddSeniorSheetState extends State<AddSeniorSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthController = TextEditingController();
  final _phoneController = TextEditingController();

  final _guardianNameController = TextEditingController();
  final _guardianPhoneController = TextEditingController();

  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _pickedImage = file);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("시니어 정보가 임시 저장되었습니다.")));
    Navigator.pop(context); // 시트 닫기
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // 드래그 핸들
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _pickedImage != null
                          ? FileImage(File(_pickedImage!.path))
                          : null,
                      child: _pickedImage == null
                          ? const Icon(Icons.camera_alt, size: 35)
                          : null,
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "시니어 이름"),
                    validator: (v) => v == null || v.isEmpty ? "필수 입력" : null,
                  ),
                  TextFormField(
                    controller: _birthController,
                    decoration: const InputDecoration(labelText: "생년월일"),
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: "전화번호"),
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _guardianNameController,
                    decoration: const InputDecoration(labelText: "보호자 이름"),
                  ),
                  TextFormField(
                    controller: _guardianPhoneController,
                    decoration: const InputDecoration(labelText: "보호자 전화번호"),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text("저장"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/* ────────────────────────────
   캘린더 탭 (더미)
   ──────────────────────────── */

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // 시니어 더미 데이터
  final List<Map<String, dynamic>> seniors = [
    {
      "name": "김영희",
      "emoji": "👵",
      "age": 89,
      "intake": {"morning": "taken", "lunch": "late", "dinner": "missed"},
    },
    {
      "name": "이만수",
      "emoji": "👴",
      "age": 76,
      "intake": {"morning": "taken", "lunch": "taken", "dinner": "taken"},
    },
    {
      "name": "박철수",
      "emoji": "🧓",
      "age": 82,
      "intake": {"morning": "none", "lunch": "taken", "dinner": "none"},
    },
  ];

  Color statusColor(String status) {
    switch (status) {
      case "taken":
        return Colors.green;
      case "late":
        return Colors.orange;
      case "missed":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String statusLabel(String status) {
    switch (status) {
      case "taken":
        return "완료";
      case "late":
        return "지각";
      case "missed":
        return "미복용";
      default:
        return "없음";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 달력 영역
        TableCalendar(
          focusedDay: _focusedDay,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          calendarFormat: CalendarFormat.month,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selected, focused) {
            setState(() {
              _selectedDay = selected;
              _focusedDay = focused;
            });
          },
        ),

        const SizedBox(height: 10),

        // 선택된 날짜 표시
        Text(
          "${_selectedDay.year}-${_selectedDay.month}-${_selectedDay.day} 복약 상태",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        Expanded(
          child: ListView.builder(
            itemCount: seniors.length,
            itemBuilder: (context, index) {
              final senior = seniors[index];
              final intake = senior["intake"];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ExpansionTile(
                  leading: Text(
                    senior["emoji"],
                    style: const TextStyle(fontSize: 30),
                  ),
                  title: Text("${senior["name"]} (${senior["age"]}세)"),
                  subtitle: Text("아침/점심/저녁 복약 상태"),

                  // 펼치면 아침/점심/저녁 기록 3줄 표시
                  children: [
                    ListTile(
                      title: const Text("아침"),
                      trailing: _statusBox(intake["morning"]),
                    ),
                    ListTile(
                      title: const Text("점심"),
                      trailing: _statusBox(intake["lunch"]),
                    ),
                    ListTile(
                      title: const Text("저녁"),
                      trailing: _statusBox(intake["dinner"]),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _statusBox(String status) {
    final color = statusColor(status);
    final label = statusLabel(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}

/* ────────────────────────────
   리포트 탭 (더미)
   ──────────────────────────── */

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 주간 복약 누락률, 패턴, 컨디션 요약 등 표시 예정
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.trending_down),
              title: const Text('이번 주 복약 누락률'),
              subtitle: const Text('예: 8% (지난주 대비 4% 감소)'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.warning_amber_rounded),
              title: const Text('위험 복약 패턴'),
              subtitle: const Text('저녁 복약 누락이 3일 연속 발생 중'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('컨디션 변화 요약'),
              subtitle: const Text('지난주 대비 졸림 +30%, 식욕 -10%'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('TODO: AI 리포트 재생성')));
            },
            icon: const Icon(Icons.refresh),
            label: const Text('AI 기반 주간 리포트 다시 생성'),
          ),
        ],
      ),
    );
  }
}

/* ────────────────────────────
   내 정보 탭 (더미)
   ──────────────────────────── */

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 간병인 계정 정보 / 설정 등
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ListTile(
            leading: CircleAvatar(child: Text('간')),
            title: Text('간병인 이름 (예: 홍길동)'),
            subtitle: Text('caregiver@example.com'),
          ),
          const SizedBox(height: 12),
          const Text('설정', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SwitchListTile(
            value: true,
            onChanged: (_) {},
            title: const Text('푸시 알림 받기'),
          ),
          const Divider(),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout),
            label: const Text('로그아웃'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[50],
              foregroundColor: Colors.red[800],
            ),
          ),
        ],
      ),
    );
  }
}

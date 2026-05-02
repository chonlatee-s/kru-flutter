import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb; 
import 'package:google_sign_in/google_sign_in.dart';

// --- Configuration ---
const String baseUrl = 'https://xn--42cm7czac0a7jb0li.com'; 
// const String baseUrl = 'http://localhost/teacher_backend'; 
const Map<String, String> apiHeaders = {
  'X-Api-Key': 'chaichon',
  'Content-Type': 'application/json',
};

// --- State Variables ---
var predictNumber = "";
final predictNumberChanged = ChangeNotifier();
var predictResult = "";
final predictResultChanged = ChangeNotifier();

var guidelines = [];
final guidelinesChanged = ChangeNotifier();

var testings = [];
final testingsChanged = ChangeNotifier();

var word = "";
final wordChanged = ChangeNotifier();

var news = [];
final newsChanged = ChangeNotifier();

var jobs = [];
final jobsChanged = ChangeNotifier();

var categories = [];
final categoriesChanged = ChangeNotifier();

var examHistory = [];
final examHistoryChanged = ChangeNotifier();

List leaderboard = [];
ValueNotifier leaderboardChanged = ValueNotifier(0);

// --- Google Sign In Configuration ---
// ใช้ค่า Web Client ID (client_type: 3) จากไฟล์ google-services.json ใหม่ของคุณ
const String googleClientId = '448726310003-16as1nib4irqspbrkl607p4tkaoapmcl.apps.googleusercontent.com';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  // แยกส่งค่าตาม Platform เพื่อป้องกัน Error บน Web และแก้ Error 10 บน Android
  clientId: kIsWeb ? googleClientId : null,
  serverClientId: kIsWeb ? null : googleClientId,
  scopes: <String>[
    'email',
    'profile',
    'openid',
  ],
);

// --- User State ---
Map<String, dynamic>? currentUser;
final userChanged = ChangeNotifier();

// --- Functions ---

// 1. ระบบ Login (ปรับปรุงให้รองรับทั้ง ID Token และ Profile Data)
Future<void> loginWithGoogle(BuildContext context) async {
  try {
    debugPrint('1. เริ่มกระบวนการ Login (Platform: ${kIsWeb ? "Web" : "Android"})...');
    
    // บังคับ Sign Out ก่อนเพื่อความสดใหม่ของ Session เวลาเทส
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    
    if (googleUser == null) {
      debugPrint('ผู้ใช้ยกเลิกการเลือกบัญชี');
      return;
    }

    debugPrint('2. ได้ข้อมูลจาก Google แล้ว: ${googleUser.email}');
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    
    Map<String, dynamic> requestBody;

    if (googleAuth.idToken != null) {
      // สำหรับ Android: ส่ง idToken ไปให้ Backend ตรวจสอบ (ปลอดภัยที่สุด)
      debugPrint('ได้รับ idToken สำเร็จ');
      requestBody = {
        'token': googleAuth.idToken,
      };
    } else {
      // สำหรับ Web หรือกรณี Token ไม่มา: ส่ง Profile Data แทน
      debugPrint('idToken เป็น null, ส่ง Profile Data แทน');
      requestBody = {
        'is_web': kIsWeb,
        'email': googleUser.email,
        'name': googleUser.displayName,
        'picture': googleUser.photoUrl,
        'google_id': googleUser.id,
      };
    }

    debugPrint('3. กำลังส่งข้อมูลไป PHP: $baseUrl/api_login_google_app.php');

    final response = await http.post(
      Uri.parse('$baseUrl/api_login_google_app.php'),
      headers: apiHeaders,
      body: jsonEncode(requestBody),
    ).timeout(const Duration(seconds: 15));

    debugPrint('4. PHP Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      
      if (jsonResponse['status'] == 'success') {
        currentUser = jsonResponse['user'];
        userChanged.notifyListeners();
        debugPrint('5. Login สำเร็จ: ${currentUser!['name']}');
        
        getExamHistory(); // ดึงประวัติการสอบทันที
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ยินดีต้อนรับคุณ ${currentUser!['name']}', style: const TextStyle(fontFamily: 'Kanit')),
            backgroundColor: const Color(0xFF6A806A),
          ),
        );
      } else {
        _showError(context, 'Server Error: ${jsonResponse['message']}');
      }
    } else {
      _showError(context, 'ติดต่อ Server ไม่ได้ (${response.statusCode})');
    }
  } catch (error) {
    debugPrint('เกิดข้อผิดพลาดร้ายแรง: $error');
    _showError(context, 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ');
  }
}

void _showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
  );
  userChanged.notifyListeners();
}

// 2. ฟังก์ชัน Log out
Future<void> logout() async {
  try {
    await _googleSignIn.signOut();
    currentUser = null;
    userChanged.notifyListeners();
    debugPrint('ออกจากระบบเรียบร้อย');
  } catch (e) {
    debugPrint('Logout Error: $e');
  }
}

// 3. ฟังก์ชันดึงประวัติการสอบ
void getExamHistory() async {
  if (currentUser == null || currentUser!['email'] == null) return;

  try {
    final String email = currentUser!['email'];
    final response = await http.get(
      Uri.parse('$baseUrl/api_history.php?email=$email'),
      headers: apiHeaders,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        examHistory.clear();
        examHistory.addAll(jsonResponse['data']);
        examHistoryChanged.notifyListeners();
      }
    }
  } catch (e) {
    debugPrint('Error getExamHistory: $e');
  }
}

// 4. ทำเนียบคนเก่ง
Future<void> getLeaderboard() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/api_leaderboard.php'), 
      headers: apiHeaders
    );
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      if (res['status'] == 'success') {
        leaderboard = res['data'];
        leaderboardChanged.value++;
      }
    }
  } catch (e) {
    debugPrint('Leaderboard Error: $e');
  }
}

// --- API Functions อื่นๆ ---

void getPredict() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/api_get_fortune.php'), headers: apiHeaders);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
        final fortuneData = jsonResponse['data'];
        predictNumber = fortuneData['id'].toString();
        predictResult = fortuneData['result'] ?? '';
        predictNumberChanged.notifyListeners();
        predictResultChanged.notifyListeners();
      }
    }
  } catch (e) { debugPrint('Exception getPredict: $e'); }
}

void getCategories() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/api_get_categories.php'), headers: apiHeaders);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        categories.clear();
        categories.addAll(jsonResponse['data']);
        categoriesChanged.notifyListeners();
      }
    }
  } catch (e) { debugPrint('Error getCategories: $e'); }
}

void getTesting({String mode = 'practice', int? categoryId}) async {
  try {
    String url = '$baseUrl/api_exams.php?mode=$mode';
    if (categoryId != null) url += '&category_id=$categoryId';
    final result = await http.get(Uri.parse(url), headers: apiHeaders);
    if (result.statusCode == 200) {
      final List json = jsonDecode(result.body);
      testings.clear();
      for (int i = 0; i < json.length; i++) {
        var item = json[i];
        var options = item['options'] as List;
        int findCorrectIdx = options.indexWhere((opt) => opt['is_correct'] == 1 || opt['is_correct'] == "1" || opt['is_correct'] == true);
        int finalCorrectIndex = (findCorrectIdx != -1) ? (findCorrectIdx + 1) : 0;
        testings.add({
          'topic': i,
          'id': item['id'],
          'question': item['question_text'],
          'question_image': item['question_image'],
          'explanation': item['reference_text'], 
          'detail_url': item['detail_url'],
          'answer_user': '0',
          'options': options.map((opt) => {'id': opt['id'], 'text': opt['option_text'], 'image': opt['option_image'], 'is_correct': opt['is_correct']}).toList(),
          'correct_answer_index': finalCorrectIndex,
        });
      }
      testingsChanged.notifyListeners();
    }
  } catch (e) { debugPrint('Error getTesting: $e'); }
}

void getWord() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/api_get_word.php'), headers: apiHeaders);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
        word = jsonResponse['data']['word'] ?? '';
        wordChanged.notifyListeners();
      }
    }
  } catch (e) { debugPrint('Exception getWord: $e'); }
}

void getNews() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/api_get_announcement.php'), headers: apiHeaders);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        news.clear(); 
        if (jsonResponse['data'] != null) {
          news.add({'news': jsonResponse['data']['message'], 'ref': jsonResponse['data']['link_url']});
        }
        newsChanged.notifyListeners();
      }
    }
  } catch (e) { debugPrint('Exception getNews: $e'); }
}

void getJobs() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/api_jobs.php'), headers: apiHeaders);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
        jobs.clear();
        final dataList = jsonResponse['data'] as List;
        for (var item in dataList) {
          jobs.add({
            'topic': item['position'],
            'date_end': item['deadline'],
            'link': item['detail_url'],
            'image': item['job_image'],
            'school': item['school_name'],
          });
        }
        jobsChanged.notifyListeners();
      }
    }
  } catch (e) { debugPrint('Exception getJobs: $e'); }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb; 
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart'; // เพิ่มเพื่อจำค่า Login

// --- Configuration ---
const String baseUrl = 'https://xn--42cm7czac0a7jb0li.com'; 
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
const String googleClientId = '448726310003-16as1nib4irqspbrkl607p4tkaoapmcl.apps.googleusercontent.com';

final GoogleSignIn _googleSignIn = GoogleSignIn(
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

// 1. ฟังก์ชันใหม่: ตรวจสอบสถานะ Login เมื่อเปิดแอป
Future<void> checkLoginStatus() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userData = prefs.getString('user_data');

    if (userData != null) {
      currentUser = jsonDecode(userData);
      userChanged.notifyListeners();
      getExamHistory(); // ดึงประวัติการสอบทันที
      debugPrint('Auto Login สำเร็จ: ${currentUser!['name']}');
    } else {
      // ลอง Silent Sign In เผื่อ Session Google ยังอยู่
      final GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      if (googleUser != null) {
        debugPrint('Silent Sign In สำเร็จ: ${googleUser.email}');
      }
    }
  } catch (e) {
    debugPrint('Error checkLoginStatus: $e');
  }
}

// 2. ระบบ Login (ปรับปรุงให้บันทึกข้อมูลลงเครื่อง)
Future<void> loginWithGoogle(BuildContext context) async {
  try {
    debugPrint('1. เริ่มกระบวนการ Login...');
    
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    
    if (googleUser == null) {
      debugPrint('ผู้ใช้ยกเลิกการเลือกบัญชี');
      return;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    Map<String, dynamic> requestBody;

    if (googleAuth.idToken != null) {
      requestBody = { 'token': googleAuth.idToken };
    } else {
      requestBody = {
        'is_web': kIsWeb,
        'email': googleUser.email,
        'name': googleUser.displayName,
        'picture': googleUser.photoUrl,
        'google_id': googleUser.id,
      };
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api_login_google_app.php'),
      headers: apiHeaders,
      body: jsonEncode(requestBody),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      
      if (jsonResponse['status'] == 'success') {
        currentUser = jsonResponse['user'];
        
        // --- บันทึกลงเครื่องทันทีที่ Login สำเร็จ ---
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', jsonEncode(currentUser));
        
        userChanged.notifyListeners();
        getExamHistory();
        
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
    debugPrint('เกิดข้อผิดพลาด: $error');
    _showError(context, 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ');
  }
}

void _showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
  );
  userChanged.notifyListeners();
}

// 3. ฟังก์ชัน Log out (ปรับปรุงให้ล้างข้อมูลในเครื่อง)
Future<void> logout() async {
  try {
    await _googleSignIn.signOut();
    
    // --- ล้างข้อมูลที่เซฟไว้ในเครื่องออก ---
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    
    currentUser = null;
    userChanged.notifyListeners();
    debugPrint('ออกจากระบบและล้างข้อมูลในเครื่องเรียบร้อย');
  } catch (e) {
    debugPrint('Logout Error: $e');
  }
}

// 4. ฟังก์ชันดึงประวัติการสอบ
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
  } catch (e) { debugPrint('Error getExamHistory: $e'); }
}

// 5. ทำเนียบคนเก่ง
Future<void> getLeaderboard() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/api_leaderboard.php'), headers: apiHeaders);
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      if (res['status'] == 'success') {
        leaderboard = res['data'];
        leaderboardChanged.value++;
      }
    }
  } catch (e) { debugPrint('Leaderboard Error: $e'); }
}

// 6. ข่าวประกาศ
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

// 7. คำศัพท์รายวัน
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

// 8. หมวดหมู่ข้อสอบ
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

// 9. ดึงข้อสอบ
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
        testings.add({
          'topic': i,
          'id': item['id'],
          'question': item['question_text'],
          'question_image': item['question_image'],
          'explanation': item['reference_text'], 
          'detail_url': item['detail_url'],
          'answer_user': '0',
          'options': options.map((opt) => {'id': opt['id'], 'text': opt['option_text'], 'image': opt['option_image'], 'is_correct': opt['is_correct']}).toList(),
          'correct_answer_index': (findCorrectIdx != -1) ? (findCorrectIdx + 1) : 0,
        });
      }
      testingsChanged.notifyListeners();
    }
  } catch (e) { debugPrint('Error getTesting: $e'); }
}

// 10. ทำนายดวง/เลขเด็ด
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

// 11. งานราชการ
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
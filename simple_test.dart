import 'dart:convert';
import 'dart:io';

void main() async {
  print('🧪 Simple API Test');
  print('==================');
  
  final testMessage = "Sorry, just saw this now. Been super busy lately...";
  
  try {
    print('📤 Sending request...');
    
    final client = HttpClient();
    final request = await client.postUrl(Uri.parse('http://127.0.0.1:3000/api/v1/analyze'));
    
    request.headers.set('Content-Type', 'application/json');
    
    final body = {
      'input_text': testMessage,
      'content_type': 'dm',
      'analysis_goal': 'lie_detection',
      'tone': 'brutal',
      'comeback_enabled': true
    };
    
    request.write(jsonEncode(body));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('📥 Response received!');
    print('Status: ${response.statusCode}');
    print('Body: $responseBody');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      print('\n🎯 Analysis Results:');
      print('Risk Score: ${data['data']['lie_risk_score']}%');
      print('Pattern: ${data['data']['behavior_pattern']}');
      print('Verdict: ${data['data']['suss_verdict']}');
      print('Comeback: ${data['data']['comeback']}');
    }
    
  } catch (e) {
    print('❌ Error: $e');
  }
} 
import 'dart:convert';
import 'dart:io';

void main() async {
  print('🧪 Testing API connection...');
  
  try {
    final client = HttpClient();
    final request = await client.postUrl(Uri.parse('http://127.0.0.1:3000/api/v1/analyze'));
    
    request.headers.set('Content-Type', 'application/json');
    
    final body = {
      'input_text': 'Sorry, just saw this now. Been super busy lately...',
      'content_type': 'dm',
      'analysis_goal': 'lie_detection',
      'tone': 'brutal',
      'comeback_enabled': true
    };
    
    request.write(jsonEncode(body));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('✅ API Response:');
    print(responseBody);
    
  } catch (e) {
    print('❌ API Error: $e');
  }
} 
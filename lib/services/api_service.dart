import 'dart:convert';
import 'dart:io';
import '../models/analysis_result.dart';

class ApiService {
  // 🚀 CHANGE THIS TO YOUR RAILWAY URL WHEN DEPLOYED
  static const String baseUrl = 'http://127.0.0.1:3000/api/v1';
  // static const String baseUrl = 'https://your-app-name.railway.app/api/v1';

  static Future<AnalysisResult> analyzeMessage({
    required String inputText,
    required String contentType,
    required String analysisGoal,
    required String tone,
    bool comebackEnabled = true,
    String? relationship,
  }) async {
    print('🚀 ApiService: Making API call...');
    
    try {
      final client = HttpClient();
      final request = await client.postUrl(Uri.parse('$baseUrl/analyze'));
      
      request.headers.set('Content-Type', 'application/json');
      
      // For pattern analysis, split the input text into an array of messages
      dynamic inputData;
      if (analysisGoal == 'pattern_analysis') {
        inputData = inputText.split('\n').where((line) => line.trim().isNotEmpty).toList();
      } else {
        inputData = inputText;
      }
      
      final body = {
        'input_text': inputData,
        'content_type': contentType,
        'analysis_goal': analysisGoal,
        'tone': tone,
        'comeback_enabled': comebackEnabled,
        'relationship': relationship,
      };
      
      print('📤 ApiService: Sending request: ${jsonEncode(body)}');
      request.write(jsonEncode(body));
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      print('📥 ApiService: Received response: $responseBody');
      
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(responseBody);
        final data = jsonData['data'];
        
        // Map the API response to our Flutter model
        final mappedData = {
          'lieDetector': {
            'riskScore': data['lie_risk_score'],
            'behaviorPattern': data['behavior_pattern'],
            'evidence': data['evidence'],
            'subtextSummary': data['subtext_summary'],
            'sussVerdict': data['suss_verdict'],
            'comeback': data['comeback'],
          }
        };
        
        print('✅ ApiService: Successfully mapped API response');
        return AnalysisResult.fromMap(mappedData);
      } else {
        throw Exception('API returned status code: ${response.statusCode}');
      }
      
    } catch (e) {
      print('❌ ApiService: API call failed: $e');
      rethrow;
    }
  }
} 
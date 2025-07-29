import 'dart:convert';
import 'dart:io';
import '../models/analysis_result.dart';
import '../models/pattern_analysis.dart';
import '../models/history_item.dart';

class AnalysisService {
  // 🚀 CHANGE THIS TO YOUR RAILWAY URL WHEN DEPLOYED
  static const String baseUrl = 'http://127.0.0.1:3000/api/v1';
  // static const String baseUrl = 'https://your-app-name.railway.app/api/v1';

  // 🎯 ANALYZE MESSAGE - SIMPLIFIED VERSION
  static Future<AnalysisResult> analyzeMessage({
    required String text,
    required String category,
    required String tone,
    bool comebackEnabled = true,
  }) async {
    print('🚀 Making API call to analyze message...');
    
    try {
      final client = HttpClient();
      final request = await client.postUrl(Uri.parse('$baseUrl/analyze'));
      
      request.headers.set('Content-Type', 'application/json');
      
      final body = {
        'input_text': text,
        'content_type': _mapCategoryToContentType(category),
        'analysis_goal': _mapCategoryToAnalysisGoal(category),
        'tone': tone,
        'comeback_enabled': comebackEnabled
      };
      
      print('📤 Sending request: ${jsonEncode(body)}');
      request.write(jsonEncode(body));
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      print('📥 Received response: $responseBody');
      
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
        
        print('✅ Successfully mapped API response');
        return AnalysisResult.fromMap(mappedData);
      } else {
        throw Exception('API returned status code: ${response.statusCode}');
      }
      
    } catch (e) {
      print('❌ API call failed: $e');
      rethrow;
    }
  }

  // 🎯 ANALYZE PATTERNS - SIMPLIFIED VERSION
  static Future<PatternAnalysis> analyzePatterns({
    required List<String> messages,
    required String category,
    required String tone,
  }) async {
    print('🚀 Making API call to analyze patterns...');
    
    try {
      final client = HttpClient();
      final request = await client.postUrl(Uri.parse('$baseUrl/analyze'));
      
      request.headers.set('Content-Type', 'application/json');
      
      final body = {
        'input_text': messages.join('\n\n'),
        'content_type': _mapCategoryToContentType(category),
        'analysis_goal': 'pattern_analysis',
        'tone': tone,
        'comeback_enabled': false
      };
      
      request.write(jsonEncode(body));
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(responseBody);
        final data = jsonData['data'];
        
        return PatternAnalysis(
          patternType: data['behavior_pattern'] ?? 'Unknown',
          confidence: data['lie_risk_score']?.toDouble() ?? 0.0,
          description: data['subtext_summary'] ?? 'No pattern detected',
          recommendations: [data['suss_verdict'] ?? 'No recommendations'],
        );
      } else {
        throw Exception('API returned status code: ${response.statusCode}');
      }
      
    } catch (e) {
      print('❌ Pattern analysis failed: $e');
      rethrow;
    }
  }

  // 🎯 GENERATE COMEBACK - SIMPLIFIED VERSION
  static Future<String> generateComeback({
    required String originalMessage,
    required String analysis,
    required String tone,
  }) async {
    print('🚀 Making API call to generate comeback...');
    
    try {
      final client = HttpClient();
      final request = await client.postUrl(Uri.parse('$baseUrl/analyze'));
      
      request.headers.set('Content-Type', 'application/json');
      
      final body = {
        'input_text': originalMessage,
        'content_type': 'dm',
        'analysis_goal': 'comeback_generation',
        'tone': tone,
        'comeback_enabled': true
      };
      
      request.write(jsonEncode(body));
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(responseBody);
        return jsonData['data']['comeback'] ?? 'No comeback generated';
      } else {
        throw Exception('API returned status code: ${response.statusCode}');
      }
      
    } catch (e) {
      print('❌ Comeback generation failed: $e');
      rethrow;
    }
  }

  // 🔧 HELPER METHODS
  static String _mapCategoryToContentType(String category) {
    switch (category.toLowerCase()) {
      case 'dm':
      case 'direct message':
        return 'dm';
      case 'text':
      case 'sms':
        return 'text';
      case 'social':
      case 'social media':
        return 'social';
      default:
        return 'dm';
    }
  }

  static String _mapCategoryToAnalysisGoal(String category) {
    switch (category.toLowerCase()) {
      case 'dm':
      case 'direct message':
      case 'text':
      case 'sms':
      case 'social':
      case 'social media':
        return 'lie_detection';
      default:
        return 'lie_detection';
    }
  }
} 
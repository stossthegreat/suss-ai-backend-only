// 🚀 ANALYSIS SERVICE - LEGACY SYSTEM
import 'dart:convert';
import 'dart:html' as html;
import '../models/analysis_result.dart';
import '../models/pattern_analysis.dart';
import '../models/history_item.dart';

class AnalysisService {
  // ✅ Point to the correct backend URL
  static const String baseUrl = 'https://suss-ai-backend-only-production.up.railway.app/api/v1';
  // static const String baseUrl = 'http://127.0.0.1:3000/api/v1'; // For local development

  // 🎯 ANALYZE MESSAGE - SIMPLIFIED VERSION
  static Future<AnalysisResult> analyzeMessage({
    required String text,
    required String category,
    required String tone,
    bool comebackEnabled = true,
  }) async {
    print('🚀 Making API call to analyze message...');
    
    try {
      final body = {
        'input_text': text,
        'content_type': _mapCategoryToContentType(category),
        'analysis_goal': _mapCategoryToAnalysisGoal(category),
        'tone': tone,
        'comeback_enabled': comebackEnabled
      };
      
      print('📤 Sending request: ${jsonEncode(body)}');
      
      final request = html.HttpRequest();
      request.open('POST', '$baseUrl/analyze');
      request.setRequestHeader('Content-Type', 'application/json');
      request.setRequestHeader('Accept', 'application/json');
      
      request.send(jsonEncode(body));
      await request.onLoad.first;
      
      print('📥 Received response: ${request.responseText}');
      print('📊 Status code: ${request.status}');
      
      if (request.status == 200) {
        final jsonData = jsonDecode(request.responseText!);
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
        throw Exception('API returned status code: ${request.status}');
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
      final body = {
        'input_text': messages,
        'content_type': _mapCategoryToContentType(category),
        'analysis_goal': 'pattern_analysis',
        'tone': tone,
        'comeback_enabled': false
      };
      
      print('📤 Sending pattern analysis request: ${jsonEncode(body)}');
      
      final request = html.HttpRequest();
      request.open('POST', '$baseUrl/analyze');
      request.setRequestHeader('Content-Type', 'application/json');
      request.setRequestHeader('Accept', 'application/json');
      
      request.send(jsonEncode(body));
      await request.onLoad.first;
      
      print('📥 Received pattern response: ${request.responseText}');
      print('📊 Status code: ${request.status}');
      
      if (request.status == 200) {
        final jsonData = jsonDecode(request.responseText!);
        final data = jsonData['data'];
        
        return PatternAnalysis(
          compositeRedFlagScore: data['lie_risk_score']?.toInt() ?? 0,
          dominantMotive: data['behavior_pattern'] ?? 'Unknown',
          patternType: data['pattern_detected'] ?? 'Unknown',
          emotionalSummary: data['subtext_summary'] ?? 'No pattern detected',
          lieDetector: LieDetectorResult(
            verdict: data['suss_verdict'] ?? 'Pattern analysis complete',
            isHonest: (data['lie_risk_score'] ?? 0) < 50,
            cues: [data['pattern_summary'] ?? 'No cues detected'],
            gutCheck: data['suss_verdict'] ?? 'Pattern analysis complete',
          ),
        );
      } else {
        throw Exception('API returned status code: ${request.status}');
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
      final body = {
        'input_text': originalMessage,
        'content_type': 'dm',
        'analysis_goal': 'lie_detection',
        'tone': tone,
        'comeback_enabled': true
      };
      
      print('📤 Sending comeback request: ${jsonEncode(body)}');
      
      final request = html.HttpRequest();
      request.open('POST', '$baseUrl/analyze');
      request.setRequestHeader('Content-Type', 'application/json');
      request.setRequestHeader('Accept', 'application/json');
      
      request.send(jsonEncode(body));
      await request.onLoad.first;
      
      print('📥 Received comeback response: ${request.responseText}');
      print('📊 Status code: ${request.status}');
      
      if (request.status == 200) {
        final jsonData = jsonDecode(request.responseText!);
        return jsonData['data']['comeback'] ?? 'No comeback generated';
      } else {
        throw Exception('API returned status code: ${request.status}');
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
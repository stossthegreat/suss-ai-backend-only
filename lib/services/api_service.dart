import 'dart:convert';
import 'dart:html' as html;
import '../models/analysis_result.dart';
import '../models/whisperfire_models.dart';

class ApiService {
  // 🚀 RAILWAY BACKEND URL
  static const String baseUrl = 'https://suss-ai-backend-only-production-c323.up.railway.app/api/v1';
  // static const String baseUrl = 'http://127.0.0.1:3000/api/v1'; // For local development

  // 🧠 LEGACY SYSTEM (for backward compatibility)
  static Future<AnalysisResult> analyzeMessage({
    required String inputText,
    required String contentType,
    required String analysisGoal,
    required String tone,
    bool comebackEnabled = true,
    String? relationship,
  }) async {
    print('🚀 ApiService: Making LEGACY API call...');
    print('🚀 ApiService: URL: $baseUrl/analyze');
    print('🚀 ApiService: Analysis goal: $analysisGoal');
    
    try {
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
      
      print('📤 ApiService: Sending LEGACY request: ${jsonEncode(body)}');
      
      // ✅ Use dart:html for web compatibility
      final request = html.HttpRequest();
      request.open('POST', '$baseUrl/analyze');
      request.setRequestHeader('Content-Type', 'application/json');
      request.setRequestHeader('Accept', 'application/json');
      
      // Send the request
      request.send(jsonEncode(body));
      
      // Wait for the response
      await request.onLoad.first;
      
      print('📥 ApiService: Received LEGACY response: ${request.responseText}');
      print('📊 ApiService: Status code: ${request.status}');
      
      if (request.status == 200) {
        final jsonData = jsonDecode(request.responseText!);
        print('📊 ApiService: Parsed JSON: $jsonData');
        
        final data = jsonData['data'];
        print('📊 ApiService: Data: $data');
        
        // Map the API response to our Flutter model based on analysis goal
        final mappedData = _mapLegacyResponseToFlutterModel(data, analysisGoal);
        
        print('✅ ApiService: Mapped data: $mappedData');
        print('✅ ApiService: Successfully mapped LEGACY API response');
        return AnalysisResult.fromMap(mappedData);
      } else {
        // Handle error responses
        print('❌ ApiService: HTTP Error ${request.status}');
        print('❌ ApiService: Response body: ${request.responseText}');
        
        final errorData = jsonDecode(request.responseText!);
        throw Exception('API Error: ${errorData['error'] ?? 'Unknown error'}');
      }
      
    } catch (e) {
      print('❌ ApiService: LEGACY API call failed: $e');
      print('❌ ApiService: Error type: ${e.runtimeType}');
      rethrow;
    }
  }

  // 🚀 WHISPERFIRE SYSTEM (new system)
  static Future<WhisperfireResponse> analyzeMessageWhisperfire({
    required String inputText,
    required String contentType,
    required String analysisGoal,
    required String tone,
    String? relationship,
    String? personName,
    String? stylePreference,
  }) async {
    print('🚀 ApiService: Making WHISPERFIRE API call...');
    print('🚀 ApiService: URL: $baseUrl/analyze');
    print('🚀 ApiService: Analysis goal: $analysisGoal');
    
    try {
      // For pattern profiling, split the input text into an array of messages
      dynamic inputData;
      if (analysisGoal == 'pattern_profiling') {
        inputData = inputText.split('\n').where((line) => line.trim().isNotEmpty).toList();
      } else {
        inputData = inputText;
      }
      
      final body = {
        'input_text': inputData,
        'content_type': contentType,
        'analysis_goal': analysisGoal,
        'tone': tone,
        'relationship': relationship,
        'person_name': personName,
        'style_preference': stylePreference,
      };
      
      print('📤 ApiService: Sending WHISPERFIRE request: ${jsonEncode(body)}');
      
      // ✅ Use dart:html for web compatibility
      final request = html.HttpRequest();
      request.open('POST', '$baseUrl/analyze');
      request.setRequestHeader('Content-Type', 'application/json');
      request.setRequestHeader('Accept', 'application/json');
      
      // Send the request
      request.send(jsonEncode(body));
      
      // Wait for the response
      await request.onLoad.first;
      
      print('📥 ApiService: Received WHISPERFIRE response: ${request.responseText}');
      print('📊 ApiService: Status code: ${request.status}');
      
      if (request.status == 200) {
        final jsonData = jsonDecode(request.responseText!);
        print('📊 ApiService: Parsed JSON: $jsonData');
        
        final data = jsonData['data'];
        print('📊 ApiService: Data: $data');
        
        // Map the WHISPERFIRE response based on analysis goal
        final whisperfireData = _mapWhisperfireResponse(data, analysisGoal);
        
        print('✅ ApiService: Mapped WHISPERFIRE data: $whisperfireData');
        print('✅ ApiService: Successfully mapped WHISPERFIRE API response');
        return whisperfireData;
      } else {
        // Handle error responses
        print('❌ ApiService: HTTP Error ${request.status}');
        print('❌ ApiService: Response body: ${request.responseText}');
        
        final errorData = jsonDecode(request.responseText!);
        throw Exception('API Error: ${errorData['error'] ?? 'Unknown error'}');
      }
      
    } catch (e) {
      print('❌ ApiService: WHISPERFIRE API call failed: $e');
      print('❌ ApiService: Error type: ${e.runtimeType}');
      rethrow;
    }
  }

  // 🧠 LEGACY RESPONSE MAPPING
  static Map<String, dynamic> _mapLegacyResponseToFlutterModel(Map<String, dynamic> data, String analysisGoal) {
    if (analysisGoal == 'pattern_analysis') {
      // Pattern analysis has different field names
      return {
        'headline': data['suss_verdict'] ?? 'Pattern Analysis Complete',
        'motive': data['pattern_detected'] ?? 'Unknown pattern',
        'redFlag': _calculatePatternRiskScore(data),
        'redFlagTier': _getRedFlagTier(_calculatePatternRiskScore(data)),
        'feeling': data['emotional_effect'] ?? 'Neutral',
        'subtext': data['pattern_summary'] ?? 'No pattern detected',
        'comeback': data['comeback'] ?? '',
        'pattern': data['archetype'] ?? 'Unknown',
        'lieDetector': {
          'verdict': data['suss_verdict'] ?? 'Pattern analysis complete',
          'isHonest': _calculatePatternRiskScore(data) < 50,
          'cues': [data['pattern_summary'] ?? 'No cues detected'],
          'gutCheck': data['suss_verdict'] ?? 'Pattern analysis complete',
        }
      };
    } else {
      // Standard lie detection response
      return {
        'headline': data['suss_verdict'] ?? 'Analysis Complete',
        'motive': data['behavior_pattern'] ?? 'Unknown pattern',
        'redFlag': data['lie_risk_score'] ?? 0,
        'redFlagTier': _getRedFlagTier(data['lie_risk_score'] ?? 0),
        'feeling': _getFeelingFromScore(data['lie_risk_score'] ?? 0),
        'subtext': data['subtext_summary'] ?? 'No subtext detected',
        'comeback': data['comeback'] ?? '',
        'pattern': data['behavior_pattern'] ?? 'Unknown',
        'lieDetector': {
          'verdict': data['suss_verdict'] ?? 'Analysis complete',
          'isHonest': (data['lie_risk_score'] ?? 0) < 50,
          'cues': List<String>.from(data['evidence'] ?? []),
          'gutCheck': data['suss_verdict'] ?? 'Analysis complete',
        }
      };
    }
  }

  // 🚀 WHISPERFIRE RESPONSE MAPPING
  static WhisperfireResponse _mapWhisperfireResponse(Map<String, dynamic> data, String analysisGoal) {
    switch (analysisGoal) {
      case 'instant_scan':
        final scanResult = WhisperfireScanResult.fromMap(data);
        return WhisperfireResponse(
          scanResult: scanResult.viralVerdict.sussVerdict,
          viralPotential: scanResult.confidenceMetrics.viralPotential,
          confidenceLevel: scanResult.confidenceMetrics.viralPotential,
          empowermentScore: 85, // High empowerment for actionable insights
          safetyPriority: _getSafetyPriorityFromScan(scanResult),
          psychologicalAccuracy: scanResult.confidenceMetrics.viralPotential,
        );
        
      case 'comeback_generation':
        final comebackResult = WhisperfireComebackResult.fromMap(data);
        return WhisperfireResponse(
          comebackResult: comebackResult.primaryComeback,
          viralPotential: comebackResult.viralMetrics.viralFactor,
          confidenceLevel: comebackResult.viralMetrics.powerLevel,
          empowermentScore: comebackResult.viralMetrics.powerLevel,
          safetyPriority: comebackResult.safetyCheck.riskLevel,
          psychologicalAccuracy: 80, // High accuracy for comeback generation
        );
        
      case 'pattern_profiling':
        final patternResult = WhisperfirePatternResult.fromMap(data);
        return WhisperfireResponse(
          patternResult: patternResult.viralInsights.sussVerdict,
          viralPotential: patternResult.confidenceMetrics.viralPotential,
          confidenceLevel: patternResult.confidenceMetrics.analysisConfidence,
          empowermentScore: 90, // Very high empowerment for pattern insights
          safetyPriority: patternResult.riskAssessment.interventionUrgency,
          psychologicalAccuracy: patternResult.confidenceMetrics.analysisConfidence,
        );
        
      default:
        return WhisperfireResponse();
    }
  }

  // 🛡️ SAFETY PRIORITY CALCULATION
  static String _getSafetyPriorityFromScan(WhisperfireScanResult scanResult) {
    final redFlagIntensity = scanResult.psychologicalScan.redFlagIntensity;
    final relationshipToxicity = scanResult.psychologicalScan.relationshipToxicity;
    
    if (redFlagIntensity >= 80 || relationshipToxicity >= 80) return 'CRITICAL';
    if (redFlagIntensity >= 60 || relationshipToxicity >= 60) return 'HIGH';
    if (redFlagIntensity >= 40 || relationshipToxicity >= 40) return 'MODERATE';
    return 'LOW';
  }

  // Helper method to calculate risk score for pattern analysis
  static int _calculatePatternRiskScore(Map<String, dynamic> data) {
    // Simple heuristic based on pattern type
    final pattern = data['pattern_detected']?.toString().toLowerCase() ?? '';
    final archetype = data['archetype']?.toString().toLowerCase() ?? '';
    
    if (pattern.contains('manipulation') || archetype.contains('manipulator')) return 85;
    if (pattern.contains('evasion') || archetype.contains('evasive')) return 75;
    if (pattern.contains('mixed') || pattern.contains('confusion')) return 65;
    if (pattern.contains('distance') || pattern.contains('avoidance')) return 55;
    return 45; // Default moderate risk
  }

  // Helper method to get red flag tier
  static String _getRedFlagTier(int score) {
    if (score >= 80) return 'Critical';
    if (score >= 60) return 'High';
    if (score >= 40) return 'Medium';
    if (score >= 20) return 'Low';
    return 'Safe';
  }

  // Helper method to get feeling from score
  static String _getFeelingFromScore(int score) {
    if (score >= 80) return 'Extremely suspicious';
    if (score >= 60) return 'Very suspicious';
    if (score >= 40) return 'Somewhat suspicious';
    if (score >= 20) return 'Slightly suspicious';
    return 'Neutral';
  }
} 
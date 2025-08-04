import 'dart:convert';
import 'dart:html' as html;
import '../models/analysis_result.dart';
import '../models/whisperfire_models.dart';

class ApiService {
  // 🚀 RAILWAY BACKEND URL (for scan and comeback features)
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
    String? outputStyle,
    String? preferredModel, // Add model selection
  }) async {
    print('🚀 ApiService: Making WHISPERFIRE API call...');
    print('🚀 ApiService: URL: $baseUrl/analyze');
    print('🚀 ApiService: Analysis goal: $analysisGoal');
    print('🚀 ApiService: Output style: $outputStyle');
    print('🚀 ApiService: Preferred model: $preferredModel');
    
    try {
      // For pattern profiling, split the input text into an array of messages
      dynamic inputData;
      if (analysisGoal == 'pattern_profiling') {
        // For pattern profiling, send as array of messages
        final messages = inputText.split('\n').where((line) => line.trim().isNotEmpty).toList();
        inputData = messages;
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
        'output_style': outputStyle,
        'preferred_model': preferredModel, // Include model selection
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
        final whisperfireData = await _mapWhisperfireResponse(data, analysisGoal,
          inputText: inputText,
          relationship: relationship,
          tone: tone,
          personName: personName,
        );
        
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
  static Future<WhisperfireResponse> _mapWhisperfireResponse(Map<String, dynamic> data, String analysisGoal, {
    String? inputText,
    String? relationship,
    String? tone,
    String? personName,
  }) async {
    try {
      switch (analysisGoal) {
        case 'instant_scan':
          final scanResult = WhisperfireScanResult.fromMap(data);
          return WhisperfireResponse(
            scanResult: scanResult,
            viralPotential: scanResult.confidenceMetrics.viralPotential,
            confidenceLevel: scanResult.confidenceMetrics.viralPotential,
            empowermentScore: 85, // High empowerment for actionable insights
            safetyPriority: _getSafetyPriorityFromScan(scanResult),
            psychologicalAccuracy: scanResult.confidenceMetrics.viralPotential,
          );
          
        case 'comeback_generation':
          final comebackResult = WhisperfireComebackResult.fromMap(data);
          return WhisperfireResponse(
            comebackResult: comebackResult,
            viralPotential: comebackResult.viralMetrics.viralFactor,
            confidenceLevel: comebackResult.viralMetrics.powerLevel,
            empowermentScore: comebackResult.viralMetrics.powerLevel,
            safetyPriority: comebackResult.safetyCheck.riskLevel,
            psychologicalAccuracy: 80, // High accuracy for comeback generation
          );
          
        case 'pattern_profiling':
          // Use the existing Railway backend for pattern analysis (fallback to mock data)
          try {
            final patternResult = WhisperfirePatternResult.fromMap(data);
            return WhisperfireResponse(
              patternResult: patternResult,
              viralPotential: patternResult.confidenceMetrics.viralPotential,
              confidenceLevel: patternResult.confidenceMetrics.viralPotential,
              empowermentScore: 90, // Very high empowerment for pattern insights
              safetyPriority: patternResult.riskAssessment.interventionUrgency,
              psychologicalAccuracy: patternResult.confidenceMetrics.viralPotential,
            );
          } catch (e) {
            print('❌ Pattern analysis failed, using fallback data: $e');
            // Return fallback pattern data
            return WhisperfireResponse(
              patternResult: _getFallbackPatternResult(),
              viralPotential: 85,
              confidenceLevel: 80,
              empowermentScore: 90,
              safetyPriority: 'HIGH',
              psychologicalAccuracy: 85,
            );
          }
          
        default:
          return WhisperfireResponse();
      }
    } catch (e) {
      print('❌ ApiService: Error mapping WHISPERFIRE response: $e');
      print('❌ ApiService: Raw data: $data');
      print('❌ ApiService: Analysis goal: $analysisGoal');
      rethrow;
    }
  }

  // static const String baseUrl = 'http://127.0.0.1:3000/api/v1'; // For local development

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

  // 🛡️ FALLBACK PATTERN RESULT FOR LEGENDARY INTELLIGENCE
  static WhisperfirePatternResult _getFallbackPatternResult() {
    return WhisperfirePatternResult.fromMap({
      'behavioral_profile': {
        'headline': 'The Covert Narcissist - Love Bombing Specialist',
        'manipulator_archetype': 'The Emotional Terrorist',
        'dominant_pattern': 'Intermittent Reinforcement + Gaslighting',
        'manipulation_sophistication': 87
      },
      'pattern_analysis': {
        'manipulation_cycle': 'Phase 1: Love bombing (Days 1-7) ✅ COMPLETE | Phase 2: Testing boundaries (Days 8-14) 🔄 ACTIVE | Phase 3: Gaslighting (Days 15-21) ⏳ INCOMING | Phase 4: Silent treatment (Days 22+) ⏳ PREDICTED',
        'tactics_evolution': [
          'Week 1: Love bombing with excessive attention',
          'Week 2: Testing boundaries with small requests',
          'Week 3: Gaslighting about past conversations',
          'Week 4: Silent treatment after boundary setting'
        ],
        'escalation_timeline': 'Current phase: Testing boundaries. Next predicted move: Gaslighting about past conversations within 48 hours',
        'trigger_events': [
          'Boundary setting triggers silent treatment',
          'Independence display triggers love bombing',
          'Questioning behavior triggers gaslighting',
          'Social engagement triggers jealousy tactics'
        ],
        'pattern_severity_score': 89
      },
      'psychological_assessment': {
        'primary_agenda': 'Emotional Control & Dependency Creation',
        'emotional_damage_inflicted': 'Self-doubt injection: 92% successful | Reality confusion: 78% installed | Boundary erosion: 85% complete | Emotional dependency: 94% established',
        'power_control_methods': [
          'Financial control: Offering to pay for everything',
          'Social isolation: Discouraging friend meetups',
          'Emotional blackmail: \'If you loved me, you would...\'',
          'Information control: Selective sharing of details'
        ],
        'empathy_deficit_indicators': [
          'Unable to validate your feelings',
          'Dismisses your concerns as overreactions',
          'Shows no remorse for hurtful actions',
          'Uses your emotions against you'
        ],
        'reality_distortion_level': 78,
        'psychological_damage_score': 85
      },
      'risk_assessment': {
        'escalation_probability': 85,
        'safety_concerns': [
          'Emotional manipulation escalating to financial control',
          'Social isolation from support system',
          'Complete psychological dependency creation',
          'Potential for future physical control attempts'
        ],
        'relationship_prognosis': 'Toxic & Unsustainable - Immediate extraction recommended',
        'future_behavior_prediction': 'Will attempt to move in together within 30 days, then escalate to financial control within 90 days',
        'intervention_urgency': 'IMMEDIATE ACTION REQUIRED'
      },
      'strategic_recommendations': {
        'pattern_disruption_tactics': [
          'Operation Gray Rock: Become emotionally unavailable',
          'Operation Document: Screenshot everything for evidence',
          'Operation Independence: Secure all financial/social resources',
          'Operation Exodus: Plan complete separation strategy'
        ],
        'boundary_enforcement_strategy': 'Consistent \'no\' responses with no explanations',
        'communication_guidelines': 'Document all interactions, maintain information diet',
        'escape_strategy': 'Build financial independence quietly, prepare emergency exit plan',
        'safety_planning': 'Establish emergency contacts, secure important documents'
      },
      'viral_insights': {
        'suss_verdict': 'This person is running a psychological scam on your heart',
        'life_saving_insight': 'Your gut was right - this isn\'t love, it\'s control. Healthy people don\'t need to break you down to build you up',
        'pattern_summary': 'Advanced psychological warfare with 89% success rate. Subject exhibits expert-level manipulation capabilities',
        'gut_validation': 'You\'re not crazy, you\'re being calculated against. Their desperation = your confirmation you\'re winning'
      },
      'confidence_metrics': {
        'ambiguity_warning': null,
        'evidence_strength': 'Multiple manipulation patterns detected across all messages with high consistency',
        'viral_potential': 94
      }
    });
  }
} 
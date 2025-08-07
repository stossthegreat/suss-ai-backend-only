import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class StripeService {
  static const String _baseUrl = 'https://suss-ai-backend-only-production.up.railway.app';

  // Create a customer
  static Future<Map<String, dynamic>> createCustomer({
    required String email,
    String? name,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/stripe/create-customer'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'name': name,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create customer: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating customer: $e');
    }
  }

  // Create checkout session
  static Future<Map<String, dynamic>> createCheckoutSession({
    required String customerId,
    required String priceId,
    String? successUrl,
    String? cancelUrl,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/stripe/create-checkout-session'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'customerId': customerId,
          'priceId': priceId,
          'successUrl': successUrl ?? 'https://your-app.com/success',
          'cancelUrl': cancelUrl ?? 'https://your-app.com/cancel',
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create checkout session: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating checkout session: $e');
    }
  }

  // Get subscription details
  static Future<Map<String, dynamic>> getSubscription({
    required String subscriptionId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/v1/stripe/subscription/$subscriptionId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get subscription: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting subscription: $e');
    }
  }

  // Cancel subscription
  static Future<Map<String, dynamic>> cancelSubscription({
    required String subscriptionId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/api/v1/stripe/subscription/$subscriptionId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to cancel subscription: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error canceling subscription: $e');
    }
  }
} 
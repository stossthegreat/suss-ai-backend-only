import { Request, Response } from 'express';
import { StripeService } from '../services/stripeService';

export class StripeController {
  // Create checkout session
  static async createCheckoutSession(req: Request, res: Response) {
    try {
      const { customerId, priceId, successUrl, cancelUrl } = req.body;

      if (!customerId || !priceId) {
        return res.status(400).json({
          success: false,
          error: 'customerId and priceId are required'
        });
      }

      const session = await StripeService.createCheckoutSession(
        customerId,
        priceId,
        successUrl || `${process.env.FRONTEND_URL}/success`,
        cancelUrl || `${process.env.FRONTEND_URL}/cancel`
      );

      res.json({
        success: true,
        sessionId: session.id,
        url: session.url
      });
    } catch (error) {
      console.error('Error creating checkout session:', error);
      res.status(500).json({
        success: false,
        error: 'Failed to create checkout session'
      });
    }
  }

  // Create customer
  static async createCustomer(req: Request, res: Response) {
    try {
      const { email, name } = req.body;

      if (!email) {
        return res.status(400).json({
          success: false,
          error: 'email is required'
        });
      }

      const customer = await StripeService.createCustomer(email, name);

      res.json({
        success: true,
        customerId: customer.id,
        customer: {
          id: customer.id,
          email: customer.email,
          name: customer.name
        }
      });
    } catch (error) {
      console.error('Error creating customer:', error);
      res.status(500).json({
        success: false,
        error: 'Failed to create customer'
      });
    }
  }

  // Get subscription details
  static async getSubscription(req: Request, res: Response) {
    try {
      const { subscriptionId } = req.params;

      if (!subscriptionId) {
        return res.status(400).json({
          success: false,
          error: 'subscriptionId is required'
        });
      }

      const subscription = await StripeService.getSubscription(subscriptionId);

      res.json({
        success: true,
        subscription: {
          id: subscription.id,
          status: subscription.status,
          current_period_end: subscription.current_period_end,
          cancel_at_period_end: subscription.cancel_at_period_end,
          items: subscription.items.data
        }
      });
    } catch (error) {
      console.error('Error getting subscription:', error);
      res.status(500).json({
        success: false,
        error: 'Failed to get subscription'
      });
    }
  }

  // Cancel subscription
  static async cancelSubscription(req: Request, res: Response) {
    try {
      const { subscriptionId } = req.params;

      if (!subscriptionId) {
        return res.status(400).json({
          success: false,
          error: 'subscriptionId is required'
        });
      }

      const subscription = await StripeService.cancelSubscription(subscriptionId);

      res.json({
        success: true,
        subscription: {
          id: subscription.id,
          status: subscription.status,
          canceled_at: subscription.canceled_at
        }
      });
    } catch (error) {
      console.error('Error canceling subscription:', error);
      res.status(500).json({
        success: false,
        error: 'Failed to cancel subscription'
      });
    }
  }

  // Webhook handler
  static async handleWebhook(req: Request, res: Response) {
    try {
      const signature = req.headers['stripe-signature'] as string;
      
      if (!signature) {
        return res.status(400).json({
          success: false,
          error: 'Missing stripe signature'
        });
      }

      const event = StripeService.verifyWebhookSignature(
        JSON.stringify(req.body),
        signature
      );

      // Handle different event types
      switch (event.type) {
        case 'customer.subscription.created':
          console.log('Subscription created:', event.data.object);
          break;
        case 'customer.subscription.updated':
          console.log('Subscription updated:', event.data.object);
          break;
        case 'customer.subscription.deleted':
          console.log('Subscription deleted:', event.data.object);
          break;
        case 'invoice.payment_succeeded':
          console.log('Payment succeeded:', event.data.object);
          break;
        case 'invoice.payment_failed':
          console.log('Payment failed:', event.data.object);
          break;
        default:
          console.log(`Unhandled event type: ${event.type}`);
      }

      res.json({ received: true });
    } catch (error) {
      console.error('Error handling webhook:', error);
      res.status(400).json({
        success: false,
        error: 'Webhook signature verification failed'
      });
    }
  }
} 
import { Request, Response } from 'express';
import { StripeService } from '../services/stripeService';

export class StripeController {
  
  // Create a new customer
  static async createCustomer(req: Request, res: Response) {
    try {
      const { email, name } = req.body;
      
      if (!email) {
        return res.status(400).json({ error: 'Email is required' });
      }
      
      const customer = await StripeService.createCustomer(email, name);
      res.json({ success: true, customer });
    } catch (error) {
      console.error('Error in createCustomer:', error);
      res.status(500).json({ error: 'Failed to create customer' });
    }
  }

  // Create a checkout session
  static async createCheckoutSession(req: Request, res: Response) {
    try {
      const { customerId, priceId, successUrl, cancelUrl } = req.body;
      
      if (!customerId || !priceId) {
        return res.status(400).json({ error: 'Customer ID and Price ID are required' });
      }
      
      const session = await StripeService.createCheckoutSession(
        customerId,
        priceId,
        successUrl || `${process.env.FRONTEND_URL}/success`,
        cancelUrl || `${process.env.FRONTEND_URL}/cancel`
      );
      
      res.json({ success: true, session });
    } catch (error) {
      console.error('Error in createCheckoutSession:', error);
      res.status(500).json({ error: 'Failed to create checkout session' });
    }
  }

  // Get subscription details
  static async getSubscription(req: Request, res: Response) {
    try {
      const { subscriptionId } = req.params;
      
      if (!subscriptionId) {
        return res.status(400).json({ error: 'Subscription ID is required' });
      }
      
      const subscription = await StripeService.getSubscription(subscriptionId);
      res.json({ success: true, subscription });
    } catch (error) {
      console.error('Error in getSubscription:', error);
      res.status(500).json({ error: 'Failed to retrieve subscription' });
    }
  }

  // Cancel subscription
  static async cancelSubscription(req: Request, res: Response) {
    try {
      const { subscriptionId } = req.params;
      
      if (!subscriptionId) {
        return res.status(400).json({ error: 'Subscription ID is required' });
      }
      
      const subscription = await StripeService.cancelSubscription(subscriptionId);
      res.json({ success: true, subscription });
    } catch (error) {
      console.error('Error in cancelSubscription:', error);
      res.status(500).json({ error: 'Failed to cancel subscription' });
    }
  }

  // Handle webhook events
  static async handleWebhook(req: Request, res: Response) {
    try {
      const sig = req.headers['stripe-signature'];
      const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET || '';
      
      if (!sig) {
        return res.status(400).json({ error: 'No signature provided' });
      }
      
      const stripe = require('stripe')(process.env['STRIPE_SECRET_KEY'] || '');
      
      let event;
      try {
        event = stripe.webhooks.constructEvent(req.body, sig, webhookSecret);
      } catch (err: any) {
        console.error('Webhook signature verification failed:', err.message);
        return res.status(400).json({ error: 'Invalid signature' });
      }
      
      const result = await StripeService.handleWebhook(event);
      res.json(result);
    } catch (error) {
      console.error('Error in handleWebhook:', error);
      res.status(500).json({ error: 'Failed to handle webhook' });
    }
  }

  // Get available products
  static async getProducts(req: Request, res: Response) {
    try {
      const products = await StripeService.getProducts();
      res.json({ success: true, products });
    } catch (error) {
      console.error('Error in getProducts:', error);
      res.status(500).json({ error: 'Failed to retrieve products' });
    }
  }
} 
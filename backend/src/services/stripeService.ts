import Stripe from 'stripe';
import dotenv from 'dotenv';

dotenv.config();

const stripe = new Stripe(process.env['STRIPE_SECRET_KEY']!, {
  apiVersion: '2025-07-30.basil',
});

export interface CreateCustomerRequest {
  email: string;
  name?: string;
}

export interface CreateCheckoutSessionRequest {
  customerId: string;
  priceId: string;
  successUrl: string;
  cancelUrl: string;
}

export interface SubscriptionData {
  id: string;
  status: string;
  currentPeriodEnd: number;
  cancelAtPeriodEnd: boolean;
}

export class StripeService {
  // Create a new customer
  static async createCustomer(data: CreateCustomerRequest): Promise<Stripe.Customer> {
    try {
      const customerData: Stripe.CustomerCreateParams = {
        email: data.email,
        metadata: {
          source: 'suss-ai-app',
        },
      };
      
      if (data.name) {
        customerData.name = data.name;
      }
      
      const customer = await stripe.customers.create(customerData);
      
      console.log('Created Stripe customer:', customer.id);
      return customer;
    } catch (error) {
      console.error('Error creating Stripe customer:', error);
      throw new Error('Failed to create customer');
    }
  }

  // Create a checkout session
  static async createCheckoutSession(data: CreateCheckoutSessionRequest): Promise<Stripe.Checkout.Session> {
    try {
      const session = await stripe.checkout.sessions.create({
        customer: data.customerId,
        payment_method_types: ['card'],
        line_items: [
          {
            price: data.priceId,
            quantity: 1,
          },
        ],
        mode: 'subscription',
        success_url: data.successUrl,
        cancel_url: data.cancelUrl,
        metadata: {
          source: 'suss-ai-app',
        },
      });
      
      console.log('Created Stripe checkout session:', session.id);
      return session;
    } catch (error) {
      console.error('Error creating Stripe checkout session:', error);
      throw new Error('Failed to create checkout session');
    }
  }

  // Get subscription details
  static async getSubscription(subscriptionId: string): Promise<SubscriptionData> {
    try {
      const subscription = await stripe.subscriptions.retrieve(subscriptionId);
      
      return {
        id: subscription.id,
        status: subscription.status,
        currentPeriodEnd: subscription.current_period_end,
        cancelAtPeriodEnd: subscription.cancel_at_period_end,
      };
    } catch (error) {
      console.error('Error retrieving subscription:', error);
      throw new Error('Failed to retrieve subscription');
    }
  }

  // Cancel subscription
  static async cancelSubscription(subscriptionId: string): Promise<SubscriptionData> {
    try {
      const subscription = await stripe.subscriptions.update(subscriptionId, {
        cancel_at_period_end: true,
      });
      
      return {
        id: subscription.id,
        status: subscription.status,
        currentPeriodEnd: subscription.current_period_end,
        cancelAtPeriodEnd: subscription.cancel_at_period_end,
      };
    } catch (error) {
      console.error('Error canceling subscription:', error);
      throw new Error('Failed to cancel subscription');
    }
  }

  // Handle webhook events
  static async handleWebhook(payload: string, signature: string): Promise<void> {
    try {
      const event = stripe.webhooks.constructEvent(
        payload,
        signature,
        process.env['STRIPE_WEBHOOK_SECRET']!
      );

      console.log('Received Stripe webhook event:', event.type);

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
          console.log('Unhandled event type:', event.type);
      }
    } catch (error) {
      console.error('Error handling webhook:', error);
      throw new Error('Invalid webhook signature');
    }
  }

  // Get available products/prices
  static async getProducts(): Promise<Stripe.Product[]> {
    try {
      const products = await stripe.products.list({
        active: true,
        expand: ['data.default_price'],
      });
      
      return products.data;
    } catch (error) {
      console.error('Error retrieving products:', error);
      throw new Error('Failed to retrieve products');
    }
  }
} 
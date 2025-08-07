import Stripe from 'stripe';

const stripe = new Stripe(process.env['STRIPE_SECRET_KEY'] || '', {
  apiVersion: '2024-06-20',
});

export class StripeService {
  
  // Create a new customer
  static async createCustomer(email: string, name?: string) {
    try {
      const customer = await stripe.customers.create({
        email,
        name,
        metadata: {
          source: 'suss-ai-app'
        }
      });
      return customer;
    } catch (error) {
      console.error('Error creating customer:', error);
      throw error;
    }
  }

  // Create a checkout session
  static async createCheckoutSession(customerId: string, priceId: string, successUrl: string, cancelUrl: string) {
    try {
      const session = await stripe.checkout.sessions.create({
        customer: customerId,
        payment_method_types: ['card'],
        line_items: [
          {
            price: priceId,
            quantity: 1,
          },
        ],
        mode: 'subscription',
        success_url: successUrl,
        cancel_url: cancelUrl,
        metadata: {
          source: 'suss-ai-app'
        }
      });
      return session;
    } catch (error) {
      console.error('Error creating checkout session:', error);
      throw error;
    }
  }

  // Get subscription details
  static async getSubscription(subscriptionId: string) {
    try {
      const subscription = await stripe.subscriptions.retrieve(subscriptionId);
      return subscription;
    } catch (error) {
      console.error('Error retrieving subscription:', error);
      throw error;
    }
  }

  // Cancel subscription
  static async cancelSubscription(subscriptionId: string) {
    try {
      const subscription = await stripe.subscriptions.cancel(subscriptionId);
      return subscription;
    } catch (error) {
      console.error('Error canceling subscription:', error);
      throw error;
    }
  }

  // Handle webhook events
  static async handleWebhook(event: Stripe.Event) {
    try {
      switch (event.type) {
        case 'customer.subscription.created':
          const subscriptionCreated = event.data.object as Stripe.Subscription;
          console.log('Subscription created:', subscriptionCreated.id);
          break;
        
        case 'customer.subscription.updated':
          const subscriptionUpdated = event.data.object as Stripe.Subscription;
          console.log('Subscription updated:', subscriptionUpdated.id);
          break;
        
        case 'customer.subscription.deleted':
          const subscriptionDeleted = event.data.object as Stripe.Subscription;
          console.log('Subscription deleted:', subscriptionDeleted.id);
          break;
        
        case 'invoice.payment_succeeded':
          const invoiceSucceeded = event.data.object as Stripe.Invoice;
          console.log('Payment succeeded for invoice:', invoiceSucceeded.id);
          break;
        
        case 'invoice.payment_failed':
          const invoiceFailed = event.data.object as Stripe.Invoice;
          console.log('Payment failed for invoice:', invoiceFailed.id);
          break;
        
        default:
          console.log(`Unhandled event type: ${event.type}`);
      }
      
      return { received: true };
    } catch (error) {
      console.error('Error handling webhook:', error);
      throw error;
    }
  }

  // Get available products
  static async getProducts() {
    try {
      const products = await stripe.products.list({
        active: true,
        expand: ['data.default_price']
      });
      return products;
    } catch (error) {
      console.error('Error retrieving products:', error);
      throw error;
    }
  }
} 
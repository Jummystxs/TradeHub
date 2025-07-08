# TradeHub

> A comprehensive wholesale and retail distribution management system built on Stacks blockchain

## Overview

TradeHub revolutionizes wholesale and retail operations by providing a transparent, secure, and efficient platform for suppliers and retailers to connect, manage inventory, and process orders. Built with Clarity smart contracts, it ensures trust and automation in the supply chain.

## Features

### For Suppliers
- **Registration System**: Simple onboarding with contact information and verification
- **Product Management**: Add products with detailed specifications, pricing, and inventory tracking
- **Order Management**: Real-time order processing and status updates
- **Rating System**: Build reputation through customer feedback
- **Inventory Control**: Automated stock management with minimum order requirements

### For Retailers
- **Tiered Membership**: Bronze, Silver, and Gold tiers with increasing discount rates
- **Smart Ordering**: Automated price calculations with tier-based discounts
- **Order History**: Complete transaction history and spending analytics
- **Bulk Purchasing**: Minimum order requirements for wholesale pricing
- **Status Tracking**: Real-time order status from placement to delivery

### Core Functionality
- **Multi-party Transactions**: Secure interactions between suppliers and retailers
- **Automated Pricing**: Dynamic pricing with tier-based discounts
- **Inventory Management**: Real-time stock updates and availability tracking
- **Order Processing**: Complete order lifecycle management
- **Analytics Dashboard**: Revenue tracking and performance metrics

## Technical Implementation

### Smart Contract Architecture
```clarity
;; Core entities
- Suppliers: Business registration and product management
- Retailers: Tiered membership with discount benefits
- Products: Comprehensive catalog with pricing and inventory
- Orders: Complete order lifecycle management
```

### Data Structures
- **Suppliers**: Name, contact, status, rating, product count
- **Retailers**: Name, tier, discount rate, order history
- **Products**: Detailed specs, pricing, inventory, categories
- **Orders**: Complete transaction records with status tracking

### Security Features
- Input validation for all parameters
- Proper error handling with descriptive error codes
- Access control with role-based permissions
- Emergency pause functionality for critical situations

## Getting Started

### Prerequisites
- Clarinet CLI installed
- Stacks wallet for testing
- Basic understanding of Clarity smart contracts

### Installation
```bash
git clone <repository-url>
cd tradehub
clarinet check
clarinet test
```

### Usage Examples

#### Register as Supplier
```clarity
(contract-call? .tradehub register-supplier "Fresh Produce Co" "contact@freshproduce.com")
```

#### Register as Retailer
```clarity
(contract-call? .tradehub register-retailer "Local Grocery" "silver")
```

#### Add Product
```clarity
(contract-call? .tradehub add-product "Organic Apples" "Fresh organic apples from local farms" u500 u750 u1000 u50 "fruits")
```

#### Place Order
```clarity
(contract-call? .tradehub place-order 'SP1234... u1 u100)
```

## Testing

Run the test suite:
```bash
clarinet test
```

The contract includes comprehensive tests for:
- Supplier and retailer registration
- Product management
- Order processing
- Pricing calculations
- Error handling scenarios

## API Reference

### Public Functions
- `register-supplier`: Register a new supplier
- `register-retailer`: Register a new retailer with tier
- `add-product`: Add product to supplier catalog
- `place-order`: Place order with automatic pricing
- `update-order-status`: Update order status (supplier only)
- `update-supplier-rating`: Update supplier rating (admin only)
- `emergency-pause`: Pause contract operations (admin only)

### Read-only Functions
- `get-supplier`: Retrieve supplier information
- `get-retailer`: Retrieve retailer information
- `get-product`: Retrieve product details
- `get-order`: Retrieve order information
- `get-contract-stats`: Get contract statistics
- `calculate-discounted-price`: Calculate tier-based pricing

## Error Codes

- `u100`: Owner only operation
- `u101`: Entity not found
- `u102`: Insufficient balance
- `u103`: Invalid amount
- `u104`: Invalid price
- `u105`: Entity already exists
- `u106`: Not approved/authorized
- `u107`: Invalid status
- `u108`: Invalid tier
- `u109`: Minimum order not met
- `u110`: Unauthorized operation
- `u111`: Invalid discount rate

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request


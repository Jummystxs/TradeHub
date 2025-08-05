# TradeHub

> A comprehensive wholesale and retail distribution management system built on Stacks blockchain with multi-currency support

## Overview

TradeHub revolutionizes wholesale and retail operations by providing a transparent, secure, and efficient platform for suppliers and retailers to connect, manage inventory, and process orders. Built with Clarity smart contracts, it ensures trust and automation in the supply chain with support for multiple cryptocurrencies and stablecoins.

## Features

### For Suppliers
- **Registration System**: Simple onboarding with contact information, verification, and currency preferences
- **Product Management**: Add products with detailed specifications, pricing, inventory tracking, and currency selection
- **Order Management**: Real-time order processing and status updates with multi-currency payment tracking
- **Rating System**: Build reputation through customer feedback
- **Inventory Control**: Automated stock management with minimum order requirements
- **Currency Flexibility**: Accept payments in multiple cryptocurrencies and stablecoins

### For Retailers
- **Tiered Membership**: Bronze, Silver, and Gold tiers with increasing discount rates
- **Smart Ordering**: Automated price calculations with tier-based discounts and currency conversion
- **Order History**: Complete transaction history and spending analytics across currencies
- **Bulk Purchasing**: Minimum order requirements for wholesale pricing
- **Status Tracking**: Real-time order status from placement to delivery
- **Multi-Currency Payments**: Pay in preferred cryptocurrency or stablecoin

### Core Functionality
- **Multi-Currency Support**: Native support for STX, USDC, USDT with automatic conversion
- **Multi-party Transactions**: Secure interactions between suppliers and retailers
- **Automated Pricing**: Dynamic pricing with tier-based discounts and currency conversion
- **Inventory Management**: Real-time stock updates and availability tracking
- **Order Processing**: Complete order lifecycle management with payment status tracking
- **Analytics Dashboard**: Revenue tracking and performance metrics across currencies
- **Exchange Rate Management**: Real-time currency conversion with oracle integration ready

## Multi-Currency Features

### Supported Currencies
- **STX**: Native Stacks token
- **USDC**: USD Coin stablecoin
- **USDT**: Tether stablecoin
- **Extensible**: Easy addition of new currencies by contract owner

### Currency Operations
- **Automatic Conversion**: Real-time conversion between supported currencies
- **Flexible Pricing**: Products can be priced in any supported currency
- **Payment Options**: Retailers can pay in their preferred currency
- **Exchange Rates**: Configurable exchange rates with precision handling
- **Currency Validation**: Comprehensive validation for all currency operations

## Technical Implementation

### Smart Contract Architecture
```clarity
;; Core entities with multi-currency support
- Suppliers: Business registration, product management, and currency preferences
- Retailers: Tiered membership with discount benefits and currency preferences
- Products: Comprehensive catalog with pricing, inventory, and currency selection
- Orders: Complete order lifecycle management with multi-currency payment tracking
- Currency Management: Exchange rates, conversion, and validation
```

### Data Structures
- **Suppliers**: Name, contact, status, rating, product count, currency preferences
- **Retailers**: Name, tier, discount rate, order history, preferred currency
- **Products**: Detailed specs, pricing, inventory, categories, currency
- **Orders**: Complete transaction records with status and payment tracking
- **Currency Rates**: Exchange rates for automatic conversion
- **Escrow Balances**: Multi-currency balance management

### Security Features
- Input validation for all parameters including currency validation
- Proper error handling with descriptive error codes
- Access control with role-based permissions
- Emergency pause functionality for critical situations
- Currency conversion validation and overflow protection
- Payment status tracking and validation

## Getting Started

### Prerequisites
- Clarinet CLI installed
- Stacks wallet for testing
- Basic understanding of Clarity smart contracts
- Understanding of multi-currency operations

### Installation
```bash
git clone <repository-url>
cd tradehub
clarinet check
clarinet test
```

### Usage Examples

#### Register as Supplier with Currency Preferences
```clarity
(contract-call? .tradehub register-supplier 
  "Fresh Produce Co" 
  "contact@freshproduce.com"
  "USDC"
  (list "USDC" "STX" "USDT")
)
```

#### Register as Retailer with Preferred Currency
```clarity
(contract-call? .tradehub register-retailer 
  "Local Grocery" 
  "silver"
  "USDT"
)
```

#### Add Product with Currency
```clarity
(contract-call? .tradehub add-product 
  "Organic Apples" 
  "Fresh organic apples from local farms" 
  u500 
  u750 
  u1000 
  u50 
  "fruits"
  "USDC"
)
```

#### Place Order with Currency Selection
```clarity
(contract-call? .tradehub place-order 
  'SP1234... 
  u1 
  u100
  "STX"
)
```

#### Add New Supported Currency (Owner Only)
```clarity
(contract-call? .tradehub add-supported-currency "BTC" u50000000)
```

#### Update Currency Exchange Rate (Owner Only)
```clarity
(contract-call? .tradehub update-currency-rate "USDC" u1000000)
```

## Testing

Run the test suite:
```bash
clarinet test
```

The contract includes comprehensive tests for:
- Supplier and retailer registration with currency preferences
- Product management with multi-currency pricing
- Order processing with currency conversion
- Pricing calculations across currencies
- Currency validation and conversion
- Error handling scenarios for currency operations

## API Reference

### Public Functions

#### Core Functions
- `register-supplier`: Register a new supplier with currency preferences
- `register-retailer`: Register a new retailer with preferred currency
- `add-product`: Add product to supplier catalog with currency
- `place-order`: Place order with automatic currency conversion
- `update-order-status`: Update order status (supplier only)
- `update-payment-status`: Update payment status (supplier only)

#### Currency Management (Owner Only)
- `add-supported-currency`: Add new supported currency with exchange rate
- `update-currency-rate`: Update exchange rate for existing currency
- `emergency-pause`: Pause contract operations
- `resume-contract`: Resume contract operations

#### Rating System
- `update-supplier-rating`: Update supplier rating (admin only)

### Read-only Functions

#### Data Retrieval
- `get-supplier`: Retrieve supplier information with currency preferences
- `get-retailer`: Retrieve retailer information with preferred currency
- `get-product`: Retrieve product details with currency
- `get-order`: Retrieve order information with payment details
- `get-contract-stats`: Get contract statistics including supported currencies

#### Currency Functions
- `get-supported-currencies`: List all supported currencies
- `get-currency-rate`: Get exchange rate for specific currency
- `get-escrow-balance`: Get user's escrow balance in specific currency
- `convert-currency`: Convert amount between currencies
- `calculate-discounted-price`: Calculate tier-based pricing

## Error Codes

### Core Error Codes
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
- `u112`: Invalid string
- `u113`: Contract paused
- `u114`: Invalid principal

### Multi-Currency Error Codes
- `u115`: Invalid currency format
- `u116`: Currency not supported
- `u117`: Payment failed

## Multi-Currency Implementation Details

### Exchange Rate System
- Exchange rates are stored relative to STX with 6-decimal precision
- Rates are multiplied by 1,000,000 for precision (e.g., 1 USDC = 1,000,000 units)
- Automatic conversion between any supported currency pairs
- Owner can update rates to reflect market conditions

### Currency Validation
- All currency strings are validated against supported currencies list
- Maximum currency string length of 10 characters
- Case-sensitive currency matching for security
- Comprehensive validation in all currency-related operations

### Payment Flow
1. Retailer places order specifying payment currency
2. System calculates price in product's native currency
3. Applies tier-based discount
4. Converts final price to payment currency if different
5. Creates order with payment tracking
6. Supplier can update payment status independently

### Escrow System (Future Enhancement)
- Framework in place for escrow balance tracking
- Multi-currency balance management
- Ready for integration with payment processors
- Secure fund holding during order processing

## Deployment Considerations

### Production Deployment
- Configure initial exchange rates before deployment
- Set up oracle integration for real-time rates (recommended)
- Test all currency combinations thoroughly
- Implement monitoring for exchange rate accuracy

### Security Considerations
- All currency operations include overflow protection
- Comprehensive input validation for amounts and currencies
- Rate manipulation protection through owner-only updates
- Emergency pause functionality for security incidents

## Future Enhancements

### Planned Features
- Oracle integration for real-time exchange rates
- Automated market makers (AMM) integration
- Cross-chain currency support
- Advanced escrow and payment processing
- Liquidity pool integration
- DeFi yield farming for escrow funds

### Integration Possibilities
- DEX integration for automatic currency swapping
- Stablecoin yield farming during escrow periods
- Cross-chain bridges for additional currency support
- Payment processor integration (Stripe, PayPal)
- Mobile wallet integration

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/multi-currency-enhancement`)
3. Commit your changes (`git commit -m 'Add currency validation improvements'`)
4. Push to the branch (`git push origin feature/multi-currency-enhancement`)
5. Create a Pull Request

### Development Guidelines
- All currency operations must include comprehensive validation
- Maintain precision in exchange rate calculations
- Include tests for all currency combinations
- Document any new error codes
- Follow existing code style and security patterns

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the GitHub repository
- Join our Discord community
- Check the documentation wiki
- Review existing test cases for usage examples

## Changelog

### v2.0.0 - Multi-Currency Support
- Added support for STX, USDC, and USDT
- Implemented automatic currency conversion
- Added exchange rate management system
- Enhanced order processing with payment tracking
- Improved error handling for currency operations
- Added comprehensive currency validation
- Implemented escrow balance framework

### v1.0.0 - Initial Release
- Core wholesale/retail distribution system
- Supplier and retailer management
- Product catalog and inventory tracking
- Order processing and status management
- Tiered discount system
- Security hardening and validation
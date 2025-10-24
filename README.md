# TradeHub

> A comprehensive wholesale and retail distribution management system built on Stacks blockchain with multi-currency support, automated escrow, and tokenized loyalty rewards

## Overview

TradeHub revolutionizes wholesale and retail operations by providing a transparent, secure, and efficient platform for suppliers and retailers to connect, manage inventory, and process orders. Built with Clarity smart contracts, it ensures trust and automation in the supply chain with support for multiple cryptocurrencies, stablecoins, automated escrow for secure payment processing, and a comprehensive loyalty rewards program to incentivize frequent retailers.

## Features

### For Suppliers
- **Registration System**: Simple onboarding with contact information, verification, and currency preferences
- **Product Management**: Add products with detailed specifications, pricing, inventory tracking, and currency selection
- **Order Management**: Real-time order processing and status updates with multi-currency payment tracking
- **Rating System**: Build reputation through customer feedback
- **Inventory Control**: Automated stock management with minimum order requirements
- **Currency Flexibility**: Accept payments in multiple cryptocurrencies and stablecoins
- **Escrow Protection**: Secure payment processing with automated escrow release

### For Retailers
- **Tiered Membership**: Bronze, Silver, and Gold tiers with increasing discount rates
- **Smart Ordering**: Automated price calculations with tier-based discounts and currency conversion
- **Order History**: Complete transaction history and spending analytics across currencies
- **Bulk Purchasing**: Minimum order requirements for wholesale pricing
- **Status Tracking**: Real-time order status from placement to delivery
- **Multi-Currency Payments**: Pay in preferred cryptocurrency or stablecoin
- **Payment Security**: Automated escrow protection for all transactions
- **Loyalty Rewards**: Earn tokenized points on every purchase
- **Points Redemption**: Convert points to discounts on future orders
- **Automatic Tier Upgrades**: Progress through tiers based on accumulated points
- **Points Transfer**: Transfer points to other retailers

### Core Functionality
- **Multi-Currency Support**: Native support for STX, USDC, USDT with automatic conversion
- **Automated Escrow System**: Secure payment processing with dispute resolution
- **Loyalty Rewards Program**: Tokenized points system with earning, redemption, and transfer
- **Multi-party Transactions**: Secure interactions between suppliers and retailers
- **Automated Pricing**: Dynamic pricing with tier-based discounts and currency conversion
- **Inventory Management**: Real-time stock updates and availability tracking
- **Order Processing**: Complete order lifecycle management with payment status tracking
- **Analytics Dashboard**: Revenue tracking and performance metrics across currencies
- **Exchange Rate Management**: Real-time currency conversion with oracle integration ready
- **Dispute Resolution**: Built-in dispute handling with timeout mechanisms
- **Tier Progression**: Automatic tier upgrades based on loyalty points

## Loyalty Rewards Program

### Key Features
- **Points Earning**: Retailers automatically earn points on every purchase
- **Configurable Rates**: Owner-controlled earning and redemption rates
- **Points Redemption**: Convert points to discounts on orders
- **Tier Progression**: Automatic tier upgrades based on accumulated points
- **Points Transfer**: Transfer points between retailers
- **Bonus Points**: Promotional events and special point awards
- **Points Expiration**: Optional expiration system with configurable timeframes
- **Transaction History**: Complete audit trail of all points activities

### Earning Points
- Points are automatically awarded when orders are placed
- Default: 10 points earned per currency unit spent (configurable)
- Points accumulate in retailer's loyalty account
- All points transactions are recorded with timestamps

### Redeeming Points
- Convert points to discount on order payments
- Default: 100 points = 1 unit discount (configurable)
- Points are deducted from available balance
- Redemption recorded in transaction history

### Tier Progression
- **Bronze Tier**: 0+ points, 5% discount
- **Silver Tier**: 1,000+ points, 10% discount
- **Gold Tier**: 5,000+ points, 15% discount
- Automatic tier upgrades based on total accumulated points
- Tier upgrades increase discount rates on all future orders

### Points Management
- **Transfer Points**: Share points with other retailers
- **Bonus Points**: Contract owner can award promotional points
- **Expiration**: Optional points expiration with configurable timeframe
- **Balance Tracking**: Real-time visibility of available, redeemed, and expired points

## Automated Escrow System

### Key Features
- **Secure Payment Holding**: Funds are held in escrow until order completion
- **Automatic Release**: Escrow releases payment when both parties are satisfied
- **Dispute Resolution**: Built-in dispute mechanism with admin arbitration
- **Timeout Protection**: Automatic refund after escrow expiration (7 days)
- **Multi-Currency Support**: Escrow works with all supported currencies
- **Balance Management**: Track escrow balances across multiple currencies

### Escrow Workflow
1. **Order Placement**: Retailer places order, funds automatically move to escrow
2. **Order Processing**: Supplier fulfills order while payment is secured
3. **Order Completion**: Either party can release escrow upon satisfactory delivery
4. **Dispute Handling**: If issues arise, either party can raise a dispute
5. **Resolution**: Admin resolves disputes or escrow auto-expires for refund

### Escrow Status Types
- **Active**: Escrow is holding funds, awaiting release or dispute
- **Released**: Funds have been released to the supplier
- **Disputed**: A dispute has been raised, awaiting resolution
- **Resolved**: Dispute has been resolved by admin
- **Expired**: Escrow timed out, funds returned to buyer

### Security Features
- **Time-based Expiration**: Automatic refund after 7 days if not released
- **Dispute Timeout**: 24-hour window for dispute resolution
- **Admin Arbitration**: Contract owner can resolve disputes fairly
- **Balance Tracking**: Comprehensive tracking of all escrow balances
- **Payment Protection**: Funds are secure until successful delivery

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
- **Escrow Support**: Multi-currency escrow with automatic conversion

## Technical Implementation

### Smart Contract Architecture
```clarity
;; Core entities with multi-currency support, escrow, and loyalty
- Suppliers: Business registration, product management, and currency preferences
- Retailers: Tiered membership with discount benefits and currency preferences
- Products: Comprehensive catalog with pricing, inventory, and currency selection
- Orders: Complete order lifecycle management with multi-currency payment tracking
- Escrows: Automated escrow system for secure payment processing
- Loyalty Points: Tokenized rewards with earning, redemption, and transfer
- Points Transactions: Complete history of all loyalty activities
- Currency Management: Exchange rates, conversion, and validation
```

### Data Structures
- **Suppliers**: Name, contact, status, rating, product count, currency preferences
- **Retailers**: Name, tier, discount rate, order history, preferred currency
- **Products**: Detailed specs, pricing, inventory, categories, currency
- **Orders**: Complete transaction records with status, payment tracking, escrow ID, and points earned
- **Escrows**: Secure payment holding with status, timeouts, and dispute management
- **Loyalty Points**: Total points, available points, redeemed points, tier, last activity
- **Points Transactions**: Type, amount, order reference, timestamps, expiration
- **Currency Rates**: Exchange rates for automatic conversion
- **Escrow Balances**: Multi-currency balance management with security

### Security Features
- Input validation for all parameters including currency, escrow, and loyalty validation
- Proper error handling with descriptive error codes
- Access control with role-based permissions
- Emergency pause functionality for critical situations
- Currency conversion validation and overflow protection
- Payment status tracking and validation
- Escrow timeout and dispute protection
- Comprehensive balance management and security
- Loyalty points transfer validation and fraud prevention

## Getting Started

### Prerequisites
- Clarinet CLI installed
- Stacks wallet for testing
- Basic understanding of Clarity smart contracts
- Understanding of multi-currency operations
- Knowledge of escrow systems
- Familiarity with loyalty rewards programs

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

#### Place Order with Automatic Escrow and Loyalty Points
```clarity
(contract-call? .tradehub place-order 
  'SP1234... 
  u1 
  u100
  "STX"
)
;; Automatically creates escrow and awards loyalty points
```

#### Check Loyalty Points Balance
```clarity
(contract-call? .tradehub get-points-balance tx-sender)
```

#### Redeem Points for Discount
```clarity
(contract-call? .tradehub redeem-points u500 u1)
;; Redeem 500 points for discount on order #1
```

#### Transfer Points to Another Retailer
```clarity
(contract-call? .tradehub transfer-points 'SP5678... u200)
;; Transfer 200 points to another retailer
```

#### Award Bonus Points (Owner Only)
```clarity
(contract-call? .tradehub award-bonus-points 
  'SP1234... 
  u1000 
  "Holiday promotion bonus"
)
```

#### Configure Loyalty Program (Owner Only)
```clarity
(contract-call? .tradehub configure-loyalty-program 
  true    ;; enabled
  u10     ;; earn rate (10 points per unit)
  u100    ;; redemption rate (100 points = 1 unit)
  false   ;; expiry enabled
  u144000 ;; expiry period in blocks
)
```

#### Deposit Funds to Escrow Balance
```clarity
(contract-call? .tradehub deposit-to-escrow "USDC" u1000000)
```

#### Release Escrow Payment
```clarity
(contract-call? .tradehub release-escrow u1)
```

#### Raise Dispute on Escrow
```clarity
(contract-call? .tradehub dispute-escrow u1)
```

#### Handle Expired Escrow (Auto-refund)
```clarity
(contract-call? .tradehub handle-expired-escrow u1)
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
- Order processing with currency conversion and escrow creation
- Escrow lifecycle management (creation, release, disputes, expiration)
- Loyalty points earning on purchases
- Points redemption with discount application
- Tier progression and automatic upgrades
- Points transfer between retailers
- Bonus points awarding
- Loyalty configuration management
- Pricing calculations across currencies
- Currency validation and conversion
- Dispute resolution and timeout handling
- Error handling scenarios for all operations

## API Reference

### Public Functions

#### Core Functions
- `register-supplier`: Register a new supplier with currency preferences
- `register-retailer`: Register a new retailer with preferred currency (auto-enrolls in loyalty)
- `add-product`: Add product to supplier catalog with currency
- `place-order`: Place order with automatic escrow creation, currency conversion, and loyalty points
- `update-order-status`: Update order status (supplier only)
- `update-payment-status`: Update payment status (supplier only)

#### Loyalty Rewards Functions
- `redeem-points`: Exchange loyalty points for order discounts
- `transfer-points`: Transfer points to another retailer
- `check-and-upgrade-tier`: Process automatic tier upgrades based on points
- `award-bonus-points`: Award promotional bonus points (owner only)
- `configure-loyalty-program`: Configure loyalty program settings (owner only)

#### Escrow Management
- `deposit-to-escrow`: Deposit funds to escrow balance
- `release-escrow`: Release escrow payment to supplier (buyer/seller)
- `dispute-escrow`: Raise dispute on active escrow (buyer/seller)
- `resolve-dispute`: Resolve disputed escrow (owner only)
- `handle-expired-escrow`: Process expired escrow for auto-refund (anyone)

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
- `get-order`: Retrieve order information with payment details and points earned
- `get-escrow`: Retrieve escrow information with status and timeouts
- `get-escrow-by-order`: Get escrow information for specific order
- `get-contract-stats`: Get contract statistics including supported currencies, escrow count, and loyalty transactions

#### Loyalty Functions
- `get-loyalty-points`: Get complete loyalty data for retailer
- `get-points-balance`: Get current available points balance
- `get-points-transaction`: Get specific points transaction details
- `get-loyalty-config`: View loyalty program configuration
- `get-redeemable-discount`: Calculate discount amount from points
- `get-points-to-next-tier`: Calculate points needed for next tier

#### Currency Functions
- `get-supported-currencies`: List all supported currencies
- `get-currency-rate`: Get exchange rate for specific currency
- `get-escrow-balance`: Get user's escrow balance in specific currency
- `convert-currency`: Convert amount between currencies
- `calculate-discounted-price`: Calculate tier-based pricing

#### Escrow Functions
- `is-escrow-expired`: Check if escrow has expired
- `is-dispute-expired`: Check if dispute resolution period has expired

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

### Escrow Error Codes
- `u118`: Escrow not found
- `u119`: Escrow already released
- `u120`: Invalid escrow status
- `u121`: Escrow expired
- `u122`: Escrow not expired

### Loyalty Rewards Error Codes
- `u123`: Insufficient points for redemption
- `u124`: Invalid points amount
- `u125`: Points transfer failed
- `u126`: Points expired
- `u127`: Invalid tier threshold

## Loyalty Rewards Implementation Details

### Points Calculation
- Points earned = (Order Amount × Earn Rate) / 100
- Discount from points = Points / Redemption Rate
- Default earn rate: 10 points per currency unit
- Default redemption rate: 100 points = 1 unit discount

### Tier Thresholds
- **Bronze**: 0 - 999 points (5% discount)
- **Silver**: 1,000 - 4,999 points (10% discount)
- **Gold**: 5,000+ points (15% discount)

### Points Lifecycle
1. **Earning**: Points automatically awarded on order placement
2. **Accumulation**: Points added to available balance
3. **Redemption**: Points converted to discounts and deducted from balance
4. **Transfer**: Points moved between retailer accounts
5. **Expiration**: Optional expiration after configurable period
6. **Bonus**: Owner can award promotional points

### Transaction Types
- `earned`: Points earned from purchase
- `redeemed`: Points used for discount
- `transferred-in`: Points received from another retailer
- `transferred-out`: Points sent to another retailer
- `expired`: Points expired after timeout
- `bonus`: Promotional bonus points awarded

### Security Features
- Comprehensive validation of all points operations
- Balance checking before redemption or transfer
- Transaction history for complete audit trail
- Owner-only configuration changes
- Fraud prevention through transfer validation
- Proper error handling for all edge cases

## Escrow Implementation Details

### Timeout System
- **Escrow Timeout**: 1008 blocks (~7 days) for automatic expiration
- **Dispute Timeout**: 144 blocks (~1 day) for dispute resolution
- **Block Height Tracking**: Uses `stacks-block-height` for precise timing
- **Automatic Refund**: Expired escrows automatically refund to buyer

### Security Mechanisms
- **Access Control**: Only authorized parties can release or dispute escrow
- **Status Validation**: Comprehensive validation of escrow state transitions
- **Balance Protection**: Secure tracking of all escrow balances
- **Dispute Protection**: Fair dispute resolution with admin oversight
- **Timeout Protection**: Automatic refund prevents indefinite fund locking

### Integration with Orders
- **Automatic Creation**: Escrow is automatically created when placing orders
- **Order Linking**: Each order is linked to its corresponding escrow
- **Status Synchronization**: Order payment status reflects escrow state
- **Complete Tracking**: Full audit trail of all escrow transactions

## Multi-Currency Implementation Details

### Exchange Rate System
- Exchange rates are stored relative to STX with 6-decimal precision
- Rates are multiplied by 1,000,000 for precision (e.g., 1 USDC = 1,000,000 units)
- Automatic conversion between any supported currency pairs
- Owner can update rates to reflect market conditions
- Escrow system supports all currency conversions

### Currency Validation
- All currency strings are validated against supported currencies list
- Maximum currency string length of 10 characters
- Case-sensitive currency matching for security
- Comprehensive validation in all currency-related operations
- Escrow operations include full currency validation

### Payment Flow with Escrow and Loyalty
1. Retailer places order specifying payment currency
2. System calculates price in product's native currency
3. Applies tier-based discount
4. Converts final price to payment currency if different
5. Creates escrow with payment amount in chosen currency
6. Awards loyalty points based on final price
7. Creates order with escrow reference and payment tracking
8. Funds are held securely until release or dispute resolution
9. Supplier can track payment status through escrow system

### Escrow Balance Management
- Multi-currency balance tracking for all users
- Secure fund holding during order processing
- Automatic balance updates for deposits, releases, and refunds
- Protection against double-spending and unauthorized access
- Complete audit trail of all balance changes

## Deployment Considerations

### Production Deployment
- Configure initial exchange rates before deployment
- Set up oracle integration for real-time rates (recommended)
- Configure loyalty program parameters (earn rate, redemption rate)
- Set tier thresholds based on business goals
- Test all currency combinations thoroughly
- Implement monitoring for exchange rate accuracy
- Configure escrow timeout periods appropriately
- Set up dispute resolution procedures
- Monitor loyalty points issuance and redemption

### Security Considerations
- All currency operations include overflow protection
- Comprehensive input validation for amounts and currencies
- Rate manipulation protection through owner-only updates
- Emergency pause functionality for security incidents
- Escrow timeout protection against fund locking
- Dispute resolution with proper access controls
- Balance tracking security and validation
- Loyalty points fraud prevention
- Points transfer validation
- Redemption limit checks

## Future Enhancements

### Planned Features
- Oracle integration for real-time exchange rates
- Automated market makers (AMM) integration
- Cross-chain currency support
- Advanced escrow features (partial releases, multi-signature)
- Liquidity pool integration for escrow funds
- DeFi yield farming for idle escrow balances
- Enhanced dispute resolution with evidence submission
- Reputation-based escrow terms (shorter timeouts for trusted users)
- NFT-based loyalty badges for tier achievements
- Points marketplace for peer-to-peer trading
- Seasonal loyalty multipliers and campaigns
- Referral bonus points program
- Points staking for additional benefits

### Integration Possibilities
- DEX integration for automatic currency swapping
- Stablecoin yield farming during escrow periods
- Cross-chain bridges for additional currency support
- Payment processor integration (Stripe, PayPal)
- Mobile wallet integration with escrow notifications
- Insurance integration for high-value escrows
- Multi-signature wallets for large transactions
- Automated arbitration services
- Gamification elements for loyalty program
- Social features for points leaderboards
- Integration with external loyalty networks

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/loyalty-enhancement`)
3. Commit your changes (`git commit -m 'Add loyalty points staking'`)
4. Push to the branch (`git push origin feature/loyalty-enhancement`)
5. Create a Pull Request

### Development Guidelines
- All currency operations must include comprehensive validation
- Maintain precision in exchange rate calculations
- Include tests for all currency combinations, escrow scenarios, and loyalty operations
- Document any new error codes
- Follow existing code style and security patterns
- Test escrow timeout and dispute scenarios thoroughly
- Ensure proper access control for all escrow and loyalty functions
- Validate all loyalty points operations
- Test tier progression logic thoroughly

## Changelog

### v4.0.0 - Loyalty Rewards Program
- **NEW**: Implemented tokenized loyalty rewards system
- **NEW**: Added points earning on every purchase
- **NEW**: Built points redemption for order discounts
- **NEW**: Automatic tier progression based on accumulated points
- **NEW**: Points transfer functionality between retailers
- **NEW**: Bonus points system for promotional events
- **NEW**: Complete points transaction history
- **NEW**: Configurable loyalty program parameters
- **NEW**: Points expiration system (optional)
- **ENHANCED**: Order system now tracks points earned
- **ENHANCED**: Retailer registration auto-enrolls in loyalty program
- **ENHANCED**: Tier system now integrates with loyalty points
- **ADDED**: New error codes for loyalty-related operations
- **ADDED**: Comprehensive loyalty read-only functions
- **IMPROVED**: Tier upgrades now automatic based on points

### v3.0.0 - Automated Escrow System
- **NEW**: Implemented automated escrow for secure payment processing
- **NEW**: Added escrow creation, release, and dispute functionality
- **NEW**: Integrated timeout-based auto-refund system (7-day expiration)
- **NEW**: Built-in dispute resolution with admin arbitration
- **NEW**: Multi-currency escrow balance management
- **NEW**: Comprehensive escrow status tracking and validation
- **ENHANCED**: Order system now automatically creates escrow for each transaction
- **ENHANCED**: Payment status synchronization with escrow state
- **ENHANCED**: Security hardening with escrow-specific access controls
- **ADDED**: New error codes for escrow-related operations
- **ADDED**: Escrow-specific read-only functions for status checking
- **IMPROVED**: Balance management system for secure fund tracking

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
;; TradeHub - Wholesale and Retail Distribution Management System
;; A comprehensive contract for managing wholesale/retail operations with supplier networks
;; SECURITY-HARDENED VERSION WITH MULTI-CURRENCY SUPPORT, AUTOMATED ESCROW, AND LOYALTY REWARDS

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-insufficient-balance (err u102))
(define-constant err-invalid-amount (err u103))
(define-constant err-invalid-price (err u104))
(define-constant err-already-exists (err u105))
(define-constant err-not-approved (err u106))
(define-constant err-invalid-status (err u107))
(define-constant err-invalid-tier (err u108))
(define-constant err-minimum-order (err u109))
(define-constant err-unauthorized (err u110))
(define-constant err-invalid-discount (err u111))
(define-constant err-invalid-string (err u112))
(define-constant err-contract-paused (err u113))
(define-constant err-invalid-principal (err u114))
(define-constant err-invalid-currency (err u115))
(define-constant err-currency-not-supported (err u116))
(define-constant err-payment-failed (err u117))
(define-constant err-escrow-not-found (err u118))
(define-constant err-escrow-already-released (err u119))
(define-constant err-invalid-escrow-status (err u120))
(define-constant err-escrow-expired (err u121))
(define-constant err-escrow-not-expired (err u122))
(define-constant err-insufficient-points (err u123))
(define-constant err-invalid-points (err u124))
(define-constant err-transfer-failed (err u125))
(define-constant err-points-expired (err u126))
(define-constant err-invalid-threshold (err u127))

;; Currency Constants
(define-constant currency-stx "STX")
(define-constant currency-usdc "USDC")
(define-constant currency-usdt "USDT")

;; Escrow Constants
(define-constant escrow-timeout-blocks u1008) ;; ~7 days (assuming 10 min blocks)
(define-constant dispute-timeout-blocks u144)  ;; ~1 day for dispute resolution

;; Loyalty Constants
(define-constant points-per-currency-unit u10) ;; Default: 10 points per unit spent
(define-constant points-to-discount-rate u100) ;; 100 points = 1 unit discount
(define-constant bronze-threshold u0)
(define-constant silver-threshold u1000)
(define-constant gold-threshold u5000)
(define-constant points-expiry-blocks u144000) ;; ~1000 days

;; Security Constants
(define-constant max-string-length u100)
(define-constant max-description-length u500)
(define-constant max-price u1000000000) ;; 1 billion max price
(define-constant max-quantity u1000000)
(define-constant max-rating u5)
(define-constant min-rating u1)
(define-constant max-points u1000000000)

;; Data Variables
(define-data-var contract-active bool true)
(define-data-var order-counter uint u0)
(define-data-var escrow-counter uint u0)
(define-data-var total-revenue uint u0)
(define-data-var points-transaction-counter uint u0)

;; Currency Support Variables
(define-data-var supported-currencies (list 10 (string-ascii 10)) (list "STX" "USDC" "USDT"))

;; Loyalty Configuration
(define-data-var loyalty-enabled bool true)
(define-data-var points-earn-rate uint points-per-currency-unit)
(define-data-var points-redemption-rate uint points-to-discount-rate)
(define-data-var points-expiry-enabled bool false)
(define-data-var points-expiry-period uint points-expiry-blocks)

;; Data Maps
(define-map suppliers
  principal
  {
    name: (string-ascii 50),
    contact: (string-ascii 100),
    status: (string-ascii 20),
    rating: uint,
    products-count: uint,
    joined-at: uint,
    preferred-currency: (string-ascii 10),
    accepted-currencies: (list 10 (string-ascii 10))
  }
)

(define-map products
  {supplier: principal, product-id: uint}
  {
    name: (string-ascii 100),
    description: (string-ascii 500),
    wholesale-price: uint,
    retail-price: uint,
    quantity: uint,
    minimum-order: uint,
    category: (string-ascii 50),
    status: (string-ascii 20),
    created-at: uint,
    currency: (string-ascii 10)
  }
)

(define-map retailers
  principal
  {
    name: (string-ascii 50),
    tier: (string-ascii 20),
    discount-rate: uint,
    total-orders: uint,
    total-spent: uint,
    status: (string-ascii 20),
    joined-at: uint,
    preferred-currency: (string-ascii 10)
  }
)

(define-map orders
  uint
  {
    retailer: principal,
    supplier: principal,
    product-id: uint,
    quantity: uint,
    total-price: uint,
    status: (string-ascii 20),
    created-at: uint,
    updated-at: uint,
    currency: (string-ascii 10),
    payment-status: (string-ascii 20),
    escrow-id: (optional uint),
    points-earned: uint
  }
)

(define-map escrows
  uint
  {
    order-id: uint,
    buyer: principal,
    seller: principal,
    amount: uint,
    currency: (string-ascii 10),
    status: (string-ascii 20),
    created-at: uint,
    expires-at: uint,
    released-at: (optional uint),
    dispute-raised: bool,
    dispute-deadline: (optional uint)
  }
)

(define-map loyalty-points
  principal
  {
    total-points: uint,
    available-points: uint,
    redeemed-points: uint,
    expired-points: uint,
    lifetime-earned: uint,
    current-tier: (string-ascii 20),
    last-activity: uint,
    tier-upgraded-at: uint
  }
)

(define-map points-transactions
  uint
  {
    retailer: principal,
    transaction-type: (string-ascii 20),
    points: uint,
    order-id: (optional uint),
    created-at: uint,
    expires-at: (optional uint),
    description: (string-ascii 100)
  }
)

(define-map supplier-product-count principal uint)

;; Currency exchange rates (simplified - in production would integrate with oracle)
(define-map currency-rates (string-ascii 10) uint) ;; Rate relative to STX (multiplied by 1000000 for precision)

;; Currency balances for escrow
(define-map escrow-balances {user: principal, currency: (string-ascii 10)} uint)

;; Escrow token holdings (actual funds held)
(define-map escrow-holdings {escrow-id: uint} uint)

;; Read-only functions
(define-read-only (get-supplier (supplier principal))
  (map-get? suppliers supplier)
)

(define-read-only (get-retailer (retailer principal))
  (map-get? retailers retailer)
)

(define-read-only (get-product (supplier principal) (product-id uint))
  (if (and (is-valid-principal supplier) (is-valid-product-id product-id))
    (map-get? products {supplier: supplier, product-id: product-id})
    none
  )
)

(define-read-only (get-order (order-id uint))
  (if (is-valid-order-id order-id)
    (map-get? orders order-id)
    none
  )
)

(define-read-only (get-escrow (escrow-id uint))
  (if (is-valid-escrow-id escrow-id)
    (map-get? escrows escrow-id)
    none
  )
)

(define-read-only (get-escrow-by-order (order-id uint))
  (match (get-order order-id)
    order-data
    (match (get escrow-id order-data)
      escrow-id-val
      (get-escrow escrow-id-val)
      none
    )
    none
  )
)

(define-read-only (get-loyalty-points (retailer principal))
  (map-get? loyalty-points retailer)
)

(define-read-only (get-points-balance (retailer principal))
  (match (get-loyalty-points retailer)
    loyalty-data
    (ok (get available-points loyalty-data))
    (ok u0)
  )
)

(define-read-only (get-points-transaction (transaction-id uint))
  (map-get? points-transactions transaction-id)
)

(define-read-only (get-loyalty-config)
  {
    enabled: (var-get loyalty-enabled),
    earn-rate: (var-get points-earn-rate),
    redemption-rate: (var-get points-redemption-rate),
    expiry-enabled: (var-get points-expiry-enabled),
    expiry-period: (var-get points-expiry-period),
    bronze-threshold: bronze-threshold,
    silver-threshold: silver-threshold,
    gold-threshold: gold-threshold
  }
)

(define-read-only (get-redeemable-discount (points uint))
  (if (and (> points u0) (<= points max-points))
    (ok (/ points (var-get points-redemption-rate)))
    (ok u0)
  )
)

(define-read-only (get-points-to-next-tier (retailer principal))
  (match (get-loyalty-points retailer)
    loyalty-data
    (let (
      (current-points (get total-points loyalty-data))
      (current-tier (get current-tier loyalty-data))
    )
      (if (is-eq current-tier "bronze")
        (ok (if (>= current-points silver-threshold) u0 (- silver-threshold current-points)))
        (if (is-eq current-tier "silver")
          (ok (if (>= current-points gold-threshold) u0 (- gold-threshold current-points)))
          (ok u0)
        )
      )
    )
    (ok silver-threshold)
  )
)

(define-read-only (get-contract-stats)
  {
    total-orders: (var-get order-counter),
    total-escrows: (var-get escrow-counter),
    total-revenue: (var-get total-revenue),
    is-active: (var-get contract-active),
    supported-currencies: (var-get supported-currencies),
    total-points-transactions: (var-get points-transaction-counter),
    loyalty-enabled: (var-get loyalty-enabled)
  }
)

(define-read-only (calculate-discounted-price (base-price uint) (discount-rate uint))
  (if (and (> discount-rate u0) (<= discount-rate u100))
    (- base-price (/ (* base-price discount-rate) u100))
    base-price
  )
)

(define-read-only (get-supplier-product-count (supplier principal))
  (default-to u0 (map-get? supplier-product-count supplier))
)

(define-read-only (get-supported-currencies)
  (var-get supported-currencies)
)

(define-read-only (get-currency-rate (currency (string-ascii 10)))
  (default-to u1000000 (map-get? currency-rates currency))
)

(define-read-only (get-escrow-balance (user principal) (currency (string-ascii 10)))
  (default-to u0 (map-get? escrow-balances {user: user, currency: currency}))
)

(define-read-only (convert-currency (amount uint) (from-currency (string-ascii 10)) (to-currency (string-ascii 10)))
  (if (is-eq from-currency to-currency)
    amount
    (let (
      (from-rate (get-currency-rate from-currency))
      (to-rate (get-currency-rate to-currency))
    )
      (/ (* amount from-rate) to-rate)
    )
  )
)

(define-read-only (is-escrow-expired (escrow-id uint))
  (match (get-escrow escrow-id)
    escrow-data
    (>= stacks-block-height (get expires-at escrow-data))
    false
  )
)

(define-read-only (is-dispute-expired (escrow-id uint))
  (match (get-escrow escrow-id)
    escrow-data
    (match (get dispute-deadline escrow-data)
      deadline
      (>= stacks-block-height deadline)
      false
    )
    false
  )
)

;; SECURITY: Enhanced validation functions
(define-private (is-contract-owner)
  (is-eq tx-sender contract-owner)
)

(define-private (is-contract-active)
  (var-get contract-active)
)

(define-private (is-valid-tier (tier (string-ascii 20)))
  (or (is-eq tier "bronze") (or (is-eq tier "silver") (is-eq tier "gold")))
)

(define-private (is-valid-status (status (string-ascii 20)))
  (or (is-eq status "active") (or (is-eq status "inactive") (is-eq status "suspended")))
)

(define-private (is-valid-order-status (status (string-ascii 20)))
  (or (is-eq status "pending") (or (is-eq status "confirmed") (or (is-eq status "shipped") (is-eq status "delivered"))))
)

(define-private (is-valid-payment-status (status (string-ascii 20)))
  (or (is-eq status "pending") (or (is-eq status "paid") (or (is-eq status "failed") (is-eq status "refunded"))))
)

(define-private (is-valid-escrow-status (status (string-ascii 20)))
  (or (is-eq status "active") 
    (or (is-eq status "released") 
      (or (is-eq status "disputed") 
        (or (is-eq status "resolved") (is-eq status "expired"))
      )
    )
  )
)

(define-private (is-valid-transaction-type (tx-type (string-ascii 20)))
  (or (is-eq tx-type "earned") 
    (or (is-eq tx-type "redeemed") 
      (or (is-eq tx-type "transferred-in") 
        (or (is-eq tx-type "transferred-out") 
          (or (is-eq tx-type "expired") (is-eq tx-type "bonus"))
        )
      )
    )
  )
)

(define-private (is-supported-currency (currency (string-ascii 10)))
  (is-some (index-of (var-get supported-currencies) currency))
)

;; SECURITY: Enhanced string validation
(define-private (is-valid-string (str (string-ascii 100)))
  (and (> (len str) u0) (<= (len str) max-string-length))
)

(define-private (is-valid-description (desc (string-ascii 500)))
  (and (>= (len desc) u0) (<= (len desc) max-description-length))
)

(define-private (is-valid-currency-string (currency (string-ascii 10)))
  (and (> (len currency) u0) (<= (len currency) u10))
)

;; SECURITY: Enhanced numeric validation
(define-private (is-valid-price (price uint))
  (and (> price u0) (<= price max-price))
)

(define-private (is-valid-quantity (qty uint))
  (and (> qty u0) (<= qty max-quantity))
)

(define-private (is-valid-rating (rating uint))
  (and (>= rating min-rating) (<= rating max-rating))
)

(define-private (is-valid-points (points uint))
  (and (> points u0) (<= points max-points))
)

;; SECURITY: ID validation functions
(define-private (is-valid-product-id (product-id uint))
  (and (> product-id u0) (<= product-id u1000000))
)

(define-private (is-valid-order-id (order-id uint))
  (and (> order-id u0) (<= order-id u1000000))
)

(define-private (is-valid-escrow-id (escrow-id uint))
  (and (> escrow-id u0) (<= escrow-id u1000000))
)

(define-private (is-valid-transaction-id (tx-id uint))
  (and (> tx-id u0) (<= tx-id u10000000))
)

;; SECURITY: Principal validation
(define-private (is-valid-principal (principal-addr principal))
  (not (is-eq principal-addr 'SP000000000000000000002Q6VF78))
)

;; SECURITY: Enhanced order validation
(define-private (can-place-order (retailer principal) (supplier principal) (product-id uint) (quantity uint))
  (let (
    (retailer-data (map-get? retailers retailer))
    (product-data (map-get? products {supplier: supplier, product-id: product-id}))
  )
    (match retailer-data
      retailer-info
      (match product-data
        product-info
        (and 
          (is-eq (get status retailer-info) "active")
          (is-eq (get status product-info) "active")
          (>= quantity (get minimum-order product-info))
          (>= (get quantity product-info) quantity)
          (is-valid-quantity quantity)
        )
        false
      )
      false
    )
  )
)

(define-private (update-retailer-stats (retailer principal) (amount uint))
  (match (map-get? retailers retailer)
    retailer-data
    (let (
      (current-orders (get total-orders retailer-data))
      (current-spent (get total-spent retailer-data))
    )
      (if (and (>= current-orders u0) (>= current-spent u0) (> amount u0))
        (begin
          (map-set retailers retailer
            (merge retailer-data {
              total-orders: (+ current-orders u1),
              total-spent: (+ current-spent amount)
            })
          )
          true
        )
        false
      )
    )
    false
  )
)

;; Currency management functions
(define-private (validate-currency-list (currencies (list 10 (string-ascii 10))))
  (fold check-currency-validity currencies true)
)

(define-private (check-currency-validity (currency (string-ascii 10)) (acc bool))
  (and acc (is-supported-currency currency))
)

;; Escrow helper functions
(define-private (create-escrow (order-id uint) (buyer principal) (seller principal) (amount uint) (currency (string-ascii 10)))
  (let (
    (current-block stacks-block-height)
    (escrow-id (+ (var-get escrow-counter) u1))
    (expires-at (+ current-block escrow-timeout-blocks))
  )
    (map-set escrows escrow-id {
      order-id: order-id,
      buyer: buyer,
      seller: seller,
      amount: amount,
      currency: currency,
      status: "active",
      created-at: current-block,
      expires-at: expires-at,
      released-at: none,
      dispute-raised: false,
      dispute-deadline: none
    })
    (var-set escrow-counter escrow-id)
    escrow-id
  )
)

(define-private (update-escrow-balance (user principal) (currency (string-ascii 10)) (amount uint) (is-credit bool))
  (let (
    (current-balance (get-escrow-balance user currency))
    (new-balance (if is-credit 
                   (+ current-balance amount)
                   (if (>= current-balance amount)
                     (- current-balance amount)
                     u0)))
  )
    (map-set escrow-balances {user: user, currency: currency} new-balance)
    new-balance
  )
)

;; Loyalty Points Helper Functions
(define-private (initialize-loyalty-account (retailer principal))
  (let (
    (current-block stacks-block-height)
  )
    (map-set loyalty-points retailer {
      total-points: u0,
      available-points: u0,
      redeemed-points: u0,
      expired-points: u0,
      lifetime-earned: u0,
      current-tier: "bronze",
      last-activity: current-block,
      tier-upgraded-at: current-block
    })
    true
  )
)

(define-private (calculate-points-earned (amount uint))
  (let (
    (earn-rate (var-get points-earn-rate))
  )
    (if (and (> amount u0) (> earn-rate u0))
      (/ (* amount earn-rate) u100)
      u0
    )
  )
)

(define-private (get-tier-from-points (total-points uint))
  (if (>= total-points gold-threshold)
    "gold"
    (if (>= total-points silver-threshold)
      "silver"
      "bronze"
    )
  )
)

(define-private (record-points-transaction 
  (retailer principal) 
  (tx-type (string-ascii 20)) 
  (points uint) 
  (order-id-opt (optional uint))
  (description (string-ascii 100))
)
  (let (
    (current-block stacks-block-height)
    (tx-id (+ (var-get points-transaction-counter) u1))
    (expires-at (if (var-get points-expiry-enabled)
                  (some (+ current-block (var-get points-expiry-period)))
                  none))
  )
    (map-set points-transactions tx-id {
      retailer: retailer,
      transaction-type: tx-type,
      points: points,
      order-id: order-id-opt,
      created-at: current-block,
      expires-at: expires-at,
      description: description
    })
    (var-set points-transaction-counter tx-id)
    tx-id
  )
)

(define-private (update-loyalty-account 
  (retailer principal) 
  (points-change int) 
  (tx-type (string-ascii 20))
)
  (let (
    (current-block stacks-block-height)
    (loyalty-data (default-to 
      {
        total-points: u0,
        available-points: u0,
        redeemed-points: u0,
        expired-points: u0,
        lifetime-earned: u0,
        current-tier: "bronze",
        last-activity: current-block,
        tier-upgraded-at: current-block
      }
      (map-get? loyalty-points retailer)
    ))
    (current-available (get available-points loyalty-data))
    (current-total (get total-points loyalty-data))
  )
    (if (>= points-change 0)
      ;; Adding points
      (let (
        (points-to-add (to-uint points-change))
        (new-available (+ current-available points-to-add))
        (new-total (+ current-total points-to-add))
        (new-lifetime (+ (get lifetime-earned loyalty-data) points-to-add))
        (new-tier (get-tier-from-points new-total))
      )
        (map-set loyalty-points retailer
          (merge loyalty-data {
            total-points: new-total,
            available-points: new-available,
            lifetime-earned: new-lifetime,
            current-tier: new-tier,
            last-activity: current-block
          })
        )
        true
      )
      ;; Subtracting points
      (let (
        (points-to-subtract (if (< points-change 0) (to-uint (* points-change -1)) u0))
      )
        (if (>= current-available points-to-subtract)
          (let (
            (new-available (- current-available points-to-subtract))
            (new-redeemed (if (is-eq tx-type "redeemed")
                           (+ (get redeemed-points loyalty-data) points-to-subtract)
                           (get redeemed-points loyalty-data)))
            (new-expired (if (is-eq tx-type "expired")
                          (+ (get expired-points loyalty-data) points-to-subtract)
                          (get expired-points loyalty-data)))
          )
            (map-set loyalty-points retailer
              (merge loyalty-data {
                available-points: new-available,
                redeemed-points: new-redeemed,
                expired-points: new-expired,
                last-activity: current-block
              })
            )
            true
          )
          false
        )
      )
    )
  )
)

;; SECURITY: Enhanced public functions with comprehensive validation
(define-public (register-supplier 
  (name (string-ascii 50)) 
  (contact (string-ascii 100))
  (preferred-currency (string-ascii 10))
  (accepted-currencies (list 10 (string-ascii 10)))
)
  (let (
    (current-block stacks-block-height)
  )
    (asserts! (is-contract-active) err-contract-paused)
    (asserts! (> (len name) u0) err-invalid-string)
    (asserts! (<= (len name) u50) err-invalid-string)
    (asserts! (> (len contact) u0) err-invalid-string)
    (asserts! (<= (len contact) u100) err-invalid-string)
    (asserts! (is-none (map-get? suppliers tx-sender)) err-already-exists)
    (asserts! (is-supported-currency preferred-currency) err-currency-not-supported)
    (asserts! (validate-currency-list accepted-currencies) err-currency-not-supported)
    
    (map-set suppliers tx-sender {
      name: name,
      contact: contact,
      status: "active",
      rating: u5,
      products-count: u0,
      joined-at: current-block,
      preferred-currency: preferred-currency,
      accepted-currencies: accepted-currencies
    })
    (ok true)
  )
)

(define-public (register-retailer 
  (name (string-ascii 50)) 
  (tier (string-ascii 20))
  (preferred-currency (string-ascii 10))
)
  (let (
    (current-block stacks-block-height)
  )
    (asserts! (is-contract-active) err-contract-paused)
    (asserts! (> (len name) u0) err-invalid-string)
    (asserts! (<= (len name) u50) err-invalid-string)
    (asserts! (is-valid-tier tier) err-invalid-tier)
    (asserts! (is-none (map-get? retailers tx-sender)) err-already-exists)
    (asserts! (is-supported-currency preferred-currency) err-currency-not-supported)
    
    (let (
      (discount-rate (if (is-eq tier "bronze") u5 
                       (if (is-eq tier "silver") u10 
                         (if (is-eq tier "gold") u15 u0))))
    )
      (map-set retailers tx-sender {
        name: name,
        tier: tier,
        discount-rate: discount-rate,
        total-orders: u0,
        total-spent: u0,
        status: "active",
        joined-at: current-block,
        preferred-currency: preferred-currency
      })
      ;; Initialize loyalty account
      (initialize-loyalty-account tx-sender)
      (ok true)
    )
  )
)

(define-public (add-product 
  (name (string-ascii 100)) 
  (description (string-ascii 500))
  (wholesale-price uint) 
  (retail-price uint) 
  (quantity uint) 
  (minimum-order uint) 
  (category (string-ascii 50))
  (currency (string-ascii 10))
)
  (let (
    (current-block stacks-block-height)
    (supplier-data (unwrap! (map-get? suppliers tx-sender) err-not-found))
    (current-count (get-supplier-product-count tx-sender))
    (new-product-id (+ current-count u1))
  )
    (asserts! (is-contract-active) err-contract-paused)
    (asserts! (is-eq (get status supplier-data) "active") err-not-approved)
    (asserts! (> (len name) u0) err-invalid-string)
    (asserts! (<= (len name) u100) err-invalid-string)
    (asserts! (is-valid-description description) err-invalid-string)
    (asserts! (> (len category) u0) err-invalid-string)
    (asserts! (<= (len category) u50) err-invalid-string)
    (asserts! (is-valid-price wholesale-price) err-invalid-price)
    (asserts! (is-valid-price retail-price) err-invalid-price)
    (asserts! (>= retail-price wholesale-price) err-invalid-price)
    (asserts! (is-valid-quantity quantity) err-invalid-amount)
    (asserts! (is-valid-quantity minimum-order) err-invalid-amount)
    (asserts! (<= minimum-order quantity) err-invalid-amount)
    (asserts! (is-supported-currency currency) err-currency-not-supported)
    
    (map-set products {supplier: tx-sender, product-id: new-product-id} {
      name: name,
      description: description,
      wholesale-price: wholesale-price,
      retail-price: retail-price,
      quantity: quantity,
      minimum-order: minimum-order,
      category: category,
      status: "active",
      created-at: current-block,
      currency: currency
    })
    (map-set supplier-product-count tx-sender new-product-id)
    (map-set suppliers tx-sender
      (merge supplier-data {
        products-count: new-product-id
      })
    )
    (ok new-product-id)
  )
)

(define-public (place-order 
  (supplier principal) 
  (product-id uint) 
  (quantity uint)
  (payment-currency (string-ascii 10))
)
  (let (
    (current-block stacks-block-height)
    (retailer-data (unwrap! (map-get? retailers tx-sender) err-not-found))
    (product-data (unwrap! (map-get? products {supplier: supplier, product-id: product-id}) err-not-found))
    (current-order-id (+ (var-get order-counter) u1))
    (wholesale-price (get wholesale-price product-data))
    (product-currency (get currency product-data))
    (base-price (* wholesale-price quantity))
    (discount-rate (get discount-rate retailer-data))
    (discounted-price (calculate-discounted-price base-price discount-rate))
    (final-price (if (is-eq product-currency payment-currency)
                   discounted-price
                   (convert-currency discounted-price product-currency payment-currency)))
    (available-quantity (get quantity product-data))
    (escrow-id (create-escrow current-order-id tx-sender supplier final-price payment-currency))
    (points-earned (if (var-get loyalty-enabled) (calculate-points-earned final-price) u0))
  )
    (asserts! (is-contract-active) err-contract-paused)
    (asserts! (is-valid-principal supplier) err-invalid-principal)
    (asserts! (is-valid-product-id product-id) err-not-found)
    (asserts! (is-valid-quantity quantity) err-invalid-amount)
    (asserts! (can-place-order tx-sender supplier product-id quantity) err-minimum-order)
    (asserts! (< base-price max-price) err-invalid-price)
    (asserts! (is-supported-currency payment-currency) err-currency-not-supported)
    
    (map-set orders current-order-id {
      retailer: tx-sender,
      supplier: supplier,
      product-id: product-id,
      quantity: quantity,
      total-price: final-price,
      status: "pending",
      created-at: current-block,
      updated-at: current-block,
      currency: payment-currency,
      payment-status: "pending",
      escrow-id: (some escrow-id),
      points-earned: points-earned
    })
    
    (map-set products {supplier: supplier, product-id: product-id}
      (merge product-data {
        quantity: (- available-quantity quantity)
      })
    )
    
    ;; Update escrow balance for buyer (debit)
    (update-escrow-balance tx-sender payment-currency final-price false)
    
    ;; Award loyalty points if enabled
    (if (and (var-get loyalty-enabled) (> points-earned u0))
      (begin
        (update-loyalty-account tx-sender (to-int points-earned) "earned")
        (record-points-transaction tx-sender "earned" points-earned (some current-order-id) "Points earned from purchase")
        true
      )
      true
    )
    
    ;; Check for tier upgrade
    (try! (check-and-upgrade-tier tx-sender))
    
    (update-retailer-stats tx-sender final-price)
    (var-set order-counter current-order-id)
    (var-set total-revenue (+ (var-get total-revenue) final-price))
    (ok current-order-id)
  )
)

(define-public (redeem-points (points uint) (order-id uint))
  (let (
    (current-block stacks-block-height)
    (order-data (unwrap! (map-get? orders order-id) err-not-found))
    (retailer (get retailer order-data))
    (loyalty-data (unwrap! (map-get? loyalty-points retailer) err-not-found))
    (available-points (get available-points loyalty-data))
    (discount-amount-result (unwrap-panic (get-redeemable-discount points)))
    (order-price (get total-price order-data))
  )
    (asserts! (is-contract-active) err-contract-paused)
    (asserts! (is-eq tx-sender retailer) err-unauthorized)
    (asserts! (is-valid-points points) err-invalid-points)
    (asserts! (>= available-points points) err-insufficient-points)
    (asserts! (is-eq (get payment-status order-data) "pending") err-invalid-status)
    (asserts! (<= discount-amount-result order-price) err-invalid-amount)
    
    ;; Deduct points
    (asserts! (update-loyalty-account retailer (- 0 (to-int points)) "redeemed") err-transfer-failed)
    
    ;; Record transaction
    (record-points-transaction retailer "redeemed" points (some order-id) "Points redeemed for discount")
    
    ;; Update order with discount
    (let (
      (new-price (- order-price discount-amount-result))
    )
      (map-set orders order-id
        (merge order-data {
          total-price: new-price,
          updated-at: current-block
        })
      )
      (ok new-price)
    )
  )
)

(define-public (transfer-points (recipient principal) (points uint))
  (let (
    (sender-loyalty (unwrap! (map-get? loyalty-points tx-sender) err-not-found))
    (sender-available (get available-points sender-loyalty))
  )
    (asserts! (is-contract-active) err-contract-paused)
    (asserts! (is-valid-principal recipient) err-invalid-principal)
    (asserts! (is-valid-points points) err-invalid-points)
    (asserts! (>= sender-available points) err-insufficient-points)
    (asserts! (not (is-eq tx-sender recipient)) err-invalid-principal)
    (asserts! (is-some (map-get? retailers recipient)) err-not-found)
    
    ;; Deduct from sender
    (asserts! (update-loyalty-account tx-sender (- 0 (to-int points)) "transferred-out") err-transfer-failed)
    
    ;; Add to recipient
    (asserts! (update-loyalty-account recipient (to-int points) "transferred-in") err-transfer-failed)
    
    ;; Record transactions
    (record-points-transaction tx-sender "transferred-out" points none "Points transferred out")
    (record-points-transaction recipient "transferred-in" points none "Points transferred in")
    
    (ok true)
  )
)

(define-public (check-and-upgrade-tier (retailer principal))
  (let (
    (current-block stacks-block-height)
    (loyalty-data (unwrap! (map-get? loyalty-points retailer) err-not-found))
    (retailer-data (unwrap! (map-get? retailers retailer) err-not-found))
    (total-points (get total-points loyalty-data))
    (current-tier (get current-tier loyalty-data))
    (new-tier (get-tier-from-points total-points))
  )
    (asserts! (is-contract-active) err-contract-paused)
    
    (if (not (is-eq current-tier new-tier))
      (let (
        (new-discount-rate (if (is-eq new-tier "bronze") u5 
                            (if (is-eq new-tier "silver") u10 
                              (if (is-eq new-tier "gold") u15 u0))))
      )
        ;; Update loyalty tier
        (map-set loyalty-points retailer
          (merge loyalty-data {
            current-tier: new-tier,
            tier-upgraded-at: current-block
          })
        )
        
        ;; Update retailer tier and discount
        (map-set retailers retailer
          (merge retailer-data {
            tier: new-tier,
            discount-rate: new-discount-rate
          })
        )
        (ok true)
      )
      (ok false)
    )
  )
)

(define-public (award-bonus-points (retailer principal) (points uint) (description (string-ascii 100)))
  (begin
    (asserts! (is-contract-owner) err-owner-only)
    (asserts! (is-contract-active) err-contract-paused)
    (asserts! (is-valid-principal retailer) err-invalid-principal)
    (asserts! (is-valid-points points) err-invalid-points)
    (asserts! (> (len description) u0) err-invalid-string)
    (asserts! (is-some (map-get? retailers retailer)) err-not-found)
    
    ;; Award points
    (asserts! (update-loyalty-account retailer (to-int points) "bonus") err-transfer-failed)
    
    ;; Record transaction
    (record-points-transaction retailer "bonus" points none description)
    
    ;; Check for tier upgrade
    (try! (check-and-upgrade-tier retailer))
    
    (ok true)
  )
)

(define-public (configure-loyalty-program 
  (enabled bool)
  (earn-rate uint)
  (redemption-rate uint)
  (expiry-enabled bool)
  (expiry-period uint)
)
  (begin
    (asserts! (is-contract-owner) err-owner-only)
    (asserts! (> earn-rate u0) err-invalid-amount)
    (asserts! (> redemption-rate u0) err-invalid-amount)
    (asserts! (> expiry-period u0) err-invalid-amount)
    
    (var-set loyalty-enabled enabled)
    (var-set points-earn-rate earn-rate)
    (var-set points-redemption-rate redemption-rate)
    (var-set points-expiry-enabled expiry-enabled)
    (var-set points-expiry-period expiry-period)
    
    (ok true)
  )
)

(define-public (deposit-to-escrow (currency (string-ascii 10)) (amount uint))
  (begin
    (asserts! (is-contract-active) err-contract-paused)
    (asserts! (is-supported-currency currency) err-currency-not-supported)
    (asserts! (is-valid-price amount) err-invalid-amount)
    
    ;; In production, this would transfer actual tokens to the contract
    ;; For now, we track balances
    (update-escrow-balance tx-sender currency amount true)
    (ok true)
  )
)

(define-public (release-escrow (escrow-id uint))
  (let (
    (current-block stacks-block-height)
    (escrow-data (unwrap! (map-get? escrows escrow-id) err-escrow-not-found))
    (order-data (unwrap! (map-get? orders (get order-id escrow-data)) err-not-found))
    (buyer (get buyer escrow-data))
    (seller (get seller escrow-data))
    (amount (get amount escrow-data))
    (currency (get currency escrow-data))
    (escrow-status (get status escrow-data))
  )
    (asserts! (is-contract-active) err-contract-paused)
    (asserts! (is-valid-escrow-id escrow-id) err-escrow-not-found)
    (asserts! (is-eq escrow-status "active") err-invalid-escrow-status)
    (asserts! (or (is-eq tx-sender buyer) (is-eq tx-sender seller)) err-unauthorized)
    (asserts! (not (is-escrow-expired escrow-id)) err-escrow-expired)
    
    ;; Release funds to seller
    (update-escrow-balance seller currency amount true)
    
    ;; Update escrow status
    (map-set escrows escrow-id
      (merge escrow-data {
        status: "released",
        released-at: (some current-block)
      })
    )
    
    ;; Update order payment status
    (map-set orders (get order-id escrow-data)
      (merge order-data {
        payment-status: "paid",
        updated-at: current-block
      })
    )
    
    (ok true)
  )
)

(define-public (dispute-escrow (escrow-id uint))
  (let (
    (current-block stacks-block-height)
    (escrow-data (unwrap! (map-get? escrows escrow-id) err-escrow-not-found))
    (buyer (get buyer escrow-data))
    (seller (get seller escrow-data))
    (escrow-status (get status escrow-data))
    (dispute-deadline (+ current-block dispute-timeout-blocks))
  )
    (asserts! (is-contract-active) err-contract-paused)
    (asserts! (is-valid-escrow-id escrow-id) err-escrow-not-found)
    (asserts! (is-eq escrow-status "active") err-invalid-escrow-status)
    (asserts! (or (is-eq tx-sender buyer) (is-eq tx-sender seller)) err-unauthorized)
    (asserts! (not (is-escrow-expired escrow-id)) err-escrow-expired)
    (asserts! (not (get dispute-raised escrow-data)) err-already-exists)
    
    (map-set escrows escrow-id
      (merge escrow-data {
        status: "disputed",
        dispute-raised: true,
        dispute-deadline: (some dispute-deadline)
      })
    )
    
    (ok true)
  )
)

(define-public (resolve-dispute (escrow-id uint) (release-to-seller bool))
  (let (
    (current-block stacks-block-height)
    (escrow-data (unwrap! (map-get? escrows escrow-id) err-escrow-not-found))
    (order-data (unwrap! (map-get? orders (get order-id escrow-data)) err-not-found))
    (buyer (get buyer escrow-data))
    (seller (get seller escrow-data))
    (amount (get amount escrow-data))
    (currency (get currency escrow-data))
    (escrow-status (get status escrow-data))
    (recipient (if release-to-seller seller buyer))
    (payment-status (if release-to-seller "paid" "refunded"))
  )
    (asserts! (is-contract-active) err-contract-paused)
    (asserts! (is-contract-owner) err-owner-only)
    (asserts! (is-valid-escrow-id escrow-id) err-escrow-not-found)
    (asserts! (is-eq escrow-status "disputed") err-invalid-escrow-status)
    
    ;; Release funds to chosen recipient
    (update-escrow-balance recipient currency amount true)
    
    ;; Update escrow status
    (map-set escrows escrow-id
      (merge escrow-data {
        status: "resolved",
        released-at: (some current-block)
      })
    )
    
    ;; Update order payment status
    (map-set orders (get order-id escrow-data)
      (merge order-data {
        payment-status: payment-status,
        updated-at: current-block
      })
    )
    
    (ok true)
  )
)

(define-public (handle-expired-escrow (escrow-id uint))
  (let (
    (current-block stacks-block-height)
    (escrow-data (unwrap! (map-get? escrows escrow-id) err-escrow-not-found))
    (order-data (unwrap! (map-get? orders (get order-id escrow-data)) err-not-found))
    (buyer (get buyer escrow-data))
    (amount (get amount escrow-data))
    (currency (get currency escrow-data))
    (escrow-status (get status escrow-data))
  )
    (asserts! (is-contract-active) err-contract-paused)
    (asserts! (is-valid-escrow-id escrow-id) err-escrow-not-found)
    (asserts! (is-eq escrow-status "active") err-invalid-escrow-status)
    (asserts! (is-escrow-expired escrow-id) err-escrow-not-expired)
    
    ;; Return funds to buyer for expired escrow
    (update-escrow-balance buyer currency amount true)
    
    ;; Update escrow status
    (map-set escrows escrow-id
      (merge escrow-data {
        status: "expired",
        released-at: (some current-block)
      })
    )
    
    ;; Update order payment status
    (map-set orders (get order-id escrow-data)
      (merge order-data {
        payment-status: "refunded",
        updated-at: current-block
      })
    )
    
    (ok true)
  )
)

(define-public (update-order-status (order-id uint) (new-status (string-ascii 20)))
  (let (
    (current-block stacks-block-height)
    (order-data (unwrap! (map-get? orders order-id) err-not-found))
    (order-supplier (get supplier order-data))
    (current-status (get status order-data))
  )
    (asserts! (is-contract-active) err-contract-paused)
    (asserts! (is-valid-order-id order-id) err-not-found)
    (asserts! (is-eq tx-sender order-supplier) err-unauthorized)
    (asserts! (is-valid-order-status new-status) err-invalid-status)
    (asserts! (not (is-eq current-status new-status)) err-invalid-status)
    
    ;; SECURITY: Status transition validation
    (asserts! (or 
      (and (is-eq current-status "pending") (is-eq new-status "confirmed"))
      (and (is-eq current-status "confirmed") (is-eq new-status "shipped"))
      (and (is-eq current-status "shipped") (is-eq new-status "delivered"))
    ) err-invalid-status)
    
    (map-set orders order-id
      (merge order-data {
        status: new-status,
        updated-at: current-block
      })
    )
    (ok true)
  )
)

(define-public (update-payment-status (order-id uint) (new-payment-status (string-ascii 20)))
  (let (
    (current-block stacks-block-height)
    (order-data (unwrap! (map-get? orders order-id) err-not-found))
    (order-supplier (get supplier order-data))
    (current-payment-status (get payment-status order-data))
  )
    (asserts! (is-contract-active) err-contract-paused)
    (asserts! (is-valid-order-id order-id) err-not-found)
    (asserts! (is-eq tx-sender order-supplier) err-unauthorized)
    (asserts! (is-valid-payment-status new-payment-status) err-invalid-status)
    (asserts! (not (is-eq current-payment-status new-payment-status)) err-invalid-status)
    
    (map-set orders order-id
      (merge order-data {
        payment-status: new-payment-status,
        updated-at: current-block
      })
    )
    (ok true)
  )
)

(define-public (add-supported-currency (currency (string-ascii 10)) (exchange-rate uint))
  (let (
    (current-currencies (var-get supported-currencies))
  )
    (asserts! (is-contract-owner) err-owner-only)
    (asserts! (is-valid-currency-string currency) err-invalid-string)
    (asserts! (> exchange-rate u0) err-invalid-amount)
    (asserts! (is-none (index-of current-currencies currency)) err-already-exists)
    
    (var-set supported-currencies (unwrap! (as-max-len? (append current-currencies currency) u10) err-invalid-amount))
    (map-set currency-rates currency exchange-rate)
    (ok true)
  )
)

(define-public (update-currency-rate (currency (string-ascii 10)) (new-rate uint))
  (begin
    (asserts! (is-contract-owner) err-owner-only)
    (asserts! (is-supported-currency currency) err-currency-not-supported)
    (asserts! (> new-rate u0) err-invalid-amount)
    
    (map-set currency-rates currency new-rate)
    (ok true)
  )
)

(define-public (update-supplier-rating (supplier principal) (rating uint))
  (let (
    (supplier-data (unwrap! (map-get? suppliers supplier) err-not-found))
  )
    (asserts! (is-contract-owner) err-owner-only)
    (asserts! (is-valid-principal supplier) err-invalid-principal)
    (asserts! (is-valid-rating rating) err-invalid-amount)
    
    (map-set suppliers supplier
      (merge supplier-data {
        rating: rating
      })
    )
    (ok true)
  )
)

(define-public (emergency-pause)
  (begin
    (asserts! (is-contract-owner) err-owner-only)
    (var-set contract-active false)
    (ok true)
  )
)

(define-public (resume-contract)
  (begin
    (asserts! (is-contract-owner) err-owner-only)
    (var-set contract-active true)
    (ok true)
  )
)
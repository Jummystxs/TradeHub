;; TradeHub - Wholesale and Retail Distribution Management System
;; A comprehensive contract for managing wholesale/retail operations with supplier networks
;; SECURITY-HARDENED VERSION

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

;; Security Constants
(define-constant max-string-length u100)
(define-constant max-description-length u500)
(define-constant max-price u1000000000) ;; 1 billion max price
(define-constant max-quantity u1000000)
(define-constant max-rating u5)
(define-constant min-rating u1)

;; Data Variables
(define-data-var contract-active bool true)
(define-data-var order-counter uint u0)
(define-data-var total-revenue uint u0)

;; Data Maps
(define-map suppliers
  principal
  {
    name: (string-ascii 50),
    contact: (string-ascii 100),
    status: (string-ascii 20),
    rating: uint,
    products-count: uint,
    joined-at: uint
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
    created-at: uint
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
    joined-at: uint
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
    updated-at: uint
  }
)

(define-map supplier-product-count principal uint)

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

(define-read-only (get-contract-stats)
  {
    total-orders: (var-get order-counter),
    total-revenue: (var-get total-revenue),
    is-active: (var-get contract-active)
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

;; SECURITY: Enhanced string validation
(define-private (is-valid-string (str (string-ascii 100)))
  (and (> (len str) u0) (<= (len str) max-string-length))
)

(define-private (is-valid-description (desc (string-ascii 500)))
  (and (>= (len desc) u0) (<= (len desc) max-description-length))
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

;; SECURITY: ID validation functions
(define-private (is-valid-product-id (product-id uint))
  (and (> product-id u0) (<= product-id u1000000))
)

(define-private (is-valid-order-id (order-id uint))
  (and (> order-id u0) (<= order-id u1000000))
)

(define-private (is-valid-item-id (item-id uint))
  (and (> item-id u0) (<= item-id u1000000))
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

;; SECURITY: Enhanced public functions with comprehensive validation
(define-public (register-supplier (name (string-ascii 50)) (contact (string-ascii 100)))
  (let (
    (current-block stacks-block-height)
  )
    (asserts! (is-contract-active) err-contract-paused)
    (asserts! (> (len name) u0) err-invalid-string)
    (asserts! (<= (len name) u50) err-invalid-string)
    (asserts! (> (len contact) u0) err-invalid-string)
    (asserts! (<= (len contact) u100) err-invalid-string)
    (asserts! (is-none (map-get? suppliers tx-sender)) err-already-exists)
    
    (map-set suppliers tx-sender {
      name: name,
      contact: contact,
      status: "active",
      rating: u5,
      products-count: u0,
      joined-at: current-block
    })
    (ok true)
  )
)

(define-public (register-retailer (name (string-ascii 50)) (tier (string-ascii 20)))
  (let (
    (current-block stacks-block-height)
  )
    (asserts! (is-contract-active) err-contract-paused)
    (asserts! (> (len name) u0) err-invalid-string)
    (asserts! (<= (len name) u50) err-invalid-string)
    (asserts! (is-valid-tier tier) err-invalid-tier)
    (asserts! (is-none (map-get? retailers tx-sender)) err-already-exists)
    
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
        joined-at: current-block
      })
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
    
    (map-set products {supplier: tx-sender, product-id: new-product-id} {
      name: name,
      description: description,
      wholesale-price: wholesale-price,
      retail-price: retail-price,
      quantity: quantity,
      minimum-order: minimum-order,
      category: category,
      status: "active",
      created-at: current-block
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

(define-public (place-order (supplier principal) (product-id uint) (quantity uint))
  (let (
    (current-block stacks-block-height)
    (retailer-data (unwrap! (map-get? retailers tx-sender) err-not-found))
    (product-data (unwrap! (map-get? products {supplier: supplier, product-id: product-id}) err-not-found))
    (current-order-id (+ (var-get order-counter) u1))
    (wholesale-price (get wholesale-price product-data))
    (base-price (* wholesale-price quantity))
    (discount-rate (get discount-rate retailer-data))
    (final-price (calculate-discounted-price base-price discount-rate))
    (available-quantity (get quantity product-data))
  )
    (asserts! (is-contract-active) err-contract-paused)
    (asserts! (is-valid-principal supplier) err-invalid-principal)
    (asserts! (is-valid-product-id product-id) err-not-found)
    (asserts! (is-valid-quantity quantity) err-invalid-amount)
    (asserts! (can-place-order tx-sender supplier product-id quantity) err-minimum-order)
    (asserts! (< base-price max-price) err-invalid-price)
    
    (map-set orders current-order-id {
      retailer: tx-sender,
      supplier: supplier,
      product-id: product-id,
      quantity: quantity,
      total-price: final-price,
      status: "pending",
      created-at: current-block,
      updated-at: current-block
    })
    
    (map-set products {supplier: supplier, product-id: product-id}
      (merge product-data {
        quantity: (- available-quantity quantity)
      })
    )
    
    (update-retailer-stats tx-sender final-price)
    (var-set order-counter current-order-id)
    (var-set total-revenue (+ (var-get total-revenue) final-price))
    (ok current-order-id)
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
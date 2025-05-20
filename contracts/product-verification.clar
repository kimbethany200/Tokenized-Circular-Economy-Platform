;; Product Verification Contract
;; Validates items in the system

(define-data-var last-product-id uint u0)

(define-map products
  { product-id: uint }
  {
    manufacturer: principal,
    name: (string-utf8 100),
    verified: bool
  }
)

(define-public (register-product (name (string-utf8 100)))
  (let
    (
      (new-id (+ (var-get last-product-id) u1))
    )
    (var-set last-product-id new-id)
    (map-set products
      { product-id: new-id }
      {
        manufacturer: tx-sender,
        name: name,
        verified: false
      }
    )
    (ok new-id)
  )
)

(define-public (verify-product (product-id uint))
  (let
    (
      (product (unwrap! (map-get? products { product-id: product-id }) (err u1)))
    )
    (asserts! (is-eq tx-sender (get manufacturer product)) (err u2))
    (map-set products
      { product-id: product-id }
      (merge product { verified: true })
    )
    (ok true)
  )
)

(define-read-only (get-product (product-id uint))
  (map-get? products { product-id: product-id })
)

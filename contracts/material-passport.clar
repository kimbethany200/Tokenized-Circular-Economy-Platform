;; Material Passport Contract
;; Records component composition

(define-map material-passports
  { product-id: uint }
  {
    materials: (list 20 (string-utf8 50)),
    percentages: (list 20 uint),
    recyclable: bool
  }
)

(define-public (create-material-passport
                (product-id uint)
                (materials (list 20 (string-utf8 50)))
                (percentages (list 20 uint))
                (recyclable bool))
  (begin
    (asserts! (is-eq (len materials) (len percentages)) (err u1))
    (map-set material-passports
      { product-id: product-id }
      {
        materials: materials,
        percentages: percentages,
        recyclable: recyclable
      }
    )
    (ok true)
  )
)

(define-read-only (get-material-passport (product-id uint))
  (map-get? material-passports { product-id: product-id })
)

(define-read-only (is-recyclable (product-id uint))
  (default-to false (get recyclable (map-get? material-passports { product-id: product-id })))
)

#lang sicp

; 1.1
(define a 3)

(define b (+ a 1))

(if (and (> b a) (< b (* a b)))
    b
    a)

(cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25))

(+ 2 (if (> b a) b a))

(* (cond ((> a b) a)
         ((< a b) b)
         (else -1))
   (+ a 1))

; 1.2
(/ (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 5)))))
      (* 3 (- 6 2) (- 2 7)))

; 1.3
(define (square x) (* x x))

(define (sumofsqrs x y) (+ (square x) (square y)))

(define (sumOfLargestTwoSquared x y z)
  (cond ((and (>= (+ x y) (+ y z)) (>= (+ x y) (+ x z))) (sumofsqrs x y))
        ((and (>= (+ x z) (+ y z)) (>= (+ x z) (+ x y))) (sumofsqrs x z))
        (else (sumofsqrs y z))
        )
  )

(sumOfLargestTwoSquared 1 2 3)

; 1.4

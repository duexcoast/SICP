#lang sicp
;j;; Exercise 2.4
#| (define (cons x y) |#
#|   (lambda (m) (m x y))) |#
#||#
#| (define (car z) |#
#|   (z (lambda (p q) p))) |#
#||#
#| (define (cdr z) |#
#|   (z (lambda (p q) q))) |#
#||#
#| (cdr (cons 5 10)) |#
#||#
#| Exercise 2.5 |#
#| (define (cons a b) |#
#|   (* (expt 2 a) (expt 3 b))) |#
#||#
#| (define (car x) |#
#|   (define (car-iter x count) |#
#|     (if (= 0 (remainder x 2)) |#
#|       (car-iter (/ x 2) (+ count 1)) |#
#|       x)) |#
#|   (car-iter x 0)) |#
#||#
#| (define (cdr x) |#
#|   (define (cdr-iter) |#
#|     (if (= 0 (remainder x 3)) |#
#|       (cdr-iter (/ x 3) (+ count 1)) |#
#|       x)) |#
#|   (cdr-iter x 0)) |#
#||#

(define one-thru-six (list 1 2 3 4 5 6))
(cdr one-thru-six)
(cons 10 one-thru-six)
(car (cdr one-thru-six))

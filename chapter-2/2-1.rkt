#lang sicp
#| Procedures for Manipulating Rational Numbers|#

(define (gcd a b)
  (if (= b 0)
    a
    (gcd b (remainder a b))))

(define (make-rat n d)
  (let ((g ((if (< d 0) - +) (abs (gcd n d)))))
    (cons (/ n g) (/ d g))))



(define (numer x) (car x))

(define (denom x) (cdr x))

(define (print-rat x)
  (newline)
  (display (numer x))
  (display "/")
  (display (denom x)))


(define (add-rat x y)
  (make-rat (+ (* (numer x) (denom y))
               (* (numer y) (denom x)))
            (* (denom x) (denom y))))

(define (sub-rat x y)
  (make-rat (- (* (numer x) (denom y))
               (* (numer y) (denom x)))
            (* (denom x) (denom y))))

(define (mult-rat x y)
  (make-rat (* (numer x) (numer y))
            (* (denom x) (denom y))))

(define (div-rat x y)
  (make-rat (* (numer x) (denom y))
            (* (denom x) (numer y))))

(define (equal-rat? x y)
  (= (* (numer x) (denom y))
     (* (numer y) (denom x))))

(define one-half (make-rat -1 2))

(print-rat one-half)

(define one-third (make-rat 1 -3))

(print-rat (add-rat one-half one-third))

(print-rat (add-rat one-third one-third))

;;; Exercise 2.2
(define (average a b) (/ (+ a b) 2))

; Constructor:
(define (make-point x y)
  (cons x y))

; Selector
(define (x-point p) 
  (car p))

(define (y-point p)
  (cdr p))
; Constructor:
; Makes a line segment by creating a pair of two (x, y) points. 
(define (make-segment a b)
    (cons a b))
           

; Selectors:
; Selects the starting point from the line segment.
(define (start-segment segment)
  (car segment))

; Selects the ending point from the line segment.
(define (end-segment segment)
  (cdr segment))

; Midpoint
(define (midpoint-segment segment)
  (make-point
    (average (x-point (start-segment segment)) (x-point (end-segment segment)))
    (average (y-point (start-segment segment)) (y-point (end-segment segment)))))

; Print points
(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

(define start (make-point 1 1))
(define end (make-point -1 -1))
(print-point start)
(print-point end)

(define line (make-segment start end))
(print-point (cdr line))
(print-point (midpoint-segment line))

;;; Exercise 2.3 

#| (define (make-rectangle line1 line2 line3 line4)) |#

;;; Exercise 2.4

#| Exercise 2.6 |#
#| Church Numerals |#

(define zero (lambda (f) (lambda (x) x)))

(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))


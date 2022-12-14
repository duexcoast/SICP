#lang sicp

(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1))
                 (fib (- n 2))))))

(define (fib2 n)
  (fib-iter 1 0 n))

(define (fib-iter a b count)
  (if (= count 0)
      b
      (fib-iter (+ a b) a (- count 1))))

;(fib2 10)

(define (count-change amount)
  (cc amount 5))

(define (cc amount kinds-of-coins)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (= kinds-of-coins 0)) 0)
        (else (+ (cc amount
                     (- kinds-of-coins 1))
                 (cc (- amount
                        (first-denomination kinds-of-coins))
                     kinds-of-coins)))))

(define (first-denomination kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 25)
        ((= kinds-of-coins 5) 50)))
(count-change 11)

(define (count-stairs n)
  (cond ((= n 1) 1)
        ((= n 2) 2)
        (else (+ (count-stairs (- n 1))
                 (count-stairs (- n 2))))))

;(count-stairs 5)

;;; Exercise 1.11

; Recursive Process
(define (f-recursive n)
  (if (< n 3)
      n
      (+ (f-recursive (- n 1))
         (* 2 (f-recursive (- n 2)))
            (* 3 (f-recursive (- n 3))))))

 ;(f-recursive 5)

; Iterative Process
(define (f-iterative n)
  (define (f-loop n-1 n-2 n-3 nth)
    (if (= n nth)
        n-1
        (f-loop (+ n-1 (* 2 n-2) (* 3 n-3)) n-1 n-2 (+ 1 nth))))
  (if (< n 3)
      n
      (f-loop 2 1 0 2)))

;(f-iterative 5)

; Another Iterative Process
(define (f n)
  (define (f-i a b c count)
    (cond ((< n 3) n)
          ((<= count 0) a)
          (else (f-i (+ a (* 2 b) (* 3 c)) a b (- count 1)))))
  (f-i 2 1 0 (- n 2)))

;;; Exercise 1.12
; Pascal's Triangle

; 1
; 1 1
; 1 2 1
; 1 3 3 1
; 1 4 6 4 1

(define (pascal row col)
  (cond ((= row 1) 1)
        ((or (= col 1) (= col row)) 1)
        (else (+ (pascal (- row 1) (- col 1))
                 (pascal (- row 1) col)))))

;(pascal 4 3)

; If we read the definition of Pascal's Triangle carefully, we can easily
; find the recursive translation: "Each number inside the triangle is the
; "sum of the two numbers above it" - this plainly spells out our recursive
; case:
;     (+ (pascal (- row 1) (- col 1)
;        (pascal (- row 1) col))

; What we had to first surmise is that we will need to provide our procedure
; with the column and row for any given number. With that information we can
; evaluate any position in the triangle.

; We are defining our base case as three possiblities:
;     The first row:
;         - the row is 1, in which case we return 1
;
;     "The numbers at the edge of the traingle are all 1":
;         - the col is 1, in which case we will return 1
;         - the col is equal to the row, this is the outside of the triangle,
;         and we return 1

; We define our recursive case with two calls, to find the numbers necessary
; create our new entry:
;     - We take the number from (- row 1) (- col 1)
;     - And the number from (- row 1) (col)

; To visualize the triangle:

(define (display-pascal-row n)
  (define (column-iter i)
    (display (pascal n i)) (display "  ")
    (if (= i n) ; when the column == row we make a new line
        (newline)
        (column-iter (+ i 1))))
  (column-iter 1))

(define (display-pascal n)
  (define (display-pascal-iter i)
    (display-pascal-row i)
    (if (= i n)
        (newline)
        (display-pascal-iter (+ i 1))))
  (display-pascal-iter 1))

;(display-pascal 10)

;;; Exercise 1.15

(define (cube x) (* x x x))

(define (p x) (- (* 3 x) (* 4 (cube x ))))

(define (sine angle step)
  (display step) (display ": ") (display angle) (newline)
  (if (not (> (abs angle) 0.1))
      angle
      (p (sine (/ angle 3.0)(+ step 1)))))

(sine 12.15 1)
; logarithmic time O(log(a))

;;; Exponentiation
(define (expt b n)
  (if (= n 0)
      1
      (* b (expt b (- n 1)))))
(expt 10 3)

;
;
#lang sicp
(#%require racket/trace)
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
;(count-change 11)

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

;(sine 12.15 1)
; logarithmic time O(log(a))

;;; Exponentiation

;; linear recursive process
(define (expt b n)
  (if (= n 0)
      1
      (* b (expt b (- n 1)))))
;(expt 10 3)

;; linear iterative process
(define (exp b n)
  (exp-iter b n 1))

(define (exp-iter b counter product)
  (if (= counter 0)
      product
      (exp-iter b (- counter 1) (* b product))))
  
;(exp 10 3)

;;; Successive squaring recursive process
(define (square x) (* x x))

(define (fast-expt b n)
(cond ((= n 0) 1)
      ((even? n) (square (fast-expt b (/ n 2))))
      (else (* b (fast-expt b (- n 1))))))

;(fast-expt 10 4)

;;; Exercise 1.16

; Successive squaring iterative process

(define (fast-expt-iter a b n)
  (cond ((= n 0)
         a)
       ((even? n)
        (fast-expt-iter a (* b b) (/ n 2)))
       (else
        (fast-expt-iter (* a b) b (- n 1)))))

;(fast-expt-iter 1 12 2)

;; Multiplication using only addition primative
(define (mult a b)
  (if (= b 0)
      0
      (+ a (mult a (- b 1)))))

; helper functions
(define (halve x) (/ x 2))

(define (double x) (* 2 x))
; fast mult
(define (fast-mult a b)
  (cond ((= b 1) a)
        ((even? b)
         (fast-mult (double a) (halve b)))
         (else
          (+ a (fast-mult a (- b 1))))))

;(fast-mult 2 4)

(define (fast-mult2 a b)
  (cond ((= b 0)
         0)
        ((even? b)
         (fast-mult2 (double a) (halve b)))
        (else
         (+ a (fast-mult a (- b 1))))))

; The difference between those two different versions above is
; the base case. In the first one I made the base case 1, and
; returned the value of a, in the second one I made the base case 0
; and returned 0. So when (= b 1), the process went to the `else`
; condition and returned (+ a 0). So they did exactly the same thing,
; the second version is just cleaner.

;;; Exercise 1.18

; In order to make this procedure iterative, we needed to find an invariant to track as a
; state variable throughout our iterative transformations. The way we did this was to
; track a new state variable c. On the odd step, we add (+ a c), and return c at the end.  

(define (fast-mult-iter a b c)
  (cond ((= b 0)
        c)
        ((even? b)
         (fast-mult-iter (double a) (halve b) c))
        (else
         (fast-mult-iter a (- b 1) (+ c a)))))

;(trace fast-mult-iter)
#| (fast-mult-iter 5 5 0) |#

;;; Exercise 1.19

(define (fib-log n)
  (fib-iter-log 1 0 0 1 n))

(define (fib-iter-log a b p q count)
  (cond ((= count 0) b)
        ((even? count)
         (fib-iter a
                   b
                   ; <compute p'>
                   ; <compute q'>
                   (/ count 2)))
         (else (fib-iter-log (+ (* b q) (* a q) (* a p))
                             (+ (* b p) (* a q) (* a q))
                             p
                             q
                             (- count 1)))))

;;; 1.25 Greatest Common Divisor's

; Euclid's Algorithm:
; Time: O(log n)
(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

;(gcd 4 16)
;;; Testing for Primality

(define (next test-divisor)
  (if (= test-divisor 2) 
    3
    (+ test-divisor 2)))

(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
  ((divides? test-divisor n) test-divisor)
  (else (find-divisor n (next test-divisor)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

;;; The Fermat Test

; Fermat's Little Theorem states that if n is a prime number,
; and `a` is any integer less than `n`, then a raised to the n-th power
; is congruent to `a (mod n)`

; We can use this theorem to test for primality by picking a random number `a`,
; such that a < n, then computing the remainder of a^n modulo n. If the result is
; is not equal to a, then we can be certain that n is not prime.

; On the other hand, if a^n % n = a then there's a high likelyhood that n is prime.
; We can repeatedly test for different values of a, becoming more certain each time.

; Use successive squaring to compute the exponential of a number modulo another number

(define (expmod base exp m)
  (cond ((= exp 0) 1)
         ((even? exp)
          (remainder (square (expmod base (/ exp 2) m))
                     m))
         (else
          (remainder (* base (expmod base (- exp 1) m))
                     m))))

; implement fermat's test by checking the equality of expmod with
; a random value for a (using the random primitive, which returns a
; non-negative int smaller than it's input parameter).

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else false)))

(fast-prime? 617 4)

;;; Probabilistic Algorithms

; There are variations of Fermat's Test that cannot be fooled. The way they work
; is by testing for conditions that only hold if n is prime, rather than the other 
;  way around. One variation of this type can improve the likelyhood that n is prime
;  by 50% each time. Thus, with repeated testing, the chance of error becomes arbitrarily
;  small. These types of algorithms, which reduce the chance of error on each iteration,
;  are known as probabilistic algorihms.
;
;;;  Exercise 1.21
(smallest-divisor 199)
; 199 **Prime**
(smallest-divisor 1999)
; 1999 **Prime**
(smallest-divisor 19999)
; 7 not prime


;;; Exercise 1.22

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (fast-prime? n 100)
  (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

#| (timed-prime-test 1999) |#

#| (define (search-for-primes low high total)) |#

(define (search-for-primes start-range end-range)
        (if (even? start-range) 
         (search-for-primes (+ 1 start-range) end-range)
         (cond ((> start-range end-range)
                (newline) (display "done"))
               (else (timed-prime-test start-range)
                     (search-for-primes (+ 2 start-range) end-range)))))
               
#| (search-for-primes 100000000 100000100 ) |#
#| (search-for-primes 1000000000 1000000100 ) |#

; Results:
; 1009 *** 1
; 1019 *** 1
; 1021 *** 10
        
#| (search-for-primes 100000000000 100000000100 ) |#
; Results:
; 10009 *** 10
; 10039 *** 3
; 10061 *** 20


#| (search-for-primes 100000000000000 100000000000100 ) |#
; Results:
; 100049 *** 8
; 100103 *** 5
; 100109 *** 60


#| (search-for-primes 100000000000000000 100000000000000100 ) |#
; Results:
; 100000037 *** 191
; 100000039 *** 188
; 100000049 *** 1750

;;; Exercise 1.23
; Results

;100000000000000003 *** 3318042
;100000000000000013 *** 3366311
;100000000000000019 *** 3342031
;;; Exercise 1.24
; 
;;; Exercise 1.31
;;; Exercise 1.33

(define (filtered-accumulate predicate? combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner
       (if (predicate? a) (term a) null-value)
       (filtered-accumulate predicate? combiner null-value term (next a) next b))))

(define (sum-of-squares-prime a b)
  (filtered-accumulate prime? + 0 square a inc b))

(define (relative-prime? i n)
  (= (gcd i n) 1))

(define (identity x) x)

(define (product-of-relative-prime n)
  (define (relative-prime? i)
    (= (gcd i n) 1))
  (filtered-accumulate relative-prime? * 1 identity 1 inc n))

(+ (let ((x 3))
     (+ x (* x 10)))
   5)

(define (fn x y)
  ((lambda (a b)
     (+ (* x (square a))
        (* y b)
        (* a b)))
   (+ 1 (* x y))
   (- 1 y)))

;;; Exercise 1.34

(define (fnc g)
  (g 2))

(fnc square)

(fnc (lambda (z) (* z (+ z 1))))

#| (fnc fnc) |#
; not  a procedure. Evaluates to (2 2)

;;; Procedures as Genereal Methods
;;; Finding roots of equations by the half-interval method
; Time complexity is O(log(L/T)) where L is the length of the original interval,
; and T is the error tolerance. 
(define (average x y) (/ (+ x y) 2))

(define (close-enough? x y)
  (< (abs(- x y)) .001))

(define (search f neg-point pos-point)
  (let ((midpoint (average neg-point pos-point)))
    (if (close-enough? neg-point pos-point)
      midpoint
      (let ((test-value (f midpoint)))
        (cond ((positive? test-value)
               (search f neg-point midpoint))
              ((negative? test-value)
               (search f midpoint pos-point))
              (else midpoint))))))

(define (half-interval-method f a b)
  (let ((a-value (f a))
        (b-value (f b)))
    (cond ((and (negative? a-value) (positive? b-value))
           (search f a b))
          ((and (negative? b-value) (positive? a-value))
           (search f b a))
          (else
            (error "Values are not of opposite sign" a b)))))

(half-interval-method sin 2.0 4.0)

(half-interval-method (lambda (x) (- (* x x x) (* 2 x) 3))
                      1.0
                      2.0)

(define tolerance .00001)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
        next
        (try next))))
  (try first-guess))

(fixed-point cos 1.0)

(fixed-point (lambda (y) (+ (sin y) (cos y))) 1.0)
      

#lang sicp

(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                x)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

(define (square x)
  (* x x))

(define (sqrt x)
  (sqrt-iter 1.0 x))

(sqrt 9)
;;; Exercise 1.5
(define (p) (p))
(define (test x y)
  (if (= x 0)
      0
      y))

(test 0 (p))

; The above procedure will result in an infinite loop if performed with applicative
; order evaluation. The interpreter will evaluate all the arguments and then apply the
; compound procedure. This means that the interpreter will need to evaluate `(p)` before
; applying `test`. Since `p` is a function that evaluates to itself, the interpreter will
; infinitely attempt to resolve `p`.

; Alternatively, an interpreter that uses normal order evaluation would not evaluate the
; operands until their values are actaully needed. In which case, (test 0 (p)) would be
; expaned to:
(if (= 0 0)
    0
    p)
; Since the predicate, (= 0 0) evaluates to true, then only the consequent is evaluated,
; and the alternative (p) is ignored.


;;; Exercise 1.6
; To understand the difference between using an `if` statement in it's special form
; versus defining an ordinary procedure in terms of `cond`, we should first know that
; using this new procedure will fail to return a value for `sqrt-iter`.
;
; The reason for this infinite recursion lies in the way that arguments are evaluated
; by Scheme in a procedure/function: applicative-order evaluation. This means that
; the procedure evaluates all arguments before performing the procedure. Since the
; second arg is recursive, we enter an infinite loop. Even when `good-enough?` evaluates
; to true which means we should return `guess`, since we've placed `cond` inside of a
; procedure it will still evaluate all arguments every time sqrt-iter is called (meaning
; it will call itself again every time).

; With conditional expressions, unlike procedures, we have the following form:
;
; (if <predicate> <consequent> <alternative>)
;
; The interpreter starts by evaluating the <predicate>, if this resolves to a true value,
; then the interpreter evaluates the <consequent> and returns its value, without ever evaluating
; the <alternative>. This prevents us from getting lost in the loop of infinite recursion.
;
; For posterity, we should also note a third type of evaluation in Scheme, different from
; the applicative-order evaluation of procedures, and the special forms of both conditionals
; and booleans (which are evaluated from left to right): Normal-Order Evaluation. With Normal
; Order, the operands are not evaluated until their values are needed. Rather, it would substitue
; operand expressions for parameters until it obtained an expression involving only primitive
; operators, *then* it would perform the evaluation. A mental model for normal-order evaluation
; is "fully expand, and then reduce". Normal Order evaluation will often cause reduntant evaluations
; of expressions and is thus less efficient than applicative order

; With applicative-order evaluation we "evaluate the arguments and *then* apply", which
; is what the Scheme interpreter actaully does. However, it is important to understand normal-
; order evaluation, as it can be an extremely valuable tool. 
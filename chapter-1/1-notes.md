# SICP Chapter 1 Notes

## Building Abstractions With Procedures

#### Lambda and Let
Both`lambda` and `let` allow us to create anonymous procedures, saving us from 
having to define procedures that will not be used outside of the scope they're 
created in.

The `lambda` form among other things, allows us to provide inline anonymous functions
to higher-order procedures. For example, in our `sum` procedure, when creating 
`pi-sum` we previously had to define both `pi-term` and `pi-next` within the procedure,
with `lambda` we can just provide those procedures as arguments to `pi-sum`:

```scheme
(define (pi-sum a b)
  (sum (lambda (x) (/ 1.0 (* x (+ x 2))))
    a
    (lambda (x) (+ x 4))
    b))
```

`lambda` can also be used as an operator in a combination procedure:
```scheme
((lambda (x y z) (+ x y (square z))) 1 2 3)
```
This example is creating the anonymous procedure and immediately providing values to 
be used.

##### Using `let` to create local variables
There's many times where we need local variables, other than those that have been
bound as formal parameters. To use intermediate quantities we can use a `lambda` 
expression to specify an anonymous procedure for binding our local variables. Then
our body becomes a single call to **that** procedure.

```scheme
(define (fn x y)
  ((lambda (a b)
     (+ (* x (square a))
        (* y b)
        (* a b)))
   (+ 1 (* x y))
   (- 1 y)))
```

We can infact replace this construct with the `let` syntax, designed specifically 
to make this useful contstruct more convenient:

```scheme
(define (f x y)
  (let ((a (+ 1 (* x y)))
        (b (- 1 y)))
    (+ (* x (square a ))
        (* y b)
        (* a b))))
```

With `let` the form of the expression is as follows:

```scheme
(let ((<var1> <exp1>)
      (<var2> <exp2)
      .
      .
      .
      (<varn> <expn>))
    <body>)
```
The first part is a a list of name-expression pairs, and the body is evaluated with 
these names bound as local variables. In practice, the `let` syntax is just syntactic
sugar for the underlying application. `let` expressiosn are interpreted as an alternate
syntax for the lambda construct above:
```scheme
((lambda (<var1>... <varn>)
   <body>)
 <exp1>
 .
 .
 .
 <expn>)
```

Some things to note about `let` expressions:
1.`let` allows us to bind variables as locally as possible to where they are to be used.
2. The variables values are compute outside the `let`. This means that inside the body of
a `let` expression, variables have the values provided to them by the local variables, but
the variables in the expressions are computed with their values outside `let`

For example, if the value of `x` is `2`:
```scheme
(let ((x 3)
       (y (+ x 2)))
  (* x y))
```
The expression will evaluate to `12`, because inside the body of the `let`, `x` will be `3`
and `y` will be `4` (which is the outer x plus 2). 

### Finding fixed points of functions
A number `x` is called a *fixed point* of a function if `x` satisfies the equation of f(x) = x.
For some functions we can locate a fixed point by beginning with an initial guess and applying 
`f` repeatedly until the value does not change very much. To find the fixed point, we must define
a tolerance and repeatedly apply the given `f` until the absolute value of our prev guess minus
our next guess is less than the tolerance. To abstract this into a higher-order procedure:

```scheme
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
```

While this is successful for some functions, it won't work as a method for computing square roots,
even though it's very similar to the way we computed square roots with Newton's Method. 

Reminder of Newton's Method:

```scheme
(define (sqrt-iter guess x)
  (if (good-enough? guess x)
    guess
    (sqrt-iter (improve guess x)
               x)))
(define (improve guess x )
  (average guess (/ x guess)))
```

To find the square root of a number `x` we must find a `y` such that `y^2 = x` or `y = x/y`.
This translates to providing `(fixed-point)` a procedure of `(lambda (y) (/ x y))`
But this doesn't end up working. The reason is that the fixed-point search does not
converge. It gets stuck in an infinite loop, where two guesses repeat over and over.

One way to gain control over oscillations that result in infinite loops is to apply
what is called *average damping*. This technique involves averaging successive approximations
to a solution. Basically we prevent our guesses from changing so much, making them less far away
from `y` than `(/ x y)` by averaging `y` with `(x / y)`. This changes our inital equation,
so now we are looking for the fixed-point of `y = 1/2 (y + x/y)`:

```scheme
(define (sqrt x)
  (fixed-point (lambda (y) (average y (/ x y))
                1.0))
```

### Procedures as returned values
The ability to pass procedures as arguments significantly enhances the expressive power 
of our programming language. The natural continuation of this idea is to create procedures 
whose returned values are themselves procedures.

Lets revisit average damping, which we used to allow the fixed-point function for square roots
to converge. Put simply, average damping is performed when, given a function `f`, we consider
the function whose value at `x` is equal to the average of `x` and `f(x)`.

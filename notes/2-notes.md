# Building Abstractions with Data
Simple numerical data is not sufficient for many of the problems we wish 
to address using computation. While in chapter 1 we focused on building
abstractions by combining procedures to form compound procedures, now we 
will focus on building abstractions by combining data objects to form 
compound data

Compound data allows us to elevate the conceptual level at which we can 
design our programs. 

## Introduction to Data Abstraction
Much like procedural abstractions used in compound procedures allow us to 
separate the way a procedure will be used from the details about how it will 
be implemented, **data abstraction** is a methodology that enables us to 
isolate how a compound data object is used from the details of hwo it is 
constructed from more primitive data objects.

The general idea is to structure programs that are to use compound data objects
so that they operate on "abstract data" - they should use the data in such a 
way as to make no assumptions about the data that are not strictly neccessary 
for performing the task at hand. Meanwhile, "concrete" data representation is
defined independent of the programs that use the data. The interface between
these two parts of our system will be a set of procedures called *selectors* 
and *constructors*, that implement the abstract data in terms of the concrete
representation. 

### Procedures for Manipulating Rational Numbers
In defining procedures to manipulate rational numbers, we will again use 
the most powerful strategy of synthesis: wishful thinking. We will assume 
that we have procedures for `(make-rat y)`, `(numer x)`, and `(denom x)`. 
Armed with these procedures, we use them to create procedures to add, 
subtract, multiply and divide rational numbers, based on basic relations. 

```scheme
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
```

The above procedures are defined in terms of the **selector** and **constructor**
procedures `numer`, `denom`, and `make-rat`. 

    1. `make-rat` is a constructor
    2. `numer`, and `denom` are selectors.

### Pairs
Lisp provides a compound procedure called a pair, which can be constructed with
the primitive `cons` (which stands for "construct"). The procedure takes two
arguments and returns a compound data object that contains the two arguments as
parts. Given a pair, we can extract the parts using the primitive procedures
`car` (which stands for "Contents of Address part of Register"), and `cdr`, 
(which stands for "Contents fo Decrement part of Register", and is pronounced 
"coulder"). Both of these names derive from the original implementation of Lisp
on the IBM 704. 

A pair is a data object that can be given a name and manipulated just like a 
primitive data object.`cons` can also be used to form pairs whose elements are
pairs, and so on. 

```scheme
(define x (cons 1 2))

(define y (cons 3 4))

(define z (cons x y))

(car (car z))

(car (cdr z))
```

Data objects constructed from pairs are called **list-structured data**.

### Abstraction Barriers
The underlying idea of data abstraction is to identify for each type of data
object a basic set of operations in terms of which all manipulations of data 
objects of that type will be expressed, and then to use only those operations
in manipulating the data. 

With the rational number operations we did this with the constructor `make-rat`
and the selectors `numer` and `denom`.

We've created various levels of data abstraction barriers. Each level provides
an interface to the data abstraction below. By modularizing our system with levels
we make it easy to change implementation details. 

- - - - - - - - - - - - - - - - - - - -
Programs that use rational numbers
- - - - - - - - - - - - - - - - - - - -
Rational numbers in the problem domain:
`add-rat` `sub-rat` ... 
- - - - - - - - - - - - - - - - - - - -
Rational numbers as numerators and denominators:
`make-rat` `numer` `denom`
- - - - - - - - - - - - - - - - - - - -
Rational numbers as pairs:
`cons` `car` `cdr`
- - - - - - - - - - - - - - - - - - - -

### What is Meant by Data?
We think of data as defined by some collection of selectors and constructors, 
together with specified conditions that these rocedures ust fulfill in order 
to be a valid representation.

We can implement pairs without using data structures, through procedural
representation:
```scheme
(define (cons x y)
  (define (dispatch m)
    (cond ((= m 0) x)
          ((= m 1) y)
          (else (error "Argument not 0 or 1 -- CONS" m))))
  dispatch)

(define (car z) (z 0))
(define (cdr z) (z 1))```
```

The thing to note is that `cons` is returning the internally defined procedure
`dispatch`. We can then get access the separate values stored in a pair with 
a call like `(car (cons x y))`, which will return `x`.

This may seem trivial, but this type of procedural representation of data shows us
that the ability to manipulate procedures as objects automatically provides the 
ability to represent compound data.

This style of programming, using procedural representation of data, is called
**message passing** and will come up again later in the text.

## λ The Lambda Calculus
In the Lambda Calculus, all functions are unary, meaning they only take one 
argument. This means that when a lambda expression takes multiple arguments,
what is actually happening is a curried function. 
``````
λa => f(a)
λab => f(a)(b)

Function application is left-associative so these parentheses are meaningless:
λ(a)b => f(a)(b)
```
However, parentheses can be used to force applications to happen in a different
order:
```
First we apply `a` to `b`, and the result of that is the argument to `f`
λ(a b) => f(a(b))
```

### Abstractions
```
λa.b === a => b

λa.b x === a => b(x)

(λa.b) x === (a => b) x

λa.λb.a === a ==> b ==> a
```
### Beta Reduction
The name beta-reduction basically entails tracing the logic, or evaluating 
the function invocations and seeing what we end up with. Beta-Reduction is 
the act of taking and applying it to its argument.

```
((λa.a)λb.λc.b)(x)λe.f

// the first part of this function takes an a
// and returns an a:
// (λa.a)
// We've supplied this function with the argument
// λb.λc.b
// We will replace all occururances of a, with that
// argument (to fullfill λa.a)

(λb.λc.b)(x)λe.f

// now we look into the function body, and replace
all the b's with x's

(λc.x)λe.f

// at this point we look to replace all c's in
// the function body with λe.f, but there are no
// c's, so all we are left with is x.

// We call this beta-normal form, which is just to
// say that we fully evaluated the function

```

### Self Application Combinator: M - The Mockingbird
The mockingbird is a function that takes a function, and invokes the function
on itself:
`λf.ff`
```
M := λf.ff

// or in javascript:
M = f =>f(f)
```
Another syntactical note on lambda expressions is the simplification of 
`λa.λb.λc.b` to `λabc.b`. But this is not to say that a single lambda expression
is taking multiple arguments. They are being resolved one at a time, and fed into
each other. It is a simplified representation of nested lambda expressions.
```
λa.λb.λc.b

a => b => c => b
```

### The Kestrel: K Combinator
 Takes two things and returns the first one:
 ```
λab.a
 ```

### The Kite: KI Combinator
Takes two things and returns the second one:
```
λab.b
```

### Combinators
A combinator is a function with no free variables. A free variable is a variable in 
a function body that's not bound to some parameter.
```
λb.b // combinator
λb.a // NOT a combinator
λab.b // combinator
λb.ab // NOT a combinator
λabc.c(λe.b) // combinator
```

### C Combinator: The Cardinal
`λfab.fba` Takes a function f that takes two parameters. Then it calls that function
f, with those two parameters, but in opposite order.
```
C := λfab.fba

C K I M = 
```


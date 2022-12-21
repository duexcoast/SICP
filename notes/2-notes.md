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

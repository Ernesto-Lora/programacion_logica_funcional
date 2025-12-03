#lang racket
(require racket/trace)

(define (memberCustom x lst)
  (cond
    [(null? lst) #f] ;If the list is empty, the element is not there
    [(equal? x (first lst)) #t] ;We found the element so is a member
    [else (memberCustom x (rest lst))])) ; Recursive case (rest of the list)

(define (subset lst1 lst2)
  (cond
    [(null? lst1) #t] ; empty list is always a subset
    [(memberCustom (first lst1) lst2)
     (subset (rest lst1) lst2)] ; if the current element is a member, check the others
    [else #f])) ;

(define (inter lst1 lst2)
  (cond
    [(null? lst1) '()] ; We finish by append empty list 
    [(memberCustom (first lst1) lst2)
     (cons (first lst1)
           (inter (rest lst1) lst2))] ; if member. We "wait" the other elemens to append 
    [else
     (inter (rest lst1) lst2)])) ; skip it


(define (union lst1 lst2)
  (cond
    [(null? lst2) lst1] ; We finish by append list1
    [(memberCustom (first lst2) lst1) ;If we already have an element of 2nd list then
     (union lst1 (rest lst2))] ; we skipped
    [else
     (cons (first lst2)
           (union lst1 (rest lst2)))
     ])) ;

(define (dif lst1 lst2)
  (cond
    [(null? lst1) '()]                     ; We finish by append empty list 
    [(memberCustom (first lst1) lst2) 
     (dif (rest lst1) lst2)]              ; skip it 
    [else
     (cons (first lst1)
           (dif (rest lst1) lst2))]))     ; add

(define (deleteCustom elem lst)
  (cond
    [(null? lst) '()] ;
    [(equal? elem (first lst))
     (deleteCustom elem (rest lst))] ; 
    [else
     (cons (first lst)
           (deleteCustom elem (rest lst)))])) ; Not a member

(define (perms list0)
  (cond
    [(null? list0) '(())] ;when there are no elements,  
    [else
     (append-map 
      (lambda (element) ;we take the current element (append map takes 1,2 and 3)(for homwork example)
        (let ([rest_list (remove element list0)]) ;We name rest_list to the list without element
          (map (lambda (p) (cons element p)) ;we take element as the "head" of the new list
               (perms rest_list)))) ; p is an element that is "wait". at the end will be '(()) and all elemets will form a permutation
      list0)]))

(define (delete_loop elem lst)
  (for/list ([item (in-list lst)] #:unless (equal? item elem)) ;Takes all the elements but do not processed when item == elem
    item))


(define-syntax-rule (repeat n body ...)
  (for ([i n])
    body ...)) ; Repeat boty n times
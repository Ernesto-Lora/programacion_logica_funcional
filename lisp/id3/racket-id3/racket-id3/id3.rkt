#lang racket

(require "utils/tree.rkt" "utils/load.rkt")

(define (same-class-value? examples)
  (let ([val (get-value TARGET (car examples))])
    (andmap (λ(c) (equal? (get-value TARGET c) val)) examples)))

(define (get-domain attribute)
  (second (assoc attribute DOMAINS)))

(define (class-most-common-value examples)
  (define (count-examples-with-class-value value)
    (count (λ(x) (equal? x value))
           (map (λ(x) (get-value TARGET x)) EXAMPLES)))
  (caar (sort
         (for/list ([v (get-domain TARGET)])
           (list v (count-examples-with-class-value v)))
         #:key second
         >)))

(define (get-partition attribute examples)
  (let* ([values (second (assoc attribute DOMAINS))])
    (cons attribute
          (for/list ([val values])
            (list val
                  (filter (λ(x) (equal? (get-value attribute x)
                                        val))
                          examples))))))

(define (entropy examples attribute)
  (let ([partition (get-partition attribute examples)]
        [number-of-examples (length examples)])
    (apply + (map (λ(part)
                    (let* ([size-part (length (second part))]
                           [proportion (if (= size-part 0)
                                           0
                                           (/ size-part number-of-examples))])
                      (if (= proportion 0)
                          0
                          (* -1.0 proportion (log proportion 2)))))
                  (cdr partition)))))

(define (information-gain examples attribute)
  (let ([partition (get-partition attribute examples)]
        [number-of-examples (length examples)])
    (- (entropy examples TARGET)
       (apply + (map (λ(part)
                       (let* ([size-part (length (second part))]
                              [proportion (if (= size-part 0)
                                              0
                                              (/ size-part number-of-examples))])
                             (* proportion (entropy (second part) TARGET))))
                     (cdr partition))))))

(define (best-partition attributes examples)
  (let* ([info-gains (for/list ([attribute attributes])
                       (let ([info-gain (information-gain examples attribute)]
                             [partition (get-partition attribute examples)])
                         (list info-gain partition)))])
    (cadar (sort info-gains #:key car >))))

(define (id3 examples attributes)
  (let ([class-by-default (get-value TARGET (car examples))])
    (cond
      [(same-class-value? examples) class-by-default]
      [(empty? attributes) (class-most-common-value examples)]
      [else (let* ([partition (best-partition attributes examples)]
                   [node (first partition)])
              (cons node
                    (for/list ([branch (cdr partition)]
                               #:unless (empty? (second branch)))
                      (list (first branch)
                            (id3 (second branch)
                                 (remove node attributes))))))])))


(define (induce [examples EXAMPLES])
  (id3 examples (reverse (remove TARGET ATTRIBUTES))))
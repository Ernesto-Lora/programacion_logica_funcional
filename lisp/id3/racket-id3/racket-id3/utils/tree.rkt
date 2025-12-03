#lang racket

(provide root children subtree leaf? atom? print-tree)

;;; Auxiliar functions

(define (list? expr)
  (or (empty? expr) (pair? expr)))

(define (atom? expr)
  (not (list? expr)))

;;; Tree functions

(define (root tree)
  (car tree))

(define (children tree)
  (cdr tree))

(define (subtree tree value)
  (second (assoc value (cdr tree))))

(define (leaf? tree)
  (atom? tree))

(define (print-tree tree [depth 0])
  (define (my-tab n)
    (do ([i 1 (+ i 1)])
      [(> i n)]
      (printf " ")))
  (my-tab depth)
  (printf "~a~%" (first tree))
  (for ([subtree (cdr tree)])
    (my-tab (+ depth 1))
    (printf "- ~a" (first subtree))
    (if (leaf? (second subtree))
        (printf " -> ~a~%" (second subtree))
        (begin
          (printf "~%")
          (print-tree (second subtree) (+ depth 5))))))

;;; sample tree

(define t
  '(cielo (soleado
           (humedad (normal si)
                    (alta no)))
          (nublado si)
          (lluvia
           (viento
            (fuerte no)
            (debil si)))))

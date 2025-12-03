#lang racket

(provide reset get-value load-file EXAMPLES ATTRIBUTES TARGET DOMAINS TRACE)

(define EXAMPLES empty)
(define ATTRIBUTES empty)
(define TARGET null)
(define DOMAINS empty)
(define TRACE #false)

(define (reset)
  (set! EXAMPLES empty)
  (set! ATTRIBUTES empty)
  (set! TARGET empty)
  (set! DOMAINS empty)
  (printf "The ID3 setting has been reset."))

(define (read-lines-from-file file)
  (drop-right 
   (map (λ(l)
          (map (λ(w) (string->symbol (string-trim w)))
               (string-split l ",")))
        (file->lines file))
   1))

(define (get-value attrib example)
  (eval `(,(string->symbol (string-append "example-" (symbol->string attrib)))
          ,example)))

(define (load-file file)
  (let* ([lines (read-lines-from-file file)]
         [raw-data (cdr lines)]
         [ex-counter 1])
    (set! ATTRIBUTES (car lines))
    (set! TARGET (last ATTRIBUTES))
    (eval `(struct example ,ATTRIBUTES))
    (for ([d raw-data])
      (set! EXAMPLES
            (cons (eval (cons 'example (map (λ(x) `(quote ,x)) d))) EXAMPLES)))
    (for ([att ATTRIBUTES])
      (set! DOMAINS (cons (list att (remove-duplicates
                                     (map (λ(e) (get-value att e)) EXAMPLES)))
                          DOMAINS)))
    (printf "The training set has been initialized after ~a~%" file)))
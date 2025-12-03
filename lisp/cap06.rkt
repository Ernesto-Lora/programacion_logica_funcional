#lang racket

;;; tercero regresa el tercer elemento de la lista lst.

(define (tercero lst)
  "Returns the third dlement of a list"
  (caddr lst))

;;; suma-mayor-que verifica que la suma de x y sea mayor que z.

(define (suma-mayor-que x y z)
  (> (+ x y) z))

;;; miembro, true ssi elt es miembro de la lista lst.

(define (miembro elt lst)
  (cond
    [(empty? lst) #f]
    [(equal? elt (car lst)) #t]
    [else (miembro elt (cdr lst))]))

;;; pregunta por un valor con el promopt str

(define (pregunta str)
  (begin
    (printf "~a \n" str)
    (read)))

;;; pregunta por un número y valida que la respuesta sea uno.

(define (pregunta-num)
  (printf "Por favor, escriba un número: ")
  (let [(resp (read))]
    (if (number? resp)
        resp
        (pregunta-num))))

;;; cuadrados iterativo con do

(define (cuadrados inicio fin)
  (do [(i inicio (+ i 1))]
    [(> i fin) 'final]
    (printf "~a ~a ~%" i (* i i))))

;;; cuadrados recursivo

(define (cuadrados-rec inicio fin)
  (if (> inicio fin)
      'final
      (begin
        (printf "~a ~a ~%" inicio (* inicio inicio))
        (cuadrados-rec (+ 1 inicio) fin))))

;;; global constant

(define GLOB 2000)

;;; longitud iterativo con for

(define (longitud lst)
  (let [(long 0)]
    (for [(elt lst)]
      (set! long (+ 1 long)))
    long))

;;; longitud recursivo naïf

(define (longitud-rec lst)
  (if (empty? lst)
      0
      (+ 1 (longitud-rec (cdr lst)))))

;;; longitud tail recursive

(define (longitud-tr lst)
  (define (long-aux lst acc)
    (if (empty? lst)
        acc
        (long-aux (cdr lst) (+ 1 acc))))
  (long-aux lst 0))

;;; evaluación de las longitudes

(define (eval-longitudes n)
  (let*  [ (lst '())
           (lista (do [(i 1 (+ 1 i))]
                    [(> i n) lst]
                    (set! lst (cons i lst))))]
    (time (longitud lista))
    (time (longitud-rec lista))
    (time (longitud-tr lista))))


;;; logitud basado en for-each

(define (long-for-each lst)
  (let [(len 0)]
    (for-each
     (lambda (elt) 
       (set! len (+ len 1)))
     lst)
    len))

;;; true ssi arg es una lista

(define (lista-p arg)
  (or (empty? arg) (pair? arg)))

;;; true ssi arg es un átomo

(define (atom-p arg)
  (not (lista-p arg)))

;;; true si arg1 y arg2 son iguales, listas o átomos.
;;; violación de contrato si las listas son de difrente longitud.

(define (eql-p arg1 arg2)
  (or (eq? arg1 arg2)
      (and (list? arg1)
           (list? arg2)
           (eql-p (car arg1) (car arg2))
           (eql-p (cdr arg1) (cdr arg2)))))

;;; regresa una copia de lst

(define (copia-lista lst)
  (if (empty? lst)
      lst
      (cons (car lst) (copia-lista (cdr lst)))))

;;; rle

(define (n-elts elt n)
  (if (> n 1)
      (list n elt)
      elt))

(define (comprime elt n lst)
  (if (empty? lst)
      (list (n-elts elt n))
      (let [(sig (car lst))]
        (if (equal? sig elt)
            (comprime elt (+ 1 n) (cdr lst))
            (cons (n-elts elt n)
                  (comprime sig 1 (cdr lst)))))))

(define (rle arg)
  (if (list? arg)
      (comprime (car arg) 1 (cdr arg))
      arg))

;;; regresa true ssi lst1 es más larga que lst2

(define (longer lst1 lst2)
  (define (compara lst1 lst2)
    (and (pair? lst1)
         (or (empty? lst2)
             (compara (cdr lst1) (cdr lst2)))))
  (if (and (list? lst1) (list? lst2))
      (compara lst1 lst2)
      (> (length lst1) (length lst2))))

;;; regresa los elementos para los que fn elt es diferente de false
;;; > (filter zero? '(1 2 0 3 0 4 0 5))
;;; '(0 0 0)
;;; > (filter (compose not zero?) '(1 2 0 3 0 4 0 5))
;;; '(1 2 3 4 5)

(define (filter fn lst)
  (let [(acc '())]
    (for-each (λ(arg)
                (when (fn arg) (set! acc (cons arg acc))))
              lst)
    (reverse acc)))

;;; agrupa los elements de lst en listas de tamaño n

(define (sublist lst start n)
  (take (drop lst start) n))

(define (agrupa lst n)
  (define (rec lst acc)
    (let [(resto (list-tail lst n))]
      (if (pair? resto)
          (rec resto (cons (sublist lst 0 n) acc))
          (reverse (cons lst acc)))))
  (if (zero? n)
      (error "El tamaño de las sublistas debe ser mayor a cero")
      (if lst (rec lst empty) empty)))

;;; push macro

(define-syntax push
  (syntax-rules ()
    ((_ expr var) 
     (set! var (cons expr var)))))

#lang racket

(require web-server/servlet
         web-server/servlet-env)

(define czk->eur-rate 0.041)

(define (start request)
  (define bindings (request-bindings request))
  (define number-pair (assoc 'czk bindings))

  (define result
    (cond
      [(not number-pair) "Please enter amount in CZK"]
      [else
       (define str (cdr number-pair))
       (define maybe-number (string->number str))
       (if maybe-number
           (format "~a Kč = ~a €"
                   maybe-number
                   (real->decimal-string (* maybe-number czk->eur-rate) 2))
           "Invalid amount")]))

  (response/xexpr
   `(html
     (body
      (h2 "Czech Crowns → Euro Converter")
      (form ([action ""] [method "post"])
        (label "Amount in Kč: ")
        (input ([type "text"] [name "czk"]))
        (button ([type "submit"]) "Convert"))
      (div ,result)))))

(serve/servlet start
               #:port 8000
               #:servlet-path "/")

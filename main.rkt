#lang racket

;; the main entry point for an OO implementation of "6 Nimmt!" (Take 5)

(provide
 ;; (U String N) -> [Listof [List N N]]
 ;; (main n) creates n players, hands them to the dealer, and asks the
 ;; latter to run a complete simulation of a 6-Nimmit! game
 ;; EFFECT also write result to stdout
 ;; NOTE the default player and dealer are completely deterministic
 ;; To run a random simulation, it is necessary to override the defaults
 main)

(module+ test (require rackunit))

;; ---------------------------------------------------------------------------------------------------

(require "player.rkt" "dealer.rkt")

(define (main n)
  (define (e)
    (error 'main "input must be a natural number; given ~e" n))
  (define k
    (cond
      [(string? n)
       (define l (string->number n))
       (if (natural-number/c l) l (e))]
      [(natural-number/c n) n]
      [else (e)]))
  (define players (build-list k create-player))
  (define dealer (create-dealer players))
  (send dealer play-game))

(module+ test
  
  (define (check-main n result)
    (void
     (with-output-to-string
      (lambda ()
        (check-equal? (main n) result)))))
  (check-main 2 '((after round 3) ((1 0) (0 78))))
  (check-main 3 '((after round 2) ((1 0) (2 0) (0 76))))
  (check-main 4 '((after round 2) ((1 0) (2 0) (3 0) (0 100))))
  (check-main 5 '((after round 2) ((1 0) (2 0) (3 0) (0 56) (4 80))))
  
  (void
   (with-output-to-string
    (lambda ()
      (check-exn exn:fail? (lambda () (main 12)))))))

(set-logic QF_NOLL)

(declare-sort SL2_t 0)

; fields
(declare-fun n1 () (Field SL2_t SL2_t))
(declare-fun n2 () (Field SL2_t SL2_t))

; one-level skip list (i.e. a SLL)
(define-fun skl1 ((?hd SL2_t) (?ex SL2_t)) Space
  (tospace (or (= ?hd ?ex)
  (exists ((?tl SL2_t))
  (tobool (ssep
    (pto ?hd (sref (ref n2 nil) (ref n1 ?tl)))
    (skl1 ?tl ?ex))
)))))

; two-level skip list
(define-fun skl2 ((?hd SL2_t) (?ex SL2_t)) Space
  (tospace (or (= ?hd ?ex)
  (exists ((?tl SL2_t) (?Z1 SL2_t))
  (tobool (ssep
    (pto ?hd (sref (ref n2 ?tl) (ref n1 ?Z1)))
    (skl1 ?Z1 ?tl)
    (skl2 ?tl ?ex))
)))))

; variables
(declare-fun x1 () SL2_t)
(declare-fun x2 () SL2_t)

(declare-fun alpha1 () SetLoc)

(assert (tobool (ssep
  (pto x1 (sref (ref n2 x2) (ref n1 x2)))
  (pto x2 (sref (ref n2 nil) (ref n1 nil)))
)))

(assert (not
  (tobool (index alpha1 (skl2 x1 x2)))
))

; check whether the negation of the entailment is satisfiable
(check-sat)

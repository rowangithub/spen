(set-logic QF_SLRD)

(declare-sort NLL_lvl1_t 0)
(declare-sort NLL_lvl2_t 0)

; 'next' selector of level 1
(declare-fun next1 () (Field NLL_lvl1_t NLL_lvl1_t))
; 'next' selector of level 2
(declare-fun next2 () (Field NLL_lvl2_t NLL_lvl2_t))
; the bridge from level 2 to level 1
(declare-fun down () (Field NLL_lvl2_t NLL_lvl1_t))

; singly-linked list
(define-fun lso ((?in NLL_lvl1_t) (?out NLL_lvl1_t))
  Space (tospace (or 
    (and (= ?in ?out)  (tobool emp))
    (exists ((?u NLL_lvl1_t)) (and
      (distinct ?in ?out)
      (tobool (ssep
      (pto ?in (ref next1 ?u))
      (lso ?u ?out)))
    ))
  ))
)

; singly-linked list of cyclic singly-linked lists
(define-fun nlcl ((?in NLL_lvl2_t) (?out NLL_lvl2_t))
  Space (tospace (or 
    (and (= ?in ?out) (tobool emp))
    (exists ((?u NLL_lvl2_t) (?Z1 NLL_lvl1_t)) (and
      (distinct ?in ?out)
      (tobool (ssep
      (pto ?in (sref
        (ref next2 ?u)
        (ref down ?Z1)))
      (loop (lso ?Z1 ?Z1)) 
      (nlcl ?u ?out)))
   ))
 ))
)


(declare-fun x1 () NLL_lvl2_t)
(declare-fun x2 () NLL_lvl2_t)
(declare-fun x2_1 () NLL_lvl1_t)
(declare-fun x2_2 () NLL_lvl1_t)
(declare-fun x3 () NLL_lvl2_t)

(declare-fun alpha1 () SetLoc)
(declare-fun alpha2 () SetLoc)
(declare-fun alpha3 () SetLoc)
(declare-fun alpha4 () SetLoc)

;
; (bad) unfolding in the middle of nlcl(x1,nil)
; exp: sat
;
(assert (tobool (ssep
  (index alpha1 (nlcl x1 x2))
  (pto x2 (sref
    (ref next2 x3)
    (ref down x2_1)))
  (pto x2_1 (ref next1 nil))
  (index alpha3 (nlcl x3 nil))
)))

(assert (not (tobool (index alpha4
  (nlcl x1 nil)
))))

(check-sat)


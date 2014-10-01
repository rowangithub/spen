(set-logic QF_S)

(declare-sort Sll_t 0)

(declare-fun next1 () (Field Sll_t Sll_t))
(declare-fun next2 () (Field Sll_t Sll_t))

; singly-linked list with two next fields
(define-fun lsso ((?in Sll_t) (?out Sll_t))
  Space (tospace (or (= ?in ?out) 
    (exists ((?u Sll_t)) 
    (and (distinct ?in ?out)
    (tobool (ssep
      (pto ?in (sref
				(ref next1 ?u)
				(ref next2 ?u)))
      (lsso ?u ?out))
))))))

(declare-fun x_emp () Sll_t)
(declare-fun y_emp () Sll_t)
(declare-fun u_emp () Sll_t)
(declare-fun w_emp () Sll_t)
(declare-fun alpha1 () SetLoc)
(declare-fun alpha2 () SetLoc)
(assert (and
    (tobool (ssep
      (pto x_emp (sref (ref next1 y_emp) (ref next2 y_emp)))
      (pto y_emp (sref (ref next1 u_emp) (ref next2 u_emp)))
      (index alpha2 (lsso u_emp w_emp))
      (pto w_emp (sref (ref next1 nil) (ref next2 nil)))
    ))
))
(assert
  (not
    (tobool (index alpha1 (lsso x_emp nil)))
))

(check-sat)

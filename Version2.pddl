(define (domain elevators)
  (:requirements :strips :typing :adl :equality :fluents :durative-actions :duration-inequalities :negative-preconditions)   
  (:types passenger - object
  elevator - object
          going_up going_down vip - passenger
          going_nonstop guest never_alone - passenger
          floor - object
         )   


(:predicates 
    (on ?floor ?elevator) ;;Starting position of elevator
    (above ?floor1 ?floor2) ;;Arrangement of the floors (floor 2 above floor 1)

    (secure ?floor) ;;Secure floors that guests can't access alone
    (services ?elevator ?floor) ;;The floors that each elevator services
    
    (capacity ?elevator ?n);;The maximum fcapacity of each elevator
    (succ ?n1 ?n2) ;;Number of people boarding elevator
    (pred ?n2 ?n1) ;;Number of people departing elevator

;;The passenger subtypes
    (guest ?p - passenger) ;;The guests (person that cannot got to secure floor alone)
    (vip ?p - passenger)
    (never_alone ?p - passenger)
    (going_down ?p - passenger)
    (going_up ?p - passenger)

;;The passenger states
    (at ?p ?floor)  ;;The predicate that specify the person ?p is waiting at floor ?floor. 
                    ;;The passenger is waiting, if is neither boarded nor served
    (boarded ?p ?floor) ;;is true if passenger ?p has boarded the elevator and false otherwise
    (served ?p ?floor) ;;is true if passenger ?p has arrived at destination floor and false otherwise
)

(:action stop
 :parameters (?floor - floor ?elevator - elevator ?p - passenger)
 :precondition (and (on ?floor ?elevator)
        (imply 
          (exists (?p - never_alone)
         (or (and (at ?p ?floor)(not (served ?p ?floor)))
        (and (boarded ?p ?floor)(not (served ?p ?floor)))))
          
          (exists (?g - guest)
         (or (and (boarded ?g ?floor)(not (served ?g ?floor)))
             (and (not (served ?g))(at ?g ?floor))))) 

        (forall 
         (?p - going_nonstop) 
         (imply (boarded ?p ?floor) (served ?p ?floor))) 
        (or (forall 
                  (?p - vip) (served ?p ?floor))
                (exists (?p - vip)   
                      (or (at ?p ?floor) (served ?p ?floor))))
        (forall 
       (?p - passenger) 
       (imply (secure ?floor) (not (boarded ?p ?floor))))) 
       
 :effect (and 
    (forall (?p - passenger) 
                  (when (and (boarded ?p ?floor) 
                             (served ?p ?floor))
                        (and (not (boarded ?p ?floor)) 
                             (served  ?p ?floor))))
    (forall (?p - passenger)                
      (when (and (at ?p ?floor) (not (served ?p ?floor)))
      (boarded ?p ?floor)))))

(:action up
  :parameters (?floor1 ?floor2 ?elevator)
  :precondition (and (on ?floor1 ?elevator) (above ?floor1 ?floor2)
  (forall (?p -passenger)(imply(going_down ?p)(not(boarded ?p)))))
  :effect (and (on ?floor2 ?elevator) (not (on ?floor1 ?elevator))))

(:action down
  :parameters (?floor1 ?floor2 ?elevator)
  :precondition (and (on ?floor1 ?elevator) (above ?floor2 ?floor1))
  (forall (?p -passenger)(imply(going_up ?p)(not(boarded ?p)))))
  :effect (and (on ?floor2 ?elevator) (not (on ?floor1 ?elevator))))

(:action enter
:parameters (?p ?floor ?n1 ?n2 ?elevator)
:precondition (and  (on ?floor ?elevator) (at ?p ?floor)(capacity ?elevator ?n1)(succ ?n1 ?n2))
:effect (and (not (at ?p ?floor)) (services ?elevator ?p)(capacity ?elevator ?n2)))

(:action exit
:parameters (?p ?floor ?n1 ?n2 ?elevator)
:precondition (and (on ?floor ?elevator) (services  ?elevator ?p) (capacity ?elevator ?n2)(pred ?n2 ?n1))
:effect (and (at ?p ?floor) (not (services ?elevator ?p)) (capacity ?elevator ?n1)))

)




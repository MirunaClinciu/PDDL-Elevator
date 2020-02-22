(define (domain elevators)
  (:requirements :strips :typing :adl :equality)    
(:predicates 
    (on ?floor ?elevator) ;;Starting position of elevator
    (above ?floor1 ?floor2) ;;Arrangement of the floors (floor 2 above floor 1)

    (secure ?floor) ;;Secure floors that guests can't access alone
    (services ?elevator ?floor) ;;The floors that each elevator services
    
    (pcapacity ?p ?n)
    (capacity ?elevator ?n);;The maximum fcapacity of each elevator
    (succ ?n1 ?n2) ;;Number of people boarding elevator
    (pred ?n2 ?n1) ;;Number of people departing elevator

;;The passenger subtypes
    (guest ?p) ;;The guests (person that cannot got to secure floor alone)
    (vip ?p)

;;The passenger states
    (at ?p ?floor)  ;;The predicate that specify the person ?p is waiting at floor ?floor. 
                    ;;The passenger is waiting, if is neither boarded nor served
    (boarded ?p ?elevator) ;;is true if passenger ?p has boarded the elevator and false otherwise
    (served ?p ?floor) ;;is true if passenger ?p has arrived at destination floor and false otherwise
)


(:action up
  :parameters (?floor1 ?floor2 ?elevator)
  :precondition (and (on ?floor1 ?elevator) (above ?floor1 ?floor2))
  :effect (and (on ?floor2 ?elevator) (not (on ?floor1 ?elevator))))

(:action down
  :parameters (?floor1 ?floor2 ?elevator)
  :precondition (and (on ?floor1 ?elevator) (above ?floor2 ?floor1))
  :effect (and (on ?floor2 ?elevator) (not (on ?floor1 ?elevator))))

(:action enter
:parameters (?p ?floor ?n1 ?n2 ?elevator)
:precondition (and (on ?floor ?elevator) (at ?p ?floor)(capacity ?elevator ?n1)(succ ?n1 ?n2))
:effect (and (not (at ?p ?floor)) (services ?elevator ?p)(capacity ?elevator ?n2))(boarded ?p ?floor))

(:action exit
:parameters (?p ?floor ?n1 ?n2 ?elevator)
:precondition (and (on ?floor ?elevator) (services  ?elevator ?p)(capacity ?elevator ?n2)(pred ?n2 ?n1))
:effect (and (at ?p ?floor) (not (services ?elevator ?p))(capacity ?elevator ?n1))(served ?p ?floor) )

)


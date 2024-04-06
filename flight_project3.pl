flight(6711, bos, ord, 0815, 1005).
flight(211, lga, ord, 0700, 0830).
flight(203, lga, lax, 0730, 1335).
flight(92221, ewr, ord, 0800, 0920).
flight(2134, ord, sfo, 0930, 1345).
flight(954, phx, dfw, 1655, 1800).
flight(1176, sfo, lax, 1430, 1545).
flight(205, lax, lga, 1630, 2210).
flight(111, lga, bos, 0645, 0745).
flight(222, bos, ewr, 0750, 0845).


% 1. Where does the flight from PHX go?
find_destinations_from_phx :-
    flight(_, phx, Destination, _, _),
    write('The flight from Phx goes to: '), write(Destination), nl,
    fail.
find_destinations_from_phx.


% 2. Is there a flight to Phx?
flight_to_phx :-
    (   flight(_, _, phx, _, _) ->
        write('There is a flight to PHX (Phoenix).')
    ;   write('There is no flight to PHX (Phoenix).')
    ).


% 3. BOS flight landing time?

arrival_time_from_bos(ArrivalLocation, ArrivalTime) :-
    flight(_, bos, ArrivalLocation, _, ArrivalTime),
    write('The flight from BOS to '), write(ArrivalLocation),
    write(' lands at: '), write(ArrivalTime), nl.



%4. Does the flight from ORD-SFO depart after the flight from EWR-ORD lands

flight_departure_after(EWR_to_ORD_arrival, ORD_to_SFO_departure) :-
    flight(_, ewr, ord, _, EWR_to_ORD_arrival),
    flight(_, ord, sfo, ORD_to_SFO_departure, _),
    ORD_to_SFO_departure > EWR_to_ORD_arrival,
    write('Yes, the flight from ORD to SFO departs after the flight from EWR to ORD lands.').
flight_departure_after(_, _) :-
    write('No, the flight from ORD to SFO does not depart after the flight from EWR to ORD lands.').


% 5. what time do the flight to ORD arrive?

flight_to_ord(Flight, ArrivalTime) :-
    flight(Flight, _, ord, _, ArrivalTime).

show_flights_to_ord :-
    flight_to_ord(Flight, ArrivalTime),
    write('Flight: '), write(Flight),
    write(', Arrival Time: '), write(ArrivalTime), nl,
    fail.
show_flights_to_ord.

% 55555555 %
flights_to_ord_arrival_time :-
    flight(FlightNumber, _, ord, _, ArrivalTime),
    write('Flight '), write(FlightNumber), write(' arrives at ORD at '), write(ArrivalTime), write('.'), nl,
        fail.
flights_to_ord_arrival_time.




% Q6. find all flight route to lax;from Departure to Arrival
find_routes(Departure, Arrival) :-
    route_direct(Departure, Arrival),
    route_with_stops(Departure, Arrival, Stops),
    print_routes(Departure, Arrival, Stops).

% Predicate to prompt user for input and find routes accordingly
find_routes :-
    write('Enter departure airport: '),
    read(Departure),
    write('Enter arrival airport: '),
    read(Arrival),
    find_routes(Departure, Arrival).

% Predicate to print routes
print_routes(Departure, Arrival, Stops) :-
    print_direct_route(Departure, Arrival),
    nl,
    print_multiple_stop_route(Departure, Stops).

% If direct route found, print it
print_routes(Departure, Arrival, Stops) :-
    \+ route_direct(Departure, Arrival),
    route_with_stops(Departure, Arrival, Stops),
    print_multiple_stop_route(Departure, Stops).

% Direct flight predicate
route_direct(Departure, Arrival) :-
    flight(_, Departure, Arrival, _, _).

% Route with multiple stops predicate
route_with_stops(Departure, Arrival, Stops) :-
    flight(_, Departure, Stopover, _, _),
    flight(_, Stopover, Arrival, _, _),
    \+ flight(_, Departure, Arrival, _, _),
    Stops = [Stopover].

route_with_stops(Departure, Arrival, Stops) :-
    flight(_, Departure, Stopover, _, _),
    route_with_stops(Stopover, Arrival, Rest),
    Stops = [Stopover | Rest].

% Printing predicates
print_direct_route(Departure, Arrival) :-
    write('Direct flight route is from: '), nl,
    write(Departure),
    write(' to '),
    write(Arrival),
    nl.

print_stops([]).
print_stops([Stop]) :-
    write(Stop),
    write(' to lax').
print_stops([Stop1, Stop2|Rest]) :-
    write(Stop1),
    write(' to '),
    print_stops([Stop2|Rest]).

print_multiple_stop_route(Departure, Stops) :-
    write('Flight with multiple stops:'), nl, write(' Flights from '), nl,
    write(Departure),
    write(' to '),
    print_stops(Stops), nl.
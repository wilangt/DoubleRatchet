(*** Implémentation du cryptosystème RSA ***)

(* Gestion du module Zarith *)

let ( ++ ) = Z.add;;
let ( -- ) = Z.sub;;
let ( ** ) = Z.mul;;
let ( // ) = Z.div;;

(* Générateur de nombres premiers industriels *)

let prime4 = [2;3;5;7];;

let prime25 = [2;3;5;7;11;13;17;19;23;29;31;37;41;43;47;53;59;61;67;71;73;79;83;89;97];;

let prime100 = [2;3;5;7;11;13;17;19;23;29;31;37;41;43;47;53;59;61;67;71;73;79;83;89;97;101;103;107;109;113;127;131;137;139;149;151;157;163;167;173;179;181;191;193;197;199;211;223;227;229;233;239;241;251;257;263;269;271;277;281;283;293;307;311;313;317;331;337;347;349;353;359;367;373;379;383;389;397;401;409;419;421;431;433;439;443;449;457;461;463;467;479;487;491;499;503;509;521;523;541];;

let z2 = Z.of_int 2

let rec pow_int x = function
	(* Legacy *)
	(* une fonction puissance pour les entiers *)
	|0 -> 1
	|n -> let tmp = pow_int x (n/2) in
			tmp * tmp * if n mod 2 = 0 then 1 else x;;

let rec pow_mod_low_memory x n m =
	(* Legacy *)
	(* calcule (x pow n) mod m en optimisant l'espace et non le temps *)
	let rec aux acc x n m =
		(* pour la récursivité terminale *)
		if n=0 then acc
		else aux (acc*x mod m) x (n-1) m
	in aux 1 x n m;;

let fermat_primality_test n a =
	(* effectue le test de primalité de n avec 
	le petit théorème de Fermat et le paramètre a *)
	Z.powm a (Z.pred n) n = Z.one;;

let p_adic_valuation p n =
	(* trouve la valuation p-adique de n *)
	let rec aux acc m =
		if Z.divisible m p then aux (acc + 1) (m // p) else acc
	in aux 0 n;;

let miller_rabin_primality_test n a = 
	(* effectue le test de primalité de Miller-Rabin *)
	let s = p_adic_valuation z2 (Z.pred n) in
	let d = (Z.pred n) // (Z.pow z2 s) in
	let rec aux = function
		|(-1) -> false
		|r -> let tmp = Z.powm a (d ** (Z.pow z2 r)) n in 
		tmp = Z.pred n || aux (r-1)
	in Z.powm a d n = Z.one || aux (s-1);;

let is_prime_div n =
	let rec aux = function
		|[] -> true
		|t::q -> if Z.divisible n (Z.of_int t) then false else aux q
	in aux prime100;;

let is_prime_fermat n = 
	let rec aux = function
		|[] -> true
		|t::q -> if not (fermat_primality_test n (Z.of_int t)) then false else aux q
	in aux prime4;;

let is_prime_miller_rabin n = 
	let rec aux = function
		|[] -> true
		|t::q -> if not (miller_rabin_primality_test n (Z.of_int t)) then false else aux q
	in aux prime25;;

let is_prime n = 
	(* Vérifie si n est probablement premier *)
	(n <= Z.of_int 541 && List.mem (Z.to_int n) prime100) || (is_prime_div n && is_prime_fermat n && is_prime_miller_rabin n);;

let next_prime n = 
	(* Trouve le premier nombre premier superieur ou égal *)
	let rec aux m = if is_prime m then m else aux (Z.succ (Z.succ m)) in
	aux (if Z.is_odd n then n else (Z.succ n))

let random_int lambda =
	(* nombre entier aléatoire de lambda bits *)
	let rec aux acc = function
		|0 -> acc
		|l -> let tmp = Z.shift_left acc 1 in aux (if Random.bool () then tmp else Z.succ tmp) (l-1)
	in aux Z.one (lambda - 1);;

let random_prime lambda =
	(* nombre premier aléatoire de lambda bits *)
	next_prime (random_int lambda)

let rec check_random_prime lambda = function
	(* vérifie que la fonction random_prime fonctionne correctement *)
	|0 -> ()
	|n -> 	if Z.probab_prime (random_prime lambda) 10 > 0 
			then (print_string "ok\n"; check_random_prime lambda (n-1)) 
			else failwith "erreur primalité"

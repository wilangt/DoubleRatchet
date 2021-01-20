(*** Implémentation du cryptosystème RSA ***)

(* Gestion du module Zarith *)

let ( ++ ) = Z.add;;
let ( -- ) = Z.sub;;
let ( ** ) = Z.mul;;
let ( // ) = Z.div;;

let z0 = Z.zero;;
let z1 = Z.one;;
let z2 = Z.succ z1;;
let z3 = Z.succ z2;;


(* Générateur de nombres premiers industriels *)

let prime4 = [2;3;5;7];;

let prime25 = [2;3;5;7;11;13;17;19;23;29;31;37;41;43;47;53;59;61;67;71;73;79;83;89;97];;

let prime100 = [2;3;5;7;11;13;17;19;23;29;31;37;41;43;47;53;59;61;67;71;73;79;83;89;97;101;103;107;109;113;127;131;137;139;149;151;157;163;167;173;179;181;191;193;197;199;211;223;227;229;233;239;241;251;257;263;269;271;277;281;283;293;307;311;313;317;331;337;347;349;353;359;367;373;379;383;389;397;401;409;419;421;431;433;439;443;449;457;461;463;467;479;487;491;499;503;509;521;523;541];;

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
	Z.powm a (Z.pred n) n = z1;;

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
	in Z.powm a d n = z1 || aux (s-1);;

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

(* TODO : Résistance à l'attaque p-1 de Pollard *)

let next_prime n = 
	(* Trouve le premier nombre premier superieur ou égal *)
	let rec aux m = if is_prime m then m else aux (Z.succ (Z.succ m)) in
	aux (if Z.is_odd n then n else (Z.succ n))

let random_int lambda =
	(* nombre entier aléatoire de lambda bits *)
	let rec aux acc = function
		|0 -> acc
		|l -> let tmp = Z.shift_left acc 1 in aux (if Random.bool () then tmp else Z.succ tmp) (l-1)
	in aux z1 (lambda - 1);;

let random_prime lambda =
	(* nombre premier aléatoire de lambda bits *)
	next_prime (random_int lambda)

let rec check_random_prime lambda = function
	(* vérifie que la fonction random_prime fonctionne correctement *)
	|0 -> ()
	|n -> 	if Z.probab_prime (random_prime lambda) 10 > 0 
			then (print_string "ok\n"; check_random_prime lambda (n-1)) 
			else failwith "erreur primalité"


(* Cryptosystème RSA *)

type public_key = Z.t * Z.t;;
type secret_key = Z.t * Z.t;;
type plaintext = Z.t;;
type ciphertext = Z.t;;
type ciphertext_message = Z.t list;;

let extended_euclidian_algorithm phi e =
	let rec aux r u v r' u' v' =
		if r' = z0 then (r, u, v) else 
		let q = r//r' in aux r' u' v' (r -- (q ** r')) (u -- (q ** u')) (v -- (q ** v'))
	in aux phi z1 z0 e z0 z1;;

let find_e_d phi =
	(* Trouve les valeurs de e et de phi nécéssaires pour générer une paire de clef RSA *)
	let rec aux e = 
		let (r, u, v) = extended_euclidian_algorithm phi e in
		if r = z1 then (e, (Z.erem v phi)) else aux (Z.succ e)
	in aux z3;;

let generate_keys (lambda : int) : public_key * secret_key =
	(* Génère une paire de clefs RSA pour un lambda donné *)
	let p = random_prime (lambda - 1) and q = random_prime (lambda - 1) in
	let n = p ** q and phi = (Z.pred p) ** (Z.pred q) in
	let e,d = find_e_d phi in
	((n, e), (n,d));;

let encrypt (pk : public_key) (m : plaintext) : ciphertext =
	(* Chiffre un entier *)
	let n,e = pk in
	if m < n
	then Z.powm m e n
	else failwith "m is out of plaintext space";;

let decrypt (sk : secret_key) (c : ciphertext) : plaintext =
	(* Déchiffre un entier chiffré *)
	let n, d = sk in
	Z.powm c d n;;

(* Les 6 fonctions suivantes ne servent qu'à transformer une longue chaine de caractère
en liste d'entiers de taille raisonnable (i.e. inférieur à 2^lambda)
Elles ne sont pas très très interressantes *)

let text_to_block (size : int) (s : string) : string list = 
	(* Coupe une chaine s en chaines de taille au plus size *)
	let n = String.length s in
	let rec aux acc = function
		|i when i < 0 -> (String.sub s 0 (size + i)) :: acc
		|i -> aux ((String.sub s i size) :: acc) (i - size)
	in aux [] (n-size);;

let block_to_text = String.concat "";;

let rec int_to_base b = function
	(* Écriture en base b de n *)
	|n when n < b -> [n]
	|n -> Z.rem n b :: int_to_base b (n//b);;

let rec base_to_int b = function
	|[] -> z0
	|t::q -> t ++ b ** (base_to_int b q);;

let string_to_int s =
	let explode = List.init (String.length s) (String.get s) in
	let liste_ascii = List.map Char.code explode in
	let liste_ascii_Z = List.map Z.of_int liste_ascii in
	base_to_int (Z.of_int 128) liste_ascii_Z;;

let int_to_string n =
	let liste_ascii_Z = int_to_base (Z.of_int 128) n in
	let liste_ascii = List.map Z.to_int liste_ascii_Z in
	let explode = List.map Char.chr liste_ascii in
	String.concat "" (List.map (String.make 1) explode);;

let encrypt_message (pk : public_key) (m : string) : ciphertext_message =
	(* Chiffre un message ASCII *)
	let n,e = pk in
	let	lambda = Z.numbits n in
	let lambdaa = (lambda - 5) / 7 in (* ASCII est codé sur 7 bits ; -5 par sécurité *)
	let block_list = text_to_block lambdaa m in
	let int_list = List.map (string_to_int) block_list in
	List.map (encrypt pk) int_list;;

let decrypt_message (sk : secret_key) (c : ciphertext_message) : string =
	(* Déchiffre un message ASCII *)
	let int_list = List.map (decrypt sk) c in
	let block_list = List.map (int_to_string) int_list in
	block_to_text block_list;;

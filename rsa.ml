(* Mini-projet OCaml cryptographie *)

(* Implémentation du cryptosystème RSA *)

(* Générateur pseudo aléatoire ??*)

let rec pow_int x = function
	(* une fonction puissance pour les entiers *)
	|0 -> 1
	|n -> let tmp = pow_int x (n/2) in
			tmp * tmp * if n mod 2 = 0 then 1 else x;;

let rec pow_mod_low_memory x n m =
	(* calcule (x pow n) mod m en optimisant l'espace et non le temps *)
	let rec aux acc x n m =
		(* pour la récursivité terminale *)
		if n=0 then acc
		else aux (acc*x mod m) x (n-1) m
	in aux 1 x n m;;

let fermat_primality_test n a =
	(* effectue le test de primalité de n avec 
	le petit théorème de Fermat et le paramètre a *)
	pow_mod_low_memory a (n-1) n = 1;;

let p_adic_valuation p n =
	(* trouve la valuation p-adique de n *)
	let rec aux acc m =
		if m mod p = 0 then aux (acc+1) (m/p) else acc
	in aux 0 n;;

let miller_rabin_primality_test n a = 
	(* effectue le test de primalité de Miller-Rabin *)
	let s = p_adic_valuation 2 (n-1) in
	let d = (n-1) / pow_int 2 s in
	let rec aux = function
		|(-1) -> false
		|r -> let tmp = pow_mod_low_memory a (d*pow_int 2 r) n in 
		tmp = n-1 || aux (r-1)
	in pow_mod_low_memory a d n = 1 || aux (s-1);;

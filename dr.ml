(*** Implémentation de l'algorithme du Double Ratchet ***)

(* Gestion du module Zarith *)

let ( ++ ) = Z.add;;
let ( -- ) = Z.sub;;
let ( ** ) = Z.mul;;
let ( // ) = Z.div;;

let z0 = Z.zero;;
let z1 = Z.one;;
let z2 = Z.succ z1;;
let z3 = Z.succ z2;;


(* Implémentation de l'échange de clef Diffie–Hellman *)

(* RFC 3526 *)
let p2048 = Z.of_string "32317006071311007300338913926423828248817941241140239112842009751400741706634354222619689417363569347117901737909704191754605873209195028853758986185622153212175412514901774520270235796078236248884246189477587641105928646099411723245426622522193230540919037680524235519125679715870117001058055877651038861847280257976054903569732561526167081339361799541336476559160368317896729073178384589680639671900977202194168647225871031411336429319536193471636533209717077448227988588565369208645296636077250268955505928362751121174096972998068410554359584866583291642136218231078990999448652468262416972035911852507045361090559";;
let g2048 = z2;;

let random_int lambda =
	(* nombre entier aléatoire de lambda bits OU MOINS *)
	let rec aux acc = function
		|0 -> acc
		|l -> let tmp = Z.shift_left acc 1 in aux (if Random.bool () then tmp else Z.succ tmp) (l-1)
	in aux Z.zero lambda;;

let choose_secret () = random_int 1024;;

let share_secret sk = Z.powm g2048 sk p2048;;

let compute_secret sk shared = Z.powm shared sk p2048;;


(* Récupération d'une fonction de hachage depuis cryptotool *)

let sha256 = Cryptokit.hash_string (Cryptokit.Hash.sha256 ()) ;;

let explode s = List.init (String.length s) (String.get s);;

let hash s = Rsa.base_to_int (Z.of_int 256) (List.map Z.of_int (List.map Char.code (explode (sha256 s))));;

let hash1024 s = let h = hash s in Rsa.base_to_int (Z.pow z2 256) [h;h;h;h]

let safe_hash s = Z.logor (Rsa.base_to_int (Z.of_int 256) (List.map Z.of_int (List.map Char.code (explode (sha256 s))))) (Z.pow z2 255);; 
(* Le bit de poid fort est toujours à 1 *)


(* Algorithme du Double Ratchet *)

type hash = Z.t;; (* haché de 256 bits *)
type aes_key = Z.t;; (* Clef  AES128 donc 256 bits*)

(* Notations reprises de la documentation Signal : https://signal.org/docs/specifications/doubleratchet/ *)
type root_key = hash;; (* Entier de 256 bits *)
type chain_key = hash;; (* Entier de 256 bits *)
type message_key = aes_key;; (* Entier de 256 bits *)
type dh_private_key = Z.t;;
type dh_publique_key = Z.t;;

type interlocuteur = {
	rk : root_key;
	ck : chain_key;
	mk : message_key;
	sk : dh_private_key;
	pk : dh_publique_key; (* Comme pour le RSA, pointe vers la clef publique de l'autre interlocuteur*)
};;


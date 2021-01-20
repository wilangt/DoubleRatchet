(*** Utilisation de l'implémentation de AES de Cryptokit ***)


(* Gestion du module Zarith *)

let ( ++ ) = Z.add;;
let ( -- ) = Z.sub;;
let ( ** ) = Z.mul;;
let ( // ) = Z.div;;

let z0 = Z.zero;;
let z1 = Z.one;;
let z2 = Z.succ z1;;
let z3 = Z.succ z2;;


(* On choisit d'utiliser AES 128 *)

let random_string size =
    (* Retourne une chaine de caractère de taille size et composée de caractère dont
    le code ASCII est dans [|32;126|]. La distribution est uniforme. *)
    String.init size (function n -> Char.chr ((Random.int 95) + 32));;

let char_list_to_string l = String.concat "" (List.map (String.make 1) l)

let generate_aes encrypt key = Cryptokit.Cipher.(aes ~mode:ECB ~pad:Cryptokit.Padding.length 
                                                    key (if encrypt then Encrypt else Decrypt));;

let generate_key () = random_string 16
let encrypt key = Cryptokit.transform_string (generate_aes true key);;
let decrypt key = Cryptokit.transform_string (generate_aes false key);;


let generate_key_deterministe hash = 
    let hash80 = Z.logor (Z.rem hash (Z.pow z2 80)) (Z.pow z2 79) in (* On oublie pas de mettre le bit de poid fort à 1 *)
    let ascii_list = Rsa.int_to_base (Z.of_int 32) hash80 in
    let char_list = List.map Char.chr (List.map (function n -> n+32) (List.map Z.to_int ascii_list)) in
    char_list_to_string char_list;;

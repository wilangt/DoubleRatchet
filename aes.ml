(*** Utilisation de l'implémentation de AES de Cryptokit ***)

(* On choisit d'utiliser AES 128 *)

let random_string size =
    (* Retourne une chaine de caractère de taille size et composée de caractère dont
    le code ASCII est dans [|32;126|]. La distribution est uniforme. *)
    String.init size (function n -> Char.chr ((Random.int 95) + 32));;

let generate_aes encrypt key = Cryptokit.Cipher.(aes ~mode:ECB ~pad:Cryptokit.Padding.length 
                                                    key (if encrypt then Encrypt else Decrypt));;

let generate_key = random_string 16
let encrypt key = Cryptokit.transform_string (generate_aes true key);;
let decrypt key = Cryptokit.transform_string (generate_aes false key);;
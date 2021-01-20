(* CE FICHIER NE FAIT PAS PARTIE DU MINI-PROJET. IL NE M'A SERVI QU'À TESTER MES FONCTIONS. 
JE LE LAISSE POUR SI QUELQU'UN VEUT VÉRIFIER MES FONCTIONS *)

let pnl = print_newline and ps = print_string and pi = print_int and pz = Z.print and pf = Printf.printf;;
let pf s = ps s; pnl ();;
let pff s = ps s; pnl (); pnl ();;
let pfz s = ps s; pnl ();;

let test s i = 
    print_string s;
    print_newline ();
    print_int i;
    print_newline ();
    print_newline ();;

let ztest s i = 
    print_string s;
    print_newline ();
    Z.print i;
    print_newline ();
    print_newline ();;

let bti (* bool to int *) b = if b then 1 else 0;;

let zzz = Z.of_int;;

let check_random_prime lambda iter = 
	for i=0 to (iter-1) do
		print_int i;
		(if Z.probab_prime (Rsa.random_prime lambda) 10 > 0 
		then print_string " : ok\n"
		else failwith "erreur primalité");
	done;;

(*
Legacy
test "pow_int 2 10" (Rsa.pow_int 2 10);;
test "pow_mod_low_memory 2 10 7" (Rsa.pow_mod_low_memory 2 10 7);;
test "fermat_primality_test peut etre" (bti (Rsa.fermat_primality_test (Z.of_int 221) 38));;
test "fermat_primality_test non" (bti (Rsa.fermat_primality_test (Z.of_int 221) 24));;
test "p_adic_valuation 49 7" (Rsa.p_adic_valuation 7 49);;
test "miller_rabin_primality_test peut etre" (bti (Rsa.miller_rabin_primality_test (Z.of_int 221) 174));;
test "miller_rabin_primality_test non" (bti (Rsa.miller_rabin_primality_test (Z.of_int 221) 137));;
*)

(* Exemples de Wikipedia (pages test de primalité de fermat et miller rabin) *)
test "is_prime_div (Z.of_int 221)" (bti (Rsa.is_prime_div (Z.of_int 221)));;
test "is_prime_div (Z.of_int 103991)" (bti (Rsa.is_prime_div (Z.of_int 103991)));;
test "is_prime_fermat (Z.of_int 221)" (bti (Rsa.is_prime_fermat (Z.of_int 221)));;
test "is_prime_fermat (Z.of_int 103991)" (bti (Rsa.is_prime_fermat (Z.of_int 103991)));;
test "is_prime_miller_rabin (Z.of_int 221)" (bti (Rsa.is_prime_miller_rabin (Z.of_int 221)));;
test "is_prime_miller_rabin (Z.of_int 103991)" (bti (Rsa.is_prime_miller_rabin (Z.of_int 103991)));;
test "is_prime_miller_rabin (Z.of_int 221)" (bti (Rsa.is_prime_miller_rabin (Z.of_int 221)));;
test "is_prime_miller_rabin (Z.of_int 103991)" (bti (Rsa.is_prime_miller_rabin (Z.of_int 103991)));;
test "is_prime (Z.of_int 221)" (bti (Rsa.is_prime (Z.of_int 221)));;
test "is_prime (Z.of_int 103991)" (bti (Rsa.is_prime (Z.of_int 103991)));;

ztest "next_prime (zzz 50)" (Rsa.next_prime (zzz 50));;

Random.self_init ();;

ztest "random 1" (Rsa.random_int 1);;
ztest "random 2" (Rsa.random_int 2);;
ztest "random 13" (Rsa.random_int 13);;
ztest "random 256" (Rsa.random_int 256);;
ztest "random 2048" (Rsa.random_int 2048);;

ztest "random_prime 256" (Rsa.random_prime 256);;
(*ztest "random_prime 2048" (Rsa.random_prime 2048);;*)

ztest "find e 220" (fst (Rsa.find_e_d (zzz 220)));;
ztest "find d 220" (snd (Rsa.find_e_d (zzz 220)));;

let sk, pk = Rsa.generate_keys 1024;;
let m = Rsa.random_int 512;;
let c = Rsa.encrypt pk m;;
let m' = Rsa.decrypt sk c;;

ztest "m" m;;
ztest "c" c;;
ztest "m'" m';;
test "check dec enc" (bti (m' = m));;

ztest "base to int" (Rsa.base_to_int (zzz 17) (Rsa.int_to_base (zzz 17) (zzz 666999)));; 

let m = "lalalala\n" in
let i = Rsa.string_to_int m in
ztest "string_to_int" i;
let c = Rsa.encrypt_message pk m in
let m' = Rsa.decrypt_message sk c in
print_string (m');;
print_newline ();;

let long = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.
Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi.
Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat.
Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis.
At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, At accusam aliquyam diam diam dolore dolores duo eirmod eos erat, et nonumy sed tempor et et invidunt justo labore Stet clita ea et gubergren, kasd magna no rebum. sanctus sea sed takimata ut vero voluptua. est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat. 
Consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";;

print_string (Rsa.decrypt_message sk (Rsa.encrypt_message pk long));;
print_newline ();;

test "bits" ((Z.popcount Dr.p2048));;
test "is prime" (bti (Z.probab_prime Dr.p2048 10 > 0))


let hash = Cryptokit.Hash.sha256 ();;

let s = Cryptokit.hash_string hash "bacon";;

let explode = List.init (String.length s) (String.get s) in
let ex_int = List.map Char.code explode in
List.iter print_int ex_int;;
print_newline ();; print_newline ();;

ztest "safe_hash sha256" (Dr.safe_hash (Aes.random_string 50));;
test "nb bits" (Z.numbits (Dr.safe_hash (Aes.random_string 50)));;

let key = Aes.generate_key ();;
let m = "test2";;
let c = Aes.encrypt key m;;
let m' = Aes.decrypt key c;;

pf key;;
pfz c; pff m';;

pff (Aes.generate_key_deterministe (Dr.safe_hash "hjksfh67886jklq"));;

for i = 0 to 10 do
  let s = (Aes.random_string 50) in  
  let k = (Aes.generate_key_deterministe (Dr.safe_hash s)) in
  print_int (String.length k); print_newline ();
  let e = Aes.encrypt k "OK" in 
  pf e; pff (Aes.decrypt k e)
done;;


let a = Dr.choose_secret () and b = Dr.choose_secret ();;
let aa = Dr.share_secret a and bb = Dr.share_secret b;;
let k1 = Dr.compute_secret a bb and k2 = Dr.compute_secret b aa;;
ztest "k1" k1;;
ztest "k2" k2;;
test "ok ?" (bti (k1 = k2));;


let alice, bob = Dr.init ();;

pff (Dr.decrypt alice (Dr.encrypt bob "Bonjour"));; (* Bob -> Alice *)
pff (Dr.decrypt bob (Dr.encrypt alice "Bonjour"));; (* Alice -> Bob *)
pff (Dr.decrypt alice (Dr.encrypt bob "1"));; (* Bob -> Alice *)
pff (Dr.decrypt bob (Dr.encrypt alice "2"));; (* Alice -> Bob *)
pff (Dr.decrypt alice (Dr.encrypt bob "3"));; (* Bob -> Alice *)
pff (Dr.decrypt alice (Dr.encrypt bob "4"));; (* Bob -> Alice *)
pff (Dr.decrypt alice (Dr.encrypt bob "5"));; (* Bob -> Alice *)
pff (Dr.decrypt bob (Dr.encrypt alice "5"));; (* Alice -> Bob *)
pff (Dr.decrypt bob (Dr.encrypt alice "7"));; (* Alice -> Bob *)
pff (Dr.decrypt alice (Dr.encrypt bob "8"));; (* Bob -> Alice *)

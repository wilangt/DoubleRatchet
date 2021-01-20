(*** Démo des cryptosystèmes implémentés ***)

let pnl = print_newline and ps = print_string and pi = print_int and pz = Z.print and pf = Printf.printf;;

(* let pause = read_line;; *)
let pause () = pnl () ; 1;;

let pf s = ps s; let _ = pause () in ();; (* aller à la ligne *)
let pff s = ps s; pnl (); let _ = pause () in ();; (* sauter une ligne *)
let pzf s = pz s; let _ = pause () in ();; (* aller à la ligne *)

pff "Petite démo des cryptosystèmes implémentés. Le lecteur est invité à lire le fichier demo.ml tout en suivant la démo. Appuyez sur entrée pour continuer.";;

Random.self_init ();; (* Initialisation de l'aléatoire *)

(* RSA *)

type interlocuteur = {sk : Rsa.secret_key; pk : Rsa.public_key};;

pff " * * * * * * * * * * RSA * * * * * * * * * * ";;

pff "Alice et Bob veulent se raconter des secrets et décident d'utiliser le cryptosystème RSA.";;

pf "Alice commence par se créer une paire de clefs (de 2048 bits, c'est plutôt standard).";;
let sk_alice, pk_alice = Rsa.generate_keys 2048;;
let (n,e) = sk_alice and (n',d) = pk_alice;;
pf "Ici, la clef secrète de Alice est composée de :";;
pf "- n";;
pzf n;;
pf "- e";;
pzf e;;
pf "et sa clef publique est composée de :";;
pf "- n (le même que précédemment)";;
pf "- d";;
pzf d;;
pnl ();;

pff "Idem pour Bob";;
let sk_bob, pk_bob = Rsa.generate_keys 2048;;

pf "Puis Alice et Bob échangent leur clef publique tout en gardant leur clef secrète pour eux.";;
let alice = {sk = sk_alice; pk = pk_bob} and bob = {sk = sk_bob; pk = pk_alice};;
pff "Alice et Bob peuvent désormais chiffrer des messages pour l'autre et donc s'échanger des secrets.";;

pf "Par exemple, Alice veut envoyer 'Bonjour Bob' à Bob. Elle commence par chiffrer ce message avec la clef publique de Bob :";;
let message_chiffre = Rsa.encrypt_message alice.pk "Bonjour Bob";; 
(* On rappelle que les clefs publiques ont été échangées et donc que alice.pk désigne la clef publique de Bob *)
pzf (List.hd message_chiffre);;
pff "Si le message est trop gros (ce n'est pas le cas ici), il est automatiquement découpé en plusieurs morceaux.";;

pf "Bob le déchiffre ensuite avec sa clef privée :";;
let message_dechiffre = Rsa.decrypt_message bob.sk message_chiffre;;
pff message_dechiffre;;

pf "la conversation peut ainsi continuer ...";;
pff (Rsa.decrypt_message alice.sk (Rsa.encrypt_message bob.pk "Bonjour Alice"));;

pf "Et des messages beaucoup plus gros peuvent être envoyés :"
let dream = 
"I am happy to join with you today in what will go down in history as the greatest demonstration for freedom in the history of our nation.
Five score years ago a great American in whose symbolic shadow we stand today signed the Emancipation Proclamation. This momentous decree came as a great beckoning light of hope to millions of Negro slaves who had been seared in the flames of withering injustice. It came as a joyous daybreak to end the long night of their captivity.
But one hundred years later the Negro is still not free. One hundred years later the life of the Negro is still sadly crippled by the manacles of segregation and the chains of discrimination.
One hundred years later the Negro lives on a lonely island of poverty in the midst of a vast ocean of material prosperity.
One hundred years later the Negro is still languishing in the comers of American society and finds himself in exile in his own land.
We all have come to this hallowed spot to remind America of the fierce urgency of now. Now is the time to rise from the dark and desolate valley of segregation to the sunlit path of racial justice. Now is the time to change racial injustice to the solid rock of brotherhood. Now is the time to make justice ring out for all of God's children.
There will be neither rest nor tranquility in America until the Negro is granted citizenship rights.
We must forever conduct our struggle on the high plane of dignity and discipline. We must not allow our creative protest to degenerate into physical violence. Again and again we must rise to the majestic heights of meeting physical force with soul force.
And the marvelous new militarism which has engulfed the Negro community must not lead us to a distrust of all white people, for many of our white brothers have evidenced by their presence here today that they have come to realize that their destiny is part of our destiny.
So even though we face the difficulties of today and tomorrow I still have a dream. It is a dream deeply rooted in the American dream.
I have a dream that one day this nation will rise up and live out the true meaning of its creed: 'We hold these truths to be self-evident; that all men are created equal.'
I have a dream that one day on the red hills of Georgia the sons of former slaves and the sons of former slave owners will be able to sit together at the table of brotherhood.
I have a dream that one day even the state of Mississippi, a state sweltering with the heat of injustice, sweltering with the heat of oppression, will be transformed into an oasis of freedom and justice.
I have a dream that little children will one day live in a nation where they will not be judged by the color of their skin but by the content of their character.
I have a dream today.
I have a dream that one day down in Alabama, with its vicious racists, with its Governor having his lips dripping with the words of interposition and nullification, one day right there in Alabama little black boys and black girls will be able to join hands with little white boys and white girls as sisters and brothers.
I have a dream today.
I have a dream that one day every valley shall be exalted, every hill and mountain shall be made low, the rough places plains, and the crooked places will be made straight, and before the Lord will be revealed, and all flesh shall see it together. "
let reve_chiffre = Rsa.encrypt_message alice.pk dream;;
let reve_dechiffre = Rsa.decrypt_message bob.sk reve_chiffre;;
pff reve_dechiffre;;

ps "Par exemple, ce message aura été divisé en ";; pi (List.length reve_chiffre);; pff " messages.";;


(* AES *)

pff " * * * * * * * * * * AES * * * * * * * * * * ";;

pf "Idem, mais avec de la cryptographie symétrique, c'est beaucoup plus simple. On génère une clef :";;
let key = Aes.generate_key ();;
pff key;;
pf "On l'utilise pour chiffrer des messages (ici 'Bonjour Bob') : ";;
let chiffre = Aes.encrypt key "Bonjour Bob";;
pf chiffre;;
pf "Mais aussi pour déchiffrer :";;
let dechiffre = Aes.decrypt key chiffre;;
pff dechiffre;;

pf "On peut chiffrer des messages arbitrairement long grâce à la librairie cryptokit : ";;
pff (Aes.encrypt key dream);;

pf "Et surtout on a implémenté une version déterministe de l'algorithme de génération de clef : 
à partir d'un hashé de 256 bits ..."
let h = Dr.safe_hash (Aes.random_string 50);;
pzf h;;
pf "... on génère toujours la même clef AES :";;
pf (Aes.generate_key_deterministe h);;
pf (Aes.generate_key_deterministe h);;
pff (Aes.generate_key_deterministe h);;

pff "Cela nous sera très utile pour la suite";;

(* Double Ratchet *)

pff " * * * * * * * * * * Algorithme du Double Ratchet * * * * * * * * * * ";;

pff "L'algorithme du Double Ratchet (anciennement Axolotl Ratchet) est un algorithme de 
gestion de clés cryptographique développé en 2013. Il est utilisé par de nombreux services 
de messagerie instantanée (Signal et WhatsApp par exemple) pour chiffrer les conversations
de bout en bout, avec des hypothèses de sécurité interressante.\n
Décrire le fonctionnement de l'algorithme ici serait long et peu interressant donc le lecteur 
est invité à regarder cette vidéo https://www.youtube.com/watch?v=9sO2qdTci-s (11 minutes) et 
à admirer son fonctionnement"

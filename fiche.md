# Introduction à la cryptographie moderne

## 1. Descriptif

* Objectif : Implémentation de 3 cryptosystèmes parmis les plus utilisés aujourd'hui
* Prérequis : OCaml 19
* Difficulté : * * * ( * )
* Structure : Les parties 3, 4 et 5 dépendent de la partie 2. Les parties 3, 4 et 5 sont largement indépendantes entre elles (il est recommandé d'utiliser 4 dans 5 mais ce n'est pas obligatoire)

## 2. Prérequis - *
* Se préparer un bon chocolat chaud
* Facultatif : Trouver introduction rapide à la cryptographie (par ex : https://www.youtube.com/watch?v=jhXCTbFnK8o, 12 minutes)
* Recommandé : Emprunter *Introduction to Cryptography* de Johannes A. Buchmann (2nd édition) à la bibliothèque (très utile, surtout pour les parties 3 et 4 avec des exemples pour tester ses fonctions)
* Obligatoire : installer la librairie Zarith d'OCaml et apprendre à compiler des fichiers utilisant le module Z.

## 3. RSA - * ( * )
Le chiffrement RSA est un algorithme de cryptographie asymétrique découvert en 1978. Il est toujours très utilisé aujourd'hui, notamment pour sécuriser les échanges sur internet (OpenSSL,  OpenPGP).

### Documentation
* Facultatif : *Introduction to Cryptography* (Johannes A. Buchmann, 2nd édition), chapitre 7 : **Prime number generation**
* Facultatif : *Introduction to Cryptography* (Johannes A. Buchmann, 2nd édition), chapitre 8.3 : **RSA cryptosystem**
* Wikipedia (en) pour toute notion manquante

### Implémentation
* Implémenter un générateur de nombres premiers industriels
    + Bonus ( * ) : ne pas utiliser `Z.probab_prime` ni `Z.next_prime` (de la librairie Zarith) sauf éventuellement pour tester ses propres fonctions. *Indication : regarder les tests de primalité de Fermat et de Miller-Rabin*
    + Bonus : Les nombres premiers générés doivent être résistant à l'attaque p-1 de Pollard
* Implémenter un cryptosystème RSA pour des entiers de taille négligeable devant la taille des clefs
* Bonus : modifier les fonctions pour qu'elles puissent chiffrer du texte

## 4. AES - * *
L'Advanced Encryption Standard (AES), issu du chiffrement Rijndael, est un algorithme de cryptographie symétrique de la fin des années 90. C'est l'algorithme standard de chiffrement symétrique et est utilisé quasiment partout aujourd'hui.

### Documentation
* Introduction : https://www.youtube.com/watch?v=O4xNJsjtN6E
* Facultatif : *Introduction to Cryptography* (Johannes A. Buchmann, 2nd édition), chapitre 6 : **AES** 
* Wikipedia (en) pour toute notion manquante

### Implémentation (TODO)
* TODO

## 5. Double Ratchet - * * *
L'algorithme du Double Ratchet (anciennement Axolotl Ratchet) est un algorithme de gestion de clés cryptographique développé en 2013. Il est utilisé par de nombreux services de messagerie instantanée (Signal et WhatsApp par exemple) pour chiffrer les conversations **de bout en bout**.

### Documentation
* Introduction à Diffie Hellman https://www.youtube.com/watch?v=Yjrfm_oRO0w
* Facultatif : *Introduction to Cryptography* (Johannes A. Buchmann, 2nd édition), chapitre 8.5 : **Diffie-Hellman Key Exchange**
* Sinon Diffie-Hellman wikipedia
* Introduction au Double Ratchet : https://www.youtube.com/watch?v=9sO2qdTci-s et wikipedia 
* INDISPENSABLE : https://signal.org/docs/specifications/doubleratchet/

### Implémentation (TODO)
* Implémenter Diffie-Hellman
* Implémenter KDF
* Implémenter Double Ratchet
    + *Indication : Utiliser AES (implémenté en partie 4) comme fonction de chiffrement symétrique. On pourra s'en passer en utilisant la librairie cryptotool de Ocaml.
      *****************************************************************
      *        C O P Y  E C H A N G E  S S - P R O G R A M M E         
      *        -----------------------------------------------
      *****************************************************************
      * Clause COPY pour echanger donnees entre prog./ss-prog TLMCON
      * Longueur d'echange : 400 caracteres.
      *****************************************************************
      *   Donnee d'echange prog./ss-prog. - TLMCON (table contact)
       01 :PROG:.
      *****************************************************************
      *    Donnees en entree
      ***************************************************************** 
        05 :PROG:-ENT               PIC  X(400).
      *****************************************************************
      *           Donnees pour une LECTURE TLMCON (CONTACT)
      *****************************************************************
        05 :PROG:-ENT-LEC REDEFINES :PROG:-ENT.
      *       Identifiant
           10 :PROG:-ENT-LEC-ID     PIC  X(6).
      *       Remplissage du reste de la chaine
           10 FILLER                PIC  X(394).
      *****************************************************************
      *         Donnees pour une SUPPRESSION TLMCON (CONTACT)
      *****************************************************************
        05 :PROG:-ENT-SUP REDEFINES :PROG:-ENT.
      *       Identifiant
           10 :PROG:-ENT-SUP-ID     PIC  X(6).
      *       Remplissage du reste de la chaine
           10 FILLER                PIC  X(394).
      *****************************************************************
      *         Donnees pour une MODIFICATION TLMCON (CONTACT)
      *****************************************************************
        05 :PROG:-ENT-MAJ REDEFINES :PROG:-ENT.
      *       Identifiant
           10 :PROG:-ENT-MAJ-ID     PIC  X(6).
      *       Nom
           10 :PROG:-ENT-MAJ-NOM    PIC  X(35).
      *       Prenom
           10 :PROG:-ENT-MAJ-PRENOM PIC  X(35).
      *       Numero de telephone
           10 :PROG:-ENT-MAJ-TEL    PIC  X(10).
      *       Adresse courriel
           10 :PROG:-ENT-MAJ-MEL    PIC  X(80).
      *       Note
           10 :PROG:-ENT-MAJ-NOTE   PIC  X(80).
      *       Prospect de rattache
           10 :PROG:-ENT-MAJ-PID    PIC  X(6).
      *       Remplissage du reste de la chaine
           10 FILLER                PIC  X(148).
      *****************************************************************
      *             Donnees pour un AJOUT TLMCON (CONTACT)
      *****************************************************************
        05 :PROG:-ENT-AJO REDEFINES :PROG:-ENT.
      *       Identifiant
           10 :PROG:-ENT-AJO-ID     PIC  X(06).
      *       Nom
           10 :PROG:-ENT-AJO-NOM    PIC  X(35).
      *       Prenom
           10 :PROG:-ENT-AJO-PRENOM PIC  X(35).
      *       Numero de telephone
           10 :PROG:-ENT-AJO-TEL    PIC  X(10).
      *       Adresse courriel
           10 :PROG:-ENT-AJO-MEL    PIC  X(80).
      *       Note
           10 :PROG:-ENT-AJO-NOTE   PIC  X(80).
      *       Prospect de rattache
           10 :PROG:-ENT-AJO-PID    PIC  X(6).
      *       Remplissage du reste de la chaine
           10 FILLER                PIC  X(148).
      *****************************************************************
      *     Donnees en sortie
      *****************************************************************
        05 :PROG:-SOR              PIC X(400).
      *****************************************************************
      *         Donnees en sortie apres LECTURE TLMCON (CONTACT)
      *****************************************************************
        05 :PROG:-SOR-LEC REDEFINES :PROG:-SOR.
      *       Identifiant
           10 :PROG:-SOR-LEC-ID     PIC  X(6).
      *       Nom
           10 :PROG:-SOR-LEC-NOM    PIC  X(35).
      *       Prenom
           10 :PROG:-SOR-LEC-PRENOM PIC  X(35).
      *       Numero de telephone
           10 :PROG:-SOR-LEC-TEL    PIC  X(10).
      *       Adresse courriel
           10 :PROG:-SOR-LEC-MEL    PIC  X(80).
      *       Note
           10 :PROG:-SOR-LEC-NOTE   PIC  X(80).
      *       Prospect de rattache
           10 :PROG:-SOR-LEC-PID    PIC  X(6).
      *       Remplissage du reste de la chaine
           10 FILLER                PIC  X(148).
      *****************************************************************
      *      Donnees en sortie apres un AJOUT TLMCON (CONTACT)
      *****************************************************************
        05 :PROG:-SOR-AJO REDEFINES :PROG:-SOR.
      *       Identifiant
           10 :PROG:-SOR-AJO-ID    PIC  X(6).
      *       Remplissage du reste de la chaine
           10 FILLER               PIC  X(394).

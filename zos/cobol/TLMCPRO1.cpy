      *****************************************************************
      *        C O P Y  E C H A N G E  S S - P R O G R A M M E         
      *        -----------------------------------------------
      *****************************************************************
      * Clause COPY pour echanger donnees entre prog./ss-prog TLMPRO
      * Longueur d'echange : 400 caracteres.
      *****************************************************************
      *   Donnee d'echange prog./ss-prog. - TLMPRO (table prospect)
       01 :PROG:.
      *****************************************************************
      *    Donnees en entree
      ***************************************************************** 
        05 :PROG:-ENT              PIC  X(400).
      *****************************************************************
      *           Donnees pour une LECTURE TMLPRO (PROSPECT)
      *****************************************************************
        05 :PROG:-ENT-LEC REDEFINES :PROG:-ENT.
      *       Identifiant
           10 :PROG:-ENT-LEC-ID    PIC  X(6).
      *       Remplissage du reste de la chaine
           10 FILLER               PIC  X(394).
      *****************************************************************
      *         Donnees pour une SUPPRESSION TMLPRO (PROSPECT)
      *****************************************************************
        05 :PROG:-ENT-SUP REDEFINES :PROG:-ENT.
      *       Identifiant
           10 :PROG:-ENT-SUP-ID    PIC  X(6).
      *       Remplissage du reste de la chaine
           10 FILLER               PIC  X(394).
      *****************************************************************
      *     Donnees en sortie
      *****************************************************************
        05 :PROG:-SOR              PIC X(400).
        05 :PROG:-SOR-LEC REDEFINES :PROG:-SOR.
      *       Identifiant
           10 :PROG:-SOR-LEC-ID    PIC  X(6).
      *       Nom
           10 :PROG:-SOR-LEC-NOM   PIC  X(35).
      *       Rue
           10 :PROG:-SOR-LEC-RUE   PIC  X(40).
      *       Code postal
           10 :PROG:-SOR-LEC-CP    PIC  X(5).
      *       Ville
           10 :PROG:-SOR-LEC-VILLE PIC  X(35).
      *       Remplissage du reste de la chaine
           10 FILLER               PIC  X(279).

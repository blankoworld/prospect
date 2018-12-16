
      *****************************************************************
      *               E N R E G I S T R E M E N T   B D D             *
      *               -----------------------------------             *
      *****************************************************************
      * Clause COPY pour lire un enregistrement de la base de donnees *
      * Longueur de la chaine : 800 caracteres                        *
      *****************************************************************
      *   Description de la structure de l'enregistrement
       01 :PROG:-ENR.
      *    Enregistrement d'un prospect
           05 :PROG:-ENR-PRO.
      *      Identifiant
             10 :PROG:-ENR-PRO-ID      PIC  X(06).
      *      Nom
             10 :PROG:-ENR-PRO-NOM     PIC  X(35).
      *      Rue
             10 :PROG:-ENR-PRO-RUE     PIC  X(40).
      *      Code postal
             10 :PROG:-ENR-PRO-CP      PIC  X(05).
      *      Ville
             10 :PROG:-ENR-PRO-VILLE   PIC  X(35).
      *      Remplissage du reste de la chaine
             10 FILLER                 PIC  X(279).
      *    Enregistrement d'un contact
           05 :PROG:-ENR-CON.
             10 :PROG:-ENR-CON-ID      PIC  X(06).
             10 :PROG:-ENR-CON-NOM     PIC  X(35).
             10 :PROG:-ENR-CON-PRENOM  PIC  X(35).
             10 :PROG:-ENR-CON-TEL     PIC  X(10).
             10 :PROG:-ENR-CON-MEL     PIC  X(80).
             10 :PROG:-ENR-CON-NOTE    PIC  X(80).
             10 :PROG:-ENR-CON-PID     PIC  X(06).
             10 FILLER                 PIC  X(148).
      *
      *****************************************************************
      *                     F I N   D E   C O P Y                     * 
      *****************************************************************

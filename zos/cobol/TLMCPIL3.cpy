      *****************************************************************
      *                 F I C H I E R  P I L O T A G E                *
      *                 ------------------------------                *
      *****************************************************************
      * Clause COPY pour lire un fichier de pilotage concernant       *
      *    les prospects et leurs contacts                            *
      * Longueur de la chaine : 800 caracteres                        *
      *****************************************************************
      *   Description de la structure du fichier de pilotage
       01 :PROG:-PIL.
      *    Caractere de pilotage
           05 :PROG:-PIL-CMD           PIC  X.
      *        Ajout d'un element (code A)
               88 :PROG:-PIL-CMD-AJO          VALUE 'A'.
      *        Mise a jour d'un element (code M)
               88 :PROG:-PIL-CMD-MAJ          VALUE 'M'.
      *        Suppression d'un element (code S)
               88 :PROG:-PIL-CMD-SUP          VALUE 'S'.
      *        Carateres de pilotage valides
               88 :PROG:-PIL-CMD-VALIDE       VALUE 'A','M','S'.
      *    Enregistrement d'un prospect
           05 :PROG:-PIL-PRO.
      *      Identifiant
             10 :PROG:-PIL-PRO-ID      PIC  X(06).
      *      Nom
             10 :PROG:-PIL-PRO-NOM     PIC  X(35).
      *      Rue
             10 :PROG:-PIL-PRO-RUE     PIC  X(40).
      *      Code postal
             10 :PROG:-PIL-PRO-CP      PIC  X(05).
      *      Ville
             10 :PROG:-PIL-PRO-VILLE   PIC  X(35).
      *      Remplissage du reste de la chaine
             10 FILLER                 PIC  X(279).
      *    Enregistrement d'un contact
           05 :PROG:-PIL-CON.
             10 :PROG:-PIL-CON-ID      PIC  X(06).
             10 :PROG:-PIL-CON-NOM     PIC  X(35).
             10 :PROG:-PIL-CON-PRENOM  PIC  X(35).
             10 :PROG:-PIL-CON-TEL     PIC  X(10).
             10 :PROG:-PIL-CON-MEL     PIC  X(80).
             10 :PROG:-PIL-CON-NOTE    PIC  X(80).
             10 :PROG:-PIL-CON-PID     PIC  X(06).
             10 FILLER                 PIC  X(148).
      *
      *****************************************************************
      *                     F I N   D E   C O P Y                     * 
      *****************************************************************

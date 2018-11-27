      *****************************************************************
      *                   C O U C H E  L O G I Q U E                   
      *                   --------------------------
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.      PROSLSEL.
       AUTHOR.          Olivier DOSSMANN.
       DATE-WRITTEN.    20181126.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. ZIA.
       OBJECT-COMPUTER. VIRTEL.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
      *   Couche physique
       01 w-parametres.
      *        Fonction choisie
            05 w-parametres-fx PIC X(6).
      *   Code retour
       01 w-rc                 PIC X(2).
       PROCEDURE DIVISION USING w-parametres w-rc.
       DEBUT.
      *    Envoi d'une demande de SELECT a la couche physique
           MOVE 'SELECT'   TO    w-parametres-fx.
           CALL 'PROSPSEL' USING w-parametres w-rc.
       END PROGRAM PROSLSEL.

      *****************************************************************
      * Couche physique (acces aux donnees)
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.      PROSPSEL INITAL.
       AUTHOR.          Olivier DOSSMANN.
       DATE-WRITTEN.    20181122.
      
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. ZIA.
       OBJECT-COMPUTER. VIRTEL.
       DATA DIVISION.
       LINKAGE SECTION.
      *   Code retour du programme appelant
       77 code-retour       PIC X(2).
      *   Parametres envoyes par le programme appelant
       01 parametres.
      *       Fonction appelee
           05 parametres-fx PIC X(5).

       WORKING-STORAGE SECTION.
       77 lecture-eot       PIC  9 VALUE 0.
           EXEC SQL
             INCLUDE SQLCA
           END-EXEC.
           EXEC SQL
             INCLUDE PROSCPRO
           END-EXEC.
       PROCEDURE DIVISION using parametres code-retour.
       DEBUT.
           DISPLAY 'CP - Parametres: ' parametres-fx.
           PERFORM LECTURE-INIT.
           PERFORM LECTURE-TRT      UNTIL lecture-eot = 1.
           PERFORM LECTURE-FIN.
           STOP RUN.
       LECTURE-INIT.
           MOVE 0 TO lecture-eot.
       LECTURE-TRT.
           DISPLAY 'CP - Lecture: ' WITH NO ADVANCING.
           EXEC SQL
             SELECT NOM
               INTO :prospect.nom
             FROM TRAIN04.PROSPECT
           END-EXEC.
           DISPLAY nom of prospect.
           MOVE 1 to lecture-eot.
       LECTURE-FIN.
           CONTINUE.
       END PROGRAM PROSPSEL.

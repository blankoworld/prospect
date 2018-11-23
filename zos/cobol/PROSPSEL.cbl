      *****************************************************************
      * Couche physique (acces aux donnees)
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROSPSEL.
       AUTHOR. Olivier DOSSMANN.
       DATE-WRITTEN. 20181122.
      
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. ZIA.
       OBJECT-COMPUTER. VIRTEL.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77 lecture-eot PIC 9 VALUE 0.
       77 nom PIC X(35).
           EXEC SQL
             INCLUDE SQLCA
           END-EXEC.
           EXEC SQL
             INCLUDE PROSCPRO
           END-EXEC.
       PROCEDURE DIVISION.
       DEBUT.
           PERFORM LECTURE-INIT.
           PERFORM LECTURE-TRT UNTIL lecture-eot = 1.
           PERFORM LECTURE-FIN.
           GOBACK.
       LECTURE-INIT.
           MOVE 0 TO lecture-eot.
       LECTURE-TRT.
           DISPLAY 'CP - Lecture: ' WITH NO ADVANCING.
           EXEC SQL
             SELECT NOM
             INTO :nom
             FROM TRAIN04.PROSPECT
           END-EXEC.
           DISPLAY nom.
       LECTURE-FIN.
           CONTINUE.
       END PROGRAM PROSPSEL.

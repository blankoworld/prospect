      *****************************************************************
      *                  C O U C H E  P H Y S I Q U E
      *                  ----------------------------
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.      PROSPSEL.
       AUTHOR.          Olivier DOSSMANN.
       DATE-WRITTEN.    20181122.
      
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. ZIA.
       OBJECT-COMPUTER. VIRTEL.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77 lecture-eot       PIC  9 VALUE 0.
           EXEC SQL
             INCLUDE SQLCA
           END-EXEC.
           EXEC SQL
             INCLUDE DCLPRO
           END-EXEC.
       LINKAGE SECTION.
       COPY TLMCPIL.
       PROCEDURE DIVISION using tlmcpil.
       DEBUT.
           DISPLAY 'CP - Parametres: ' tlmcpil-fct.
           PERFORM LECTURE-INIT.
           PERFORM LECTURE-TRT      UNTIL lecture-eot = 1.
           PERFORM LECTURE-FIN.
           GOBACK.
       LECTURE-INIT.
           MOVE 0 TO lecture-eot.
       LECTURE-TRT.
           DISPLAY 'CP - Lecture: ' WITH NO ADVANCING.
           EXEC SQL
             SELECT NOM
               INTO :tlmpro-nom
             FROM TRAIN04.TLMPRO
           END-EXEC.
           DISPLAY tlmpro-nom.
           MOVE tlmpro-nom TO tlmcpil-msg.
           MOVE 1 to lecture-eot.
       LECTURE-FIN.
           CONTINUE.
       END PROGRAM PROSPSEL.

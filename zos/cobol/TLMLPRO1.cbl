      *****************************************************************
      *                   C O U C H E  L O G I Q U E
      *                   --------------------------
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.      TLMLPRO1.
       AUTHOR.          Olivier DOSSMANN.
       DATE-WRITTEN.    20181126.
      
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. ZIA.
       OBJECT-COMPUTER. VIRTEL.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *   Couche physique
           COPY TLMCPIL.
           COPY TLMCPRO1 REPLACING ==:PROG:== BY ==PGM1==.
       PROCEDURE DIVISION.
       DEBUT.
           DISPLAY 'CL - Lancement CP:' WITH NO ADVANCING.
      *    Envoi d'une demande de SELECT a la couche physique
           MOVE 'SELECT'   TO    tlmcpil-fct.
           MOVE '000100'   TO    pgm1-ent-lec-id.
           CALL 'TLMPPRO1' USING tlmcpil pgm1.
           DISPLAY 'CL - TLMCPIL-MSG <' tlmcpil-msg '>'.
           DISPLAY 'CL - termine'.
           GOBACK.
       END PROGRAM TLMLPRO1.

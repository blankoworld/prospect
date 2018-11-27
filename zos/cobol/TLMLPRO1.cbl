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
      *   Couche physique
       COPY TLMCPIL.
       PROCEDURE DIVISION.
       DEBUT.
           DISPLAY 'CL - Lancement CP:' WITH NO ADVANCING.
      *    Envoi d'une demande de SELECT a la couche physique
           MOVE 'SELECT'   TO    tlmcpil-fct.
           CALL 'PROSPSEL' USING tlmcpil.
           DISPLAY 'CL - TLMCPIL-MSG <' tlmcpil-msg '>'.
           DISPLAY 'CL - termine'.
           GOBACK.
       END PROGRAM PROSLSEL.

      *****************************************************************
      *                  C O U C H E  P H Y S I Q U E
      *                  ----------------------------
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.      TLMPPRO1.
       AUTHOR.          Olivier DOSSMANN.
       DATE-WRITTEN.    20181122.
      
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. ZIA.
       OBJECT-COMPUTER. VIRTEL.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *    Infos concernant la connexion a la BDD
           EXEC SQL
             INCLUDE SQLCA
           END-EXEC.
      *    Clause COPY generee par DCLGEN pour table TLMPRO (prospect)
           EXEC SQL
             INCLUDE DCLPRO
           END-EXEC.
       77 SQLCODE-TXT     PIC S9(3).
       77 SQLERR-MSG      PIC X(30).
       LINKAGE SECTION.
      *    Clause COPY pour structure d'echange prog. <-> sous-prog.
           COPY TLMCPIL.
      *    Clause COPY pour echange prog./ss-prog. avec donnees
           COPY TLMCPRO1 REPLACING ==:PROG:== BY ==cppro1==.
       PROCEDURE DIVISION using tlmcpil cppro1.
       DEBUT.
           PERFORM INIT.
           PERFORM TRAITEMENT.
           PERFORM FIN.
           GOBACK.

       INIT.
           DISPLAY 'PHY-init' tlmcpil-fct
           MOVE SPACES TO cppro1-sor
           .

       TRAITEMENT.
      *    Lecture fonction pour lancement
           EVALUATE tlmcpil-fct
             WHEN 'SELECT'          PERFORM LECTURE
             WHEN 'UPDATE'          PERFORM MAJ
             WHEN 'DELETE'          PERFORM SUPPRESSION
             WHEN 'ADD'             PERFORM AJOUT
           END-EVALUATE
           .

       LECTURE.
           DISPLAY 'PHY-LEC' WITH NO ADVANCING
           MOVE cppro1-ent-lec-id TO tlmpro-id
           IF cppro1-ent-lec-id NOT = SPACES THEN
             DISPLAY ' <' tlmpro-id '>'
      *      Lecture de l'enregistrement
             EXEC SQL
               SELECT
                 NOM,
                 ADDR_RUE,
                 ADDR_CP,
                 ADDR_VILLE
               INTO
                 :tlmpro-nom,
                 :tlmpro-addr-rue,
                 :tlmpro-addr-cp,
                 :tlmpro-addr-ville
               FROM TRAIN04.TLMPRO
               WHERE ID=:tlmpro-id
             END-EXEC
      *      Verification SQLCODE
             PERFORM VERIF-SQLCODE
             IF SQLCODE = 0 OR SQLCODE = 100 THEN
               MOVE tlmpro-nom        TO cppro1-sor-lec-nom
               MOVE tlmpro-addr-rue   TO cppro1-sor-lec-rue
               MOVE tlmpro-addr-cp    TO cppro1-sor-lec-cp
               MOVE tlmpro-addr-ville TO cppro1-sor-lec-ville
             END-IF
           ELSE
             MOVE '01' TO tlmcpil-rc
             MOVE 'CP, Lecture: ID prospect non renseigne.'
               TO tlmcpil-msg
             DISPLAY ' None'
           END-IF
           .

       MAJ.
           CONTINUE.

       SUPPRESSION.
           DISPLAY 'PHY-SUP' WITH NO ADVANCING
           MOVE cppro1-ent-sup-id TO tlmpro-id
           IF cppro1-ent-sup-id NOT = SPACES THEN
             DISPLAY ' <' tlmpro-id '>'
             EXEC SQL
               DELETE
               FROM TRAIN04.TLMPRO
               WHERE ID=:tlmpro-id
             END-EXEC
             PERFORM VERIF-SQLCODE
             IF SQLCODE = 0 OR SQLCODE = 100 THEN
               MOVE '00' to tlmcpil-rc
               STRING
                 'OK, DEL <'
                 tlmpro-id
                 '>'
                 DELIMITED size
                 INTO tlmcpil-msg
               END-STRING
             END-IF
           .

       AJOUT.
           CONTINUE.

       FIN.
           CONTINUE.

       VERIF-SQLCODE.
           EVALUATE sqlcode
             WHEN 0
               MOVE '00'    TO tlmcpil-rc
               MOVE 'CP, Requete terminee avec succes.' TO tlmcpil-msg
             WHEN 100
               MOVE '10'    TO tlmcpil-rc
               MOVE 'CP, Ligne non trouvee ou fin du curseur' TO
               tlmcpil-msg
             WHEN OTHER
               MOVE '99'    TO tlmcpil-rc
               MOVE sqlcode TO sqlcode-txt
               MOVE sqlerrm TO sqlerr-msg
               STRING
                 'ERR, <'
                 sqlcode-txt
                 '><'
                 sqlerr-msg
                 DELIMITED SIZE
                 INTO tlmcpil-msg
               END-STRING
           END-EVALUATE
           .

       END PROGRAM TLMPPRO1.

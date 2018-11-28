      *****************************************************************
      *                  C O U C H E  P H Y S I Q U E
      *                  ----------------------------
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.      TLMPCON2.
       AUTHOR.          Olivier DOSSMANN.
       DATE-WRITTEN.    20181128.
      
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
      *    Clause COPY generee par DCLGEN pour table TLMCON (contact)
           EXEC SQL
             INCLUDE DCLCON
           END-EXEC.
       77 SQLCODE-TXT     PIC S9(3).
       77 SQLERR-MSG      PIC X(30).
       LINKAGE SECTION.
      *    Clause COPY pour structure d'echange prog. <-> sous-prog.
           COPY TLMCPIL.
      *    Clause COPY pour echange prog./ss-prog. avec donnees
           COPY TLMCCON2 REPLACING ==:PROG:== BY ==cpcon2==.
       PROCEDURE DIVISION using tlmcpil cpcon2.
       DEBUT.
           PERFORM INIT.
           PERFORM TRAITEMENT.
           PERFORM FIN.
           GOBACK.

       INIT.
           DISPLAY 'PHY-init' tlmcpil-fct
           MOVE SPACES TO cpcon2-sor
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
           DISPLAY 'PHY-LEC'          WITH NO ADVANCING
           MOVE cpcon2-ent-lec-id     TO tlmcon-id
           IF cpcon2-ent-lec-id NOT = SPACES THEN
             DISPLAY ' <' tlmcon-id '>'
      *      Lecture de l'enregistrement
             EXEC SQL
               SELECT
                 NOM,
                 PRENOM,
                 TEL,
                 MEL,
                 NOTE,
                 PID
               INTO
                 :tlmcon-nom,
                 :tlmcon-prenom,
                 :tlmcon-tel,
                 :tlmcon-mel,
                 :tlmcon-note,
                 :tlmcon-pid
               FROM TRAIN04.TLMCON
               WHERE ID=:tlmcon-id
             END-EXEC
      *      Verification SQLCODE
             PERFORM VERIF-SQLCODE
             IF SQLCODE = 0 OR SQLCODE = 100 THEN
               MOVE tlmcon-nom        TO cpcon2-sor-lec-nom
               MOVE tlmcon-prenom     TO cpcon2-sor-lec-prenom
               MOVE tlmcon-tel        TO cpcon2-sor-lec-tel
               MOVE tlmcon-mel        TO cpcon2-sor-lec-mel
               MOVE tlmcon-note       TO cpcon2-sor-lec-note
               MOVE tlmcon-pid        TO cpcon2-sor-lec-pid
             END-IF
           ELSE
             MOVE '01' TO tlmcpil-rc
             MOVE 'PHY-LEC: code contact vide.'
               TO tlmcpil-msg
             DISPLAY ' None'
           END-IF
           .

       MAJ.
           DISPLAY 'PHY-MAJ'                     WITH NO ADVANCING
           MOVE cpcon2-ent-maj-id                TO tlmcon-id
           IF cpcon2-ent-maj-id NOT = SPACES THEN
             DISPLAY ' <' tlmcon-id '>'
             MOVE cpcon2-ent-maj-nom             TO tlmcon-nom
             MOVE cpcon2-ent-maj-prenom          TO tlmcon-prenom
             MOVE cpcon2-ent-maj-tel             TO tlmcon-tel
             MOVE cpcon2-ent-maj-mel             TO tlmcon-mel
             MOVE cpcon2-ent-maj-note            TO tlmcon-note
             MOVE cpcon2-ent-maj-pid             TO tlmcon-pid
             EXEC SQL
               UPDATE TRAIN04.TLMCON
               SET
                 NOM    = :tlmcon-nom,
                 PRENOM = :tlmcon-prenom,
                 TEL    = :tlmcon-tel,
                 MEL    = :tlmcon-mel,
                 NOTE   = :tlmcon-note,
                 PID    = :tlmcon-pid
               WHERE
                 ID         = :tlmcon-id
             END-EXEC
             PERFORM VERIF-SQLCODE
           ELSE
             MOVE '01'                           TO tlmcpil-rc
             MOVE 'PHY-MAJ: code contact vide.' TO tlmcpil-msg
             DISPLAY ' None'
           END-IF
           .

       SUPPRESSION.
           DISPLAY 'PHY-SUP'                     WITH NO ADVANCING
           MOVE cpcon2-ent-sup-id                TO tlmcon-id
           IF cpcon2-ent-sup-id NOT = SPACES THEN
             DISPLAY ' <' tlmcon-id '>'
             EXEC SQL
               DELETE
               FROM TRAIN04.TLMCON
               WHERE ID=:tlmcon-id
             END-EXEC
             PERFORM VERIF-SQLCODE
      *      Code retour du succes du traitement (cas echeant
      *      verifie par VERIF-SQLCODE precedemment)
             IF SQLCODE = 0 OR SQLCODE = 100 THEN
               MOVE '00'                         TO tlmcpil-rc
               STRING
                 'OK, DEL <'
                 tlmcon-id
                 '>'
                 DELIMITED size
                 INTO tlmcpil-msg
               END-STRING
             END-IF
           ELSE
             MOVE '01'                           TO tlmcpil-rc
             MOVE 'PHY-SUP: code contact vide.' TO tlmcpil-msg
             DISPLAY ' None'
           END-IF
           .

       AJOUT.
           DISPLAY 'PHY-AJO'                     WITH NO ADVANCING
           MOVE cpcon2-ent-ajo-nom               TO tlmcon-nom
           MOVE cpcon2-ent-ajo-prenom            TO tlmcon-prenom
           MOVE cpcon2-ent-ajo-tel               TO tlmcon-tel
           MOVE cpcon2-ent-ajo-mel               TO tlmcon-mel
           MOVE cpcon2-ent-ajo-note              TO tlmcon-note
           MOVE cpcon2-ent-ajo-pid               TO tlmcon-pid
           EXEC SQL
           SELECT ID
             INTO :tlmcon-id
             FROM FINAL TABLE (
               INSERT INTO TRAIN04.TLMCON (
                 NOM,
                 PRENOM,
                 TEL,
                 MEL,
                 NOTE,
                 PID
               VALUES (
                   :tlmcon-nom,
                   :tlmcon-prenom,
                   :tlmcon-tel,
                   :tlmcon-mel,
                   :tlmcon-note,
                   :tlmcon-pid)
                   )
           END-EXEC
           PERFORM VERIF-SQLCODE
      *    Code retour du succes
           IF SQLCODE = 0 OR SQLCODE = 100 THEN
             MOVE tlmcon-id                      TO cpcon2-sor-ajo-id
             MOVE '00'                           TO tlmcpil-rc
             STRING
               'OK, AJO <'
               cpcon2-sor-ajo-id
               '>'
               DELIMITED size
               INTO tlmcpil-msg
             END-STRING
           END-IF
           .

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

       END PROGRAM TLMPCON2.

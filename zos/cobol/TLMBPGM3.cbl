      *****************************************************************
      *                    C O U C H E  M E T I E R
      *                    ------------------------
      *****************************************************************
      * APPLICATION      : MAJ TLMPRO & TLMCON DEPUIS FIC. PILOTE.
      * NOM DU PROGRAMME : TLMBPGM3
      * DESCRIPTION      : PROGRAMME BATCH DE MISE A JOUR DES TABLES
      *    TLMPRO & TLMCON DEPUIS UN FICHIER DE PILOTAGE
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.      TLMBPGM3.
       AUTHOR.          Olivier DOSSMANN.
       DATE-WRITTEN.    20181129.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. ZIA.
       OBJECT-COMPUTER. VIRTEL.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      *    Fichier de pilotage contenant les mises a jour
           SELECT pilote ASSIGN TO PILOTAGE.
      *    Fichier de journalisation (logs)
           SELECT log    ASSIGN TO JOURNAUX.
       DATA DIVISION.
       FILE SECTION.
      * TODO: FILE STATUS
       FD pilote RECORDING MODE F.
       COPY TLMCPIL3 REPLACING ==:PROG:== BY ==f==.
       FD log RECORDING MODE F.
       01 f-log                          PIC   X(80).
       WORKING-STORAGE SECTION.
       01 w-fin-fic                      PIC   9.
           88 w-fin-fic-oui                      VALUE 1.
           88 w-fin-fic-non                      VALUE 0.
       01 w-pro                          PIC   X(03).
           88 w-pro-abs                          VALUE 'ABS'.
           88 w-pro-pre                          VALUE 'PRE'.
       01 w-err                          PIC   9.
           88 w-err-oui                          VALUE 1.
           88 w-err-non                          VALUE 0.
      *****************************************************************
      * COMPTEURS pour l'edition du rapport
      *****************************************************************
      *
      *   Compteurs divers pour l'edition du compte-rendu de traitement
       01 w-compteur.
      *       Nombre de lignes lues en entree
           05 w-cpt-lec                  PIC  S9(07) COMP-3.
      *       Nombre d'erreurs rencontrees
           05 w-cpt-err                  PIC  S9(07) COMP-3.
      *       Nombre de lignes ajoutees avec succes
           05 w-cpt-ajo                  PIC  S9(07) COMP-3.
      *       Nombre de lignes mises a jour avec succes
           05 w-cpt-maj                  PIC  S9(07) COMP-3.
      *       Nombre de lignes supprimees avec succes
           05 w-cpt-sup                  PIC  S9(07) COMP-3.
      *       Nombre de lignes rejetees
           05 w-cpt-rej                  PIC  S9(07) COMP-3.
      *       Nombre de lignes traitees avec succes
           05 w-cpt-tot                  PIC  S9(07) COMP-3.
      *
      *   Affichage nombre lignes lues en entree
       01 w-rap-lec.
           05 FILLER                     PIC   X(43) VALUE
                'Nombre de lectures :                       '.
           05 w-rap-lec-nbr              PIC   ZZZBZZ9.
      *   Affichage nombre de lignes ajoutees avec succes
       01 w-rap-ajo.
           05 FILLER                     PIC   X(43) VALUE
                'Nombre d''ajout :                           '.
           05 w-rap-ajo-nbr              PIC   ZZZBZZ9.
      *   Affichage nombre de lignes mises a jour avec succes
       01 w-rap-maj.
           05 FILLER                     PIC   X(43) VALUE
                'Nombre de mise a jour :                    '.
           05 w-rap-maj-nbr              PIC   ZZZBZZ9.
      *   Nombre de lignes supprimees avec succes
       01 w-rap-sup.
           05 FILLER                     PIC   X(43) VALUE
                'Nombre de lignes supprimees :              '.
           05 w-rap-sup-nbr              PIC   ZZZBZZ9.
      *   Nombre de lignes rejetees
       01 w-rap-rej.
           05 FILLER                     PIC   X(43) VALUE
                'Nombre de lignes rejetees :                '.
           05 w-rap-rej-nbr              PIC   ZZZBZZ9.
      *   Nombre de lignes traitees avec succes
       01 w-rap-tot.
           05 FILLER                     PIC   X(43) VALUE
                'Nombre de lignes totales :                 '.
           05 w-rap-tot-nbr              PIC   ZZZBZZ9.
      *****************************************************************

       77 w-enr-log                      PIC   X(80).

      *****************************************************************
      * DONNEES D'ECHANGE AVEC LES ACCESSEURS PHYSIQUES
      *****************************************************************
           COPY TLMCPIL.
           COPY TLMCPRO1 REPLACING ==:PROG:== BY ==CPPRO==.
           COPY TLMCCON2 REPLACING ==:PROG:== BY ==CPCON==.
      *****************************************************************
       PROCEDURE DIVISION.
       DEBUT.
           DISPLAY 'MET, PILOTAGE'
           PERFORM INIT
           PERFORM TRT UNTIL w-fin-fic-oui
           PERFORM FIN
           PERFORM COMPTE-RENDU-EXECUTION
           GOBACK
           .

      *****************************************************************
      * Initialisation de quelques variables.
      * Ouverture du fichier d'entree.
      *****************************************************************
       INIT.
           SET w-fin-fic-non             TO TRUE
           OPEN INPUT pilote
           SET w-err-non                 TO TRUE
      *    Initialisation de tous les compteurs
           MOVE ZERO TO w-cpt-lec
                        w-cpt-err
                        w-cpt-ajo
                        w-cpt-maj
                        w-cpt-sup
                        w-cpt-rej
                        w-cpt-tot
           .

      *****************************************************************
      * Lecture du fichier de pilotage : traitement sur chaque ligne
      *****************************************************************
       TRT.
           DISPLAY 'MET-LEC, enregistrement fic. pilotage'
           READ pilote
               AT END SET w-fin-fic-oui  TO TRUE
               NOT AT END PERFORM TRT-ENR
           END-READ
      *    Lecture effectuee : j'incremente le compteur
           ADD 1                         TO w-cpt-lec
           .

      *****************************************************************
      * Aiguillage du traitement en fonction du premier caractere
      * de l'enregistrement.
      *    A comme AJOUT       (code AJO)
      *    S comme SUPPRESSION (code SUP)
      *    M comme MISE A JOUR (code MAJ)
      *    Autre cas : REJET   (code REJ)
      *****************************************************************
       TRT-ENR.
           EVALUATE F-PIL-CMD
             WHEN 'A'      PERFORM TRT-ENR-AJO
             WHEN 'M'      PERFORM TRT-ENR-MAJ
             WHEN 'S'      PERFORM TRT-ENR-SUP
             WHEN OTHER    PERFORM TRT-ENR-REJ
           .

      *****************************************************************
      * Traitement d'ajout d'un enregistrement : 
      *  - verification si le prospect existe
      *  - si prospect existe : ajout contact
      *  - si prospect n'existe pas : creation 
      *****************************************************************
       TRT-ENR-AJO.
           DISPLAY 'MET-AJO, FX AJOUT'
      *    verification que prospect est present ou absent
           MOVE f-pil-pro-id             TO cppro-ent-lec-id
           PERFORM VRF-PRO-ABS
      *    prospect n'existe pas ? On le cree !
           IF w-pro-abs THEN
             PERFORM CREA-PRO
           END-IF 
      *    creation contact
           MOVE f-pil-con-id             TO cpcon-ent-lec-id
           PERFORM CREA-CON
      *    Ligne ajoutee : j'incremente le compteur
           ADD 1                         TO w-cpt-ajo
           .

      *****************************************************************
      * Mise a jour d'un enregistrement : 
      *   - verification si le prospect existe
      *   - prospect existe : mise a jour contact
      *   - si prospect n'existe pas : creation
      *****************************************************************
       TRT-ENR-MAJ.
           DISPLAY 'MET-MAJ, FX MISE A JOUR'
      *    verification que prospect existe bien
           MOVE f-pil-pro-id             TO cppro-ent-maj-id
           PERFORM VRF-PRO-ABS
      *    prospect absent ? Creation !
           IF w-pro-abs THEN
             PERFORM CREA-PRO
           END-IF
      *    mise a jour contact
           PERFORM MAJ-CON
      *    Ligne mise a jour : j'incremente le compteur
           ADD 1                         TO w-cpt-maj
           .

      *****************************************************************
      * Suppression d'un enregistrement
      *****************************************************************
       TRT-ENR-SUP.
           DISPLAY 'MET-SUP, FX SUPPRESSION'
      *    suppression contact
           PERFORM SUP-CON
      *    Ligne supprimee : j'incremente le compteur
           ADD 1                         TO w-cpt-sup
           .

      *****************************************************************
      * Rejet de l'enregistrement
      *****************************************************************
       TRT-ENR-REJ.
           DISPLAY 'MET-REJ, FX REJET'
      *    rejet de la ligne
           DISPLAY 'Rejet de la ligne pour une raison inconnue'
           DISPLAY '<' f-pil '>'
      *    Ligne rejetee : j'incremente le compteur
           ADD 1                         TO w-cpt-rej
           .

      *****************************************************************
      * Le prospect existe ? Oui ou Non ?
      *   - Oui : W-PRO = 'PRE' comme PRESENT (w-pro-pre)
      *   - Non : W-PRO = 'ABS' comme ABSENT  (w-pro-abs)
      *****************************************************************
       VRF-PRO-ABS.
           DISPLAY 'Verification existence prospect'
           MOVE 'SELECT'                 TO tlmcpil-fct
           CALL 'TLMPPRO1'               USING tlmcpil cppro
           SET w-pro-abs                 TO TRUE
           IF tlmcpil-rc = '00' THEN
               SET w-pro-pre             TO TRUE
           END-IF
           .

      *****************************************************************
      * Creation d'un prospect
      *****************************************************************
       CREA-PRO.
           DISPLAY 'Creation Prospect <' cppro-ent-lec-id '>'
           MOVE f-pil-pro-id             TO cppro-ent-ajo-id
           MOVE f-pil-pro-nom            TO cppro-ent-ajo-nom
           MOVE f-pil-pro-rue            TO cppro-ent-ajo-rue
           MOVE f-pil-pro-cp             TO cppro-ent-ajo-cp
           MOVE f-pil-pro-ville          TO cppro-ent-ajo-ville
           MOVE 'ADD'                    TO tlmcpil-fct
           CALL 'TLMPPRO1'               USING tlmcpil cppro
           PERFORM VRF-COD-RET
           .

      *****************************************************************
      * Creation d'un contact
      *****************************************************************
       CREA-CON.
           DISPLAY 'Creation Contact <' cpcon-ent-lec-id '>'
           MOVE f-pil-con-id             TO cpcon-ent-ajo-id
           MOVE f-pil-con-nom            TO cpcon-ent-ajo-nom
           MOVE f-pil-con-prenom         TO cpcon-ent-ajo-prenom
           MOVE f-pil-con-tel            TO cpcon-ent-ajo-tel
           MOVE f-pil-con-mel            TO cpcon-ent-ajo-mel
           MOVE f-pil-con-note           TO cpcon-ent-ajo-note
           MOVE f-pil-con-pid            TO cpcon-ent-ajo-pid
           MOVE 'ADD'                    TO tlmcpil-fct
           CALL 'TLMPCON2'               USING tlmcpil cpcon
           PERFORM VRF-COD-RET
           .

      *****************************************************************
      * Mise a jour d'un contact
      *****************************************************************
       MAJ-CON.
           DISPLAY 'Mise a jour Contact <' f-pil-con-id '>'
           MOVE f-pil-con-id             TO cpcon-ent-maj-id
           MOVE f-pil-con-nom            TO cpcon-ent-maj-nom
           MOVE f-pil-con-prenom         TO cpcon-ent-maj-prenom
           MOVE f-pil-con-tel            TO cpcon-ent-maj-tel
           MOVE f-pil-con-mel            TO cpcon-ent-maj-mel
           MOVE f-pil-con-note           TO cpcon-ent-maj-note
           MOVE f-pil-con-pid            TO cpcon-ent-maj-pid
           MOVE 'UPDATE'                 TO tlmcpil-fct
           CALL 'TLMPCON2'               USING tlmcpil cpcon
           PERFORM VRF-COD-RET
           .

      *****************************************************************
      * Suppression d'un contact
      *****************************************************************
       SUP-CON.
           DISPLAY 'Suppression Contact <' cpcon-ent-lec-id '>'
           MOVE f-pil-con-id             TO cpcon-ent-sup-id
           MOVE 'DELETE'                 TO tlmcpil-fct
           CALL 'TLMPCON2'               USING tlmcpil cpcon
           PERFORM VRF-COD-RET
           .

      *****************************************************************
      * Verification du code retour contenu dans tlmcpil-rc
      *   - Code '00': tout va bien
      *   - Autre : une erreur s'est produite ==> affichage tlmcpil-msg
      *****************************************************************
       VRF-COD-RET.
           SET w-err-non                 TO TRUE
           IF tlmcpil-rc NOT = '00' THEN
             DISPLAY 'MET-ERR <' tlmcpil-rc '><' tlmcpil-msg '>'
             SET w-err-oui               TO TRUE
      *      Erreur rencontree : j'incremente le compteur
             ADD 1                       TO w-cpt-err
           END-IF
           .

      *****************************************************************
      * Fermeture des fichiers
      *****************************************************************
       FIN.
           CLOSE pilote
      *    Combien de ligne traitees avec succes ? SUP + AJO + MAJ
           ADD w-cpt-ajo w-cpt-maj       TO w-cpt-sup
                                         GIVING w-cpt-tot
           .

      *****************************************************************
      * Envoi un compte rendu d'execution dans un fichier 'log'
      * compose de : 
      *  - une entete
      *  - une liste de compteurs d'ecriture dans la base, insertion,
      *    modification, suppression, etc.
      *  - une enqueue
      *****************************************************************
       COMPTE-RENDU-EXECUTION.
           PERFORM CPT-RENDU-EXEC-INIT
           PERFORM CPT-RENDU-EXEC-TRT
           PERFORM CPT-RENDU-EXEC-FIN
           .

      *****************************************************************
      * Ouverture du fichier de log.
      * Creation de l'entete.
      *****************************************************************
       CPT-RENDU-EXEC-INIT.
           OPEN OUTPUT log
           MOVE SPACES TO f-log
           PERFORM ENTETE
           .

      *****************************************************************
      * Enregistrement des compteurs dans le fichier de log
      *****************************************************************
       CPT-RENDU-EXEC-TRT.
      *    Saut de ligne
           MOVE '                                                 '
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
      *    Affichage des differents compteurs
           MOVE 'Compteurs de lecture(s) du fichier de mise a jour'
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
           MOVE '-------------------------------------------------'
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
      *    Saut de ligne
           MOVE '                                                 '
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
      *    Combien de lignes lues ?
           MOVE w-cpt-lec              TO w-rap-lec-nbr
           MOVE w-rap-lec              TO w-enr-log
           WRITE f-log                 FROM w-enr-log

      *    Combien de lignes ajoutees ?
           MOVE w-cpt-ajo              TO w-rap-ajo-nbr
           MOVE w-rap-ajo              TO w-enr-log
           WRITE f-log                 FROM w-enr-log

      *    Combien de lignes mises a jour ?
           MOVE w-cpt-maj              TO w-rap-maj-nbr
           MOVE w-rap-maj              TO w-enr-log
           WRITE f-log                 FROM w-enr-log
           
      *    Combien de lignes supprimees ?
           MOVE w-cpt-sup              TO w-rap-sup-nbr
           MOVE w-rap-sup              TO w-enr-log
           WRITE f-log                 FROM w-enr-log

      *    Combien de lignes rejetees ?
           MOVE w-cpt-rej              TO w-rap-rej-nbr
           MOVE w-rap-rej              TO w-enr-log
           WRITE f-log                 FROM w-enr-log

      *    Ligne de separation
           MOVE '-------------------------------------------------'
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
      *    Combien de lignes traitees au total ?
           MOVE w-cpt-tot              TO w-rap-tot-nbr
           MOVE w-rap-tot              TO w-enr-log
           WRITE f-log                 FROM w-enr-log
           .

      *****************************************************************
      * - Creation de l'enqueue
      * - Fermeture du fichier de log
      *****************************************************************
       CPT-RENDU-EXEC-FIN.
           PERFORM ENQUEUE
           CLOSE log
           .

      *****************************************************************
      * Enregistrement de l'entete
      *****************************************************************
       ENTETE.
      *    Entete avec... une tete...
           MOVE '                      \\\///'
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
           MOVE '                     / _  _ \'
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
           MOVE '                   (| (.)(.) |)'
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
           MOVE '.----------------.OOOo--()--oOOO.----------------.'
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
           MOVE '|                                                |'
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
           MOVE '|            COMPTE-RENDU D''EXECUTION          |'
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
           MOVE '|            -------------------------           |'
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
           MOVE '|                                                |'
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
           MOVE '| Programme :         TLMBPGM3                   |'
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
           MOVE '| Developpeur :       ODO                        |'
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
           MOVE '| Environnement :     BIZ1                       |'
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
           MOVE '| Date d''execution :                           |'
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
      *    Et meme des pieds dans l'entete
           MOVE '.----------------.oooO---------------------------.'
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
           MOVE '                  (   )   Oooo.'
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
           MOVE '                   \ (    (   )'
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
           MOVE '                    \_)    ) /'
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
           MOVE '                          (_/'
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
      *    2 sauts de ligne
           MOVE ' '                    TO f-log
           WRITE f-log
           MOVE ' '                    TO f-log
           WRITE f-log
           .

      *****************************************************************
      * Enregistrement de l'enqueue
      *****************************************************************
       ENQUEUE.
           MOVE ' '                    TO f-log
           WRITE f-log
           MOVE ' '                    TO f-log
           WRITE f-log
      *    Notification que le compte-rendu est bel et bien termine
           MOVE '.------------------------------------------------.'
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
           MOVE '|     F I N   D E   C O M P T E  -  R E N D U     '
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
           MOVE '.------------------------------------------------.'
                                       TO w-enr-log
           WRITE f-log                 FROM w-enr-log
           .

       END PROGRAM TLMBPGM3.

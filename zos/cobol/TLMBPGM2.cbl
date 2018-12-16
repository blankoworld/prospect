
      *****************************************************************
      *                    C O U C H E  M E T I E R
      *                    ------------------------
      *****************************************************************
      * APPLICATION      : APPAREILLAGE ORIGINE <-> MAJ
      * NOM DU PROGRAMME : TLMBPGM2
      * DESCRIPTION      : PROGRAMME BATCH DE CREATION D'UN FICHIER
      *    DE PILOTAGE A PARTIR FICHIER ORIGINE ET MAJ
      *    TLMPRO & TLMCON DEPUIS UN FICHIER DE PILOTAGE
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.      TLMBPGM2.
       AUTHOR.          Olivier DOSSMANN.
       DATE-WRITTEN.    20181203.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. ZIA.
       OBJECT-COMPUTER. VIRTEL.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      *    Fichier de déchargement de la base
           SELECT origine ASSIGN TO ORIGINE.
             file status is w-origine.
      *    Fichier de mise à jour
           SELECT maj ASSIGN TO MAJ
             file status is w-maj.
      *    Fichier de pilotage pour la sortie
           SELECT pilote ASSIGN TO PILOTAGE.
            file status is w-pilote.
      *    Fichier de journalisation (logs)
           SELECT log    ASSIGN TO JOURNAUX.
             file status is w-log.
       DATA DIVISION.
       FILE SECTION.
       FD origine RECORDING MODE F.
       COPY TLMCENR1 REPLACING ==:PROG:== BY ==ori==.
       FD maj RECORDING MODE F.
       COPY TLMCENR1 REPLACING ==:PROG:== BY ==maj==.
       FD pilote RECORDING MODE F.
       COPY TLMCPIL3 REPLACING ==:PROG:== BY ==f==.
       FD log RECORDING MODE F.
       01 f-log                          PIC   X(80).
       
       WORKING-STORAGE SECTION.
      *------------------------
      *
      *----------------------------------------------------------------
      * Structures d'accueil du fichier ORIGINE et MAJ
       COPY TLMCENR1 REPLACING ==:PROG:== BY ==w-ori==.
       COPY TLMCENR1 REPLACING ==:PROG:== BY ==w-maj==.
      * Booleen
       01 w-fin-fic1                     PIC   9.
           88 w-fin-fic1-oui                     VALUE 1.
           88 w-fin-fic1-non                     VALUE 0.
       01 w-fin-fic2                     PIC   9.
           88 w-fin-fic2-oui                     VALUE 1.
           88 w-fin-fic2-non                     VALUE 0.
       01 w-err                          PIC   9.
           88 w-err-oui                          VALUE 1.
           88 w-err-non                          VALUE 0.

      * Code d'etat des fichiers
       01 w-origine                      PIC   X(02).
       01 w-maj                          PIC   X(02).
       01 w-pilote                       PIC   X(02).

       77 w-enr-log                      PIC   X(80).

       PROCEDURE DIVISION.
       DEBUT.
           DISPLAY 'MET, APPAREILLAGE'
           PERFORM INIT
           PERFORM TRT UNTIL w-fin-fic1-oui AND w-fin-fic2-oui
           PERFORM FIN
           PERFORM COMPTE-RENDU-EXECUTION
           GOBACK
           .

      *****************************************************************
      * Initialisation de quelques variables.
      * Ouverture du fichier d'origine et de mise a jour.
      *****************************************************************
       INIT.
      *    Fichiers lus
           SET w-fin-fic1-non             TO TRUE
           SET w-fin-fic2-non             TO TRUE

           PERFORM LEC-ORIGINE
           PERFORM LEC-MAJ

           OPEN INPUT origine
           OPEN INPUT maj
           OPEN OUTPUT pilote
           
           SET w-err-non                 TO TRUE
           .

      *****************************************************************
      * Lecture du fichier ORIGINE
      *****************************************************************
       LEC-ORIGINE.
      *------------
           DISPLAY 'MET-APPAREILLAGE, Origine'
           READ ori-enr
             AT END
               SET w-fin-fic1-oui        TO TRUE
               MOVE high-value           TO w-cle-ori
             NOT AT END
               MOVE SPACE                TO w-cle-ori
               MOVE ori-enr              TO w-ori-enr
           END READ
           .

      *****************************************************************
      * Lecture du fichier MAJ
      *****************************************************************
       LEC-MAJ.
      *------------
           DISPLAY 'MET-APPAREILLAGE, MAJ'
           READ maj-enr
             AT END
               SET w-fin-fic1-oui        TO TRUE
               MOVE high-value           TO w-cle-maj
             NOT AT END
               MOVE SPACE                TO w-cle-maj
               MOVE maj-enr              TO w-maj-enr
           END READ
           .

      *****************************************************************
      * Boucle de lecture des 2 fichiers
      *****************************************************************
       TRT.
      *----
           EVALUATE TRUE
             WHEN w-cle-ori < w-cle-maj
               DISPLAY 'MET-APPAREILLAGE, SUP'
               PERFORM SUP
               PERFORM LEC-ORIGINE

             WHEN w-cle-ori = w-cle-maj
               DISPLAY 'MET-APPAREILLAGE, VERIF.'
               PERFORM MAJ
               PERFORM LEC-ORIGINE
               PERFORM LEC-MAJ

             WHEN w-cle-ori > w-cle-maj
               DISPLAY 'MET-APPAREILLAGE, 


      *****************************************************************
      * Fermeture des fichiers
      *****************************************************************
       FIN.
      *----
           CLOSE origine
           CLOSE maj
           CLOSE pilote
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

       END PROGRAM TLMBPGM2.

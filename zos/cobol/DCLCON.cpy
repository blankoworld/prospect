      ******************************************************************
      * DCLGEN TABLE(TRAIN04.TLMCON)                                   *
      *        LIBRARY(TRAIN04.OPEN.COBOL(DCLCON))                     *
      *        ACTION(REPLACE)                                         *
      *        LANGUAGE(COBOL)                                         *
      *        NAMES(TLMCON-)                                          *
      *        STRUCTURE(TLMCON)                                       *
      *        QUOTE                                                   *
      *        LABEL(YES)                                              *
      *        COLSUFFIX(YES)                                          *
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *
      ******************************************************************
           EXEC SQL DECLARE TRAIN04.TLMCON TABLE
           ( ID                             CHAR(6) NOT NULL,
             NOM                            CHAR(35),
             PRENOM                         CHAR(35),
             TEL                            CHAR(10),
             MEL                            CHAR(80),
             NOTE                           CHAR(80),
             PID                            CHAR(6) NOT NULL
           ) END-EXEC.
      ******************************************************************
      * COBOL DECLARATION FOR TABLE TRAIN04.TLMCON                     *
      ******************************************************************
       01  TLMCON.
      *    *************************************************************
      *                       ID
           10 TLMCON-ID            PIC X(6).
      *    *************************************************************
      *                       NOM
           10 TLMCON-NOM           PIC X(35).
      *    *************************************************************
      *                       PRENOM
           10 TLMCON-PRENOM        PIC X(35).
      *    *************************************************************
      *                       TEL
           10 TLMCON-TEL           PIC X(10).
      *    *************************************************************
      *                       MEL
           10 TLMCON-MEL           PIC X(80).
      *    *************************************************************
      *                       NOTE
           10 TLMCON-NOTE          PIC X(80).
      *    *************************************************************
      *                       PID
           10 TLMCON-PID           PIC X(6).
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 7       *
      ******************************************************************


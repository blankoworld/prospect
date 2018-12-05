      ******************************************************************
      * DCLGEN TABLE(TRAIN04.TLMPRO)                                   *
      *        LIBRARY(TRAIN04.OPEN.COBOL(DCLPRO))                     *
      *        ACTION(REPLACE)                                         *
      *        LANGUAGE(COBOL)                                         *
      *        NAMES(TLMPRO-)                                          *
      *        STRUCTURE(TLMPRO)                                       *
      *        QUOTE                                                   *
      *        LABEL(YES)                                              *
      *        COLSUFFIX(YES)                                          *
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *
      ******************************************************************
           EXEC SQL DECLARE TRAIN04.TLMPRO TABLE
           ( ID                             CHAR(6) NOT NULL,
             NOM                            CHAR(35) NOT NULL,
             ADDR_RUE                       CHAR(40),
             ADDR_CP                        CHAR(5),
             ADDR_VILLE                     CHAR(35)
           ) END-EXEC.
      ******************************************************************
      * COBOL DECLARATION FOR TABLE TRAIN04.TLMPRO                     *
      ******************************************************************
       01  TLMPRO.
      *    *************************************************************
      *                       ID
           10 TLMPRO-ID            PIC X(6).
      *    *************************************************************
      *                       NOM
           10 TLMPRO-NOM           PIC X(35).
      *    *************************************************************
      *                       ADDR_RUE
           10 TLMPRO-ADDR-RUE      PIC X(40).
      *    *************************************************************
      *                       ADDR_CP
           10 TLMPRO-ADDR-CP       PIC X(5).
      *    *************************************************************
      *                       ADDR_VILLE
           10 TLMPRO-ADDR-VILLE    PIC X(35).
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 5       *
      ******************************************************************

       01 tlmcpil.
      *   Parametres envoyes par le programme appelant
      *      Fonction appelee
          05 tlmcpil-fct       PIC X(6).
      *      Code retour du programme appelant
          05 tlmcpil-rc        PIC X(2).
      *      Donnees retour (souvent tronque dans les banques, donc 40,
      *      pas plus)
          05 tlmcpil-msg       PIC X(40).

INSERT INTO PROSPECT(
  ID,
  NOM,
  ADDR_RUE,
  ADDR_CP,
  ADDR_VILLE
) VALUES
  ('000100', 'Skyway', '68, chemin Challet', '87100', 'LIMOGES');
COMMIT;
INSERT INTO CONTACT(
  ID,
  NOM,
  PRENOM,
  TEL,
  MEL,
  NOTE,
  PID
) VALUES
  ('010000', 'MARQUIS', 'Gaetane', '0546044332',
   'gaetanemarquis@armyspy.com', 'Sagittaire', '000100');
INSERT INTO CONTACT(ID, NOM, PRENOM, TEL, MEL, NOTE, PID) VALUES
  ('020000', 'MOREL', 'Julienne', '0152131154',
   'juliennemorel@rhyta.com', 'Aime le bleu', '000100');

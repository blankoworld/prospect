#!/usr/bin/env python
import sys
import csv

def main():
    # liste des fichiers
    fichier_prospect = 'prospects.csv'
    fichier_contact = 'contacts.csv'
    sortie = 'output.txt'

    # contenu
    colonnes_p = {
        'id': 6,
        'nom': 35,
        'rue': 40,
        'cp' : 5,
        'ville': 35
    }
    colonnes_c = {
        'id': 6,
        'nom': 35,
        'prenom': 35,
        'tel': 10,
        'mel': 80,
        'note': 80,
        'pid': 6
    }
    colonnes_prospect = list(colonnes_p.keys())
    colonnes_contact = list(colonnes_c.keys())
    
    # lecture du fichier
    with open(fichier_contact, newline='') as csvfile:
        reader = csv.DictReader(csvfile,
                                fieldnames=colonnes_contact,
                                delimiter=';')
        # ne pas lire la première ligne
        next(csvfile)
        # lecture des lignes suivantes
        for row in reader:
            # préparation d'une ligne
            ligne = []

            for colonne, nbre in colonnes_c.items():
                contenu = row[colonne][:nbre]
                if colonne in ['id', 'pid']:
                    contenu_aligne = '{:0>{x}}'.format(contenu, x=nbre)
                else:
                    contenu_aligne = '{0:<{x}}'.format(contenu, x=nbre)
                ligne.append(contenu_aligne)

            # ajout des 148 derniers caracteres
            filler = ' ' * 148 
            ligne.append(filler)

            # TODO: écrire dans un fichier
            print(''.join(ligne))


if __name__ == "__main__":
    main()
    sys.exit(1)

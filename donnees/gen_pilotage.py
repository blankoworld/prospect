#!/usr/bin/env python
import sys
import csv

def main():
    # liste des fichiers
    fichier_prospect = 'prospects.csv'
    fichier_contact = 'contacts.csv'

    # contenu
    colonnes_p = {
        'id':       6,
        'nom':      35,
        'rue':      40,
        'cp' :      5,
        'ville':    35
    }
    colonnes_c = {
        'commande': 1,
        'id':       6,
        'nom':      35,
        'prenom':   35,
        'tel':      10,
        'mel':      80,
        'note':     80,
        'pid':      6
    }
    colonnes_prospect = list(colonnes_p.keys())
    colonnes_contact = list(colonnes_c.keys())

    # divers
    prospects = {}
    
    # mémorisation des prospects
    with open(fichier_prospect, newline='') as pfile:
        preader = csv.DictReader(pfile,
                                 fieldnames=colonnes_prospect,
                                 delimiter=';')
        # ne pas lire la première ligne
        next(pfile)
        # lecture des lignes suivantes
        for row in preader:
            # préparation d'une ligne
            ligne = []
            pid = None
            
            for colonne, nbre in colonnes_p.items():
                contenu = row[colonne][:nbre]
                if colonne in ['id', 'pid']:
                    contenu_aligne = '{:0>{x}}'.format(contenu, x=nbre)
                    pid = contenu_aligne
                else:
                    contenu_aligne = '{0:<{x}}'.format(contenu, x=nbre)
                ligne.append(contenu_aligne)

            # ajout des 279 derniers caracteres
            filler = ' ' * 279
            ligne.append(filler)

            if pid:
                prospects[pid] = ligne

    # lecture du fichier de contacts
    with open(fichier_contact, newline='') as cfile:
        reader = csv.DictReader(cfile,
                                fieldnames=colonnes_contact,
                                delimiter=';')
        # ne pas lire la première ligne
        next(cfile)
        # lecture des lignes suivantes
        for row in reader:
            # préparation d'une ligne
            ligne = []
            commande = None
            pid = None

            for colonne, nbre in colonnes_c.items():
                contenu = row[colonne][:nbre]
                # Récupération du code de commande (A, M ou S)
                if colonne == 'commande':
                    commande = contenu.upper()
                    continue
                if colonne in ['id', 'pid']:
                    contenu_aligne = '{:0>{x}}'.format(contenu, x=nbre)
                    pid = contenu_aligne
                else:
                    contenu_aligne = '{0:<{x}}'.format(contenu, x=nbre)
                ligne.append(contenu_aligne)

            # ajout des 148 derniers caracteres
            filler = ' ' * 148
            ligne.append(filler)

            # composition de la ligne
            prospect = ''.join(prospects[pid])
            contact = ''.join(ligne)
            print(''.join([commande, prospect, contact]))


if __name__ == "__main__":
    main()
    sys.exit(1)

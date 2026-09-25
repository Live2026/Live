#!/usr/bin/env python3
"""Encadre les maquettes d'écrans des fichiers Markdown de docs/ecrans/.

Dans un fichier .md, un bloc

    ```ecran            (téléphone, 40 caractères utiles)
    ```ecran-large      (back-office web, 86 caractères utiles)

contient le contenu brut de l'écran. Le script ajoute le cadre, complète
chaque ligne à la bonne largeur et remplace l'étiquette par ```text.
Les blocs déjà encadrés (```text dont la première ligne est ┌) sont
d'abord « désencadrés » puis retracés : on peut donc modifier une ligne
dans un cadre sans se soucier du bord droit, puis relancer le script.
Il échoue si une ligne dépasse la largeur.
"""
import pathlib
import re
import sys
import unicodedata

LARGEURS = {"ecran": 40, "ecran-large": 86}
BLOC = re.compile(r"```(ecran(?:-large)?)\n(.*?)```", re.S)
ENCADRE = re.compile(r"```text\n(┌─+┐\n.*?└─+┘)\n```", re.S)


def desencadrer(m: re.Match) -> str:
    """Retrouve le contenu brut et le type d'un bloc déjà encadré."""
    lignes = m.group(1).split("\n")
    genre = "ecran" if len(lignes[0]) - 4 <= LARGEURS["ecran"] else "ecran-large"
    brut = []
    for ligne in lignes[1:-1]:
        if ligne.startswith("├"):
            brut.append("---")
        else:
            brut.append(ligne[2:-1].rstrip())
    return f"```{genre}\n" + "\n".join(brut) + "\n```"


def largeur(texte: str) -> int:
    return sum(2 if unicodedata.east_asian_width(c) in "WF" else 1 for c in texte)


def encadrer(fichier: pathlib.Path, genre: str, contenu: str) -> str:
    l = LARGEURS[genre]
    lignes = contenu.rstrip("\n").split("\n")
    sortie = ["┌" + "─" * (l + 2) + "┐"]
    for ligne in lignes:
        if ligne.strip() == "---":
            sortie.append("├" + "─" * (l + 2) + "┤")
            continue
        w = largeur(ligne)
        if w > l:
            sys.exit(f"{fichier}: ligne trop longue ({w} > {l}) : {ligne!r}")
        sortie.append("│ " + ligne + " " * (l - w) + " │")
    sortie.append("└" + "─" * (l + 2) + "┘")
    return "```text\n" + "\n".join(sortie) + "\n```"


def main() -> None:
    racine = pathlib.Path(__file__).resolve().parent.parent / "docs" / "ecrans"
    for fichier in sorted(racine.glob("*.md")):
        texte = fichier.read_text(encoding="utf-8")
        brut = ENCADRE.sub(desencadrer, texte)
        nouveau = BLOC.sub(lambda m: encadrer(fichier, m.group(1), m.group(2)), brut)
        if nouveau != texte:
            fichier.write_text(nouveau, encoding="utf-8")
            print(f"encadré : {fichier.name}")


if __name__ == "__main__":
    main()

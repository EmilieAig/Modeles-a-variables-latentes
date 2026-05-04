# Modèles à variables latentes – Analyse du jeu de données *genus*

## Objectif du devoir maison

Ce devoir maison vise à appliquer et comparer deux grandes familles de modèles à variables latentes sur des données écologiques avec des modèles à composantes supervisées (SCGLR) et des modèles de mélange (flexmix).

Les objectifs principaux sont d’identifier des gradients environnementaux continus et des classes latentes de parcelles.

## Données

Le jeu de données `genus` contient :

- 1000 parcelles
- 27 variables réponses : abondance de genres d’arbres
- 43 variables explicatives : environnement, climat, géographie

## Méthodologie

L’analyse se déroule en trois étapes principales :

1. Analyse en Composantes Principales (ACP) pour explorer la structure de X
2. Modélisation par mélange gaussien (flexmix) pour identifier des classes latentes
3. Modélisation supervisée (SCGLR) pour relier X aux réponses Y

## Packages utilisés

```r
SCGLR
flexmix
ClustOfVar
FactoMineR
factoextra
pls
dplyr
```
## Auteurs

- Emilie AIGOIN  
- Kateryna STETSUN  
- Anne-Laure THOMAS  

Université de Montpellier – Année 2025-2026
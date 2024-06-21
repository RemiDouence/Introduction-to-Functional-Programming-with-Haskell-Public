# Introduction to Functional Programming with Haskell

Here is the material for my course at IMT Atlantique about
introduction to functional programming with Haskell.

## FIL software engineering apprenticeship program

(http://www.imt-atlantique.fr/formation/ingenieur-par-apprentissage/ingenieurs-specialite-ingenierie-logicielle). This
3-year program leads to a Master's degree in software engineering at
IMT Atlantique.

About 30 students each year.

Half a day block = I program in front of the students for 75 minutes, then the students get my code and complete it for 150 minutes.
There are 5 blocks. 
I evaluate the last (5th) block.
Total time = 17h30.
 
## FISE LOGIN (ingenierie logicielle et innovation) 

https://www.imt-atlantique.fr/fr/formation/ingenieur-generaliste?p=Y%3DtMdbkicc503AUGbZ%3DRvDAMNtX31MjyN1TU1NTtJOHwLt2T

Half a day block = I program in front of the students for 75 minutes, then the students get my code and complete it for 150 minutes.
There are 8 blocks. 
I evaluate the last (8th) block.
Total time = 30h.


- This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License 
- https://creativecommons.org/licenses/by-nc-nd/4.0/
- Remi Douence

**Please do not distribute solutions but let people learn by doing the exercices.**

**If you find this repository useful, please let me know at remi dot douence @ imt minus atlantique dot fr**

The code is presented in three different versions:

1. In Makdown: (`.hs.md`) Haskell with markdown as comments 
  (each non Haskell line is prefixed by `--MD `) 
  A line prefixed with `--EXO ` is a definition to be completed. 
  Converters can extract either the exercice or its solution. 
  This format `.hs.md` loads fine in `ghci`. 
  It can be used to develop literate markdown files.

2. in Haskell Exo: (`.hs`) plain haskell without markdown (the
   markdown as comments lines are erased)
   The line starting with `--EXO ` are kept (and the rest of the
   definition is discarded).

3. in Haskell Sol: (`.hs`) plain haskell without markdown (the
   markdown as comments lines are erased)
   The line starting with `--EXO ` are discarded.

4. In Literate Haskell Exo: (`.hs.md`) Haskell with markdown as comments 
  (each non Haskell line is prefixed by `--MD `) 


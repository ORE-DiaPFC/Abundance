# Mise à jour et standardisation des séries chronologiques d'abondance du saumon atlantique sur les cours d'eau de l'ORE DiaPFC

Updating and standardization of Atlantic salmon abundance time series on DiaPFC ORE rivers

___

Estimer la taille des populations de saumon atlantique (*Salmo salar*) et leurs incertitudes associées
et ce, à différents stades de vie, est crucial pour étudier leurs dynamiques et proposer des stratégies
raisonnables de gestion aussi bien au niveau local qu’international. Les séries chronologiques
d’abondance du saumon atlantique en France, collectées sur les cours d’eau de l’Observatoire de
Recherche en Environnement sur les Poissons Diadromes dans les Petits Fleuves Côtiers ([ORE DiaPFC](https://www6.inra.fr/diapfc)),
constituent le support observationnel sur lequel se fonde le système de régulation de l’exploitation du
saumon sur le bassin de l’Adour – Nivelle, en Bretagne et en Basse-Normandie. Au niveau international,
les rivières de l’ORE DiaPFC contribuent au réseau des rivières « index » dont les séries temporelles
sont utilisées par le groupe de travail sur le saumon de l’Atlantique Nord du Conseil International pour
l’Exploration de la Mer (CIEM) et qui servent à évaluer le statut annuel de l’espèce au travers de toute
son aire de distribution. Au cours des trois dernières décennies, des méthodes obsolètes et très
hétérogènes ont été utilisées pour produire les séries d’abondance de l’ORE DiaPFC.

Les objectifs liés à cette fiche action étaient donc de pallier à cette déficience en modernisant et
standardisant les méthodes servant à produire les séries d’abondance sur tous les petits fleuves côtiers
de l’ORE DiaPFC (la Nivelle, l’Oir, le Scorff, la Bresle) et ce, à tous les stades de vie faisant l’objet de
suivi, i.e. adulte anadrome, juvénile en eau douce (ou tacon), juvénile migrant (ou smolt). Des modèles
hiérarchiques ont ainsi été développés à des fins d’estimation dans un cadre bayésien (Servanty & Prévost 2016). Ces modèles
facilitent l'intégration de sources de données multiples et associées à différentes échelles (spatiales ou
temporelles). Ils permettent également de transférer de l’information entre les années riches en
données vers les années pauvres en données.

___
## HOW TO CITE
Buoro Mathieu, Servanty Sabrina, Beaulaton Laurent, & Prévost Etienne. (2019, July 9). Estimation and standardisation of Atlantic salmon abundance time series on DiaPFC ORE rivers (Version v1.0). http://doi.org/10.5281/zenodo.3275148
[![DOI](https://zenodo.org/badge/84212065.svg)](https://zenodo.org/badge/latestdoi/84212065)

___

## MEMBRES

Responsables:  
Étienne Prévost & Mathieu Buoro  
Ecobiop, INRA, Univ. Pau & Pays de l’Adour, Aquapôle INRA, 64310 Saint-Pée-sur-Nivelle
INRA, Pôle GEST’AQUA, 64310 Saint-Pée-sur-Nivelle

Travail initié par Sabrina Servanty & Étienne Prévost:
Sabrina Servanty & Étienne Prévost (2016). Mise à jour et standardisation des séries chronologiques d'abondance du saumon atlantique sur les cours d'eau de l'ORE DiaPFC et la Bresle. Rapport final, février 2016. Fiche action ONEMA – INRA 2013-2015 (action n° 35). 

Avec la participation de :  
Gilles Euzenat, Jean-Louis Fagard, Françoise Fournel ; AFB, Pôle GEST’AQUA, 76260 Eu  
Laurent Beaulaton ; AFB, Pôle GEST’AQUA, 35042 Rennes  
Richard Delanoë ; AFB, Pôle GEST’AQUA, 50220 Ducey  
Quentin Josset; AFB, Pôle GEST’AQUA, Bresle. 
Etienne Rivot, Marie Nevoux ; ESE, AgroCampus, INRA, 35042 Rennes  
Frédéric Marchand ; INRA, U3E, Pôle GEST’AQUA, 35042 Rennes  
Nicolas Jeannot ; INRA, U3E, Pôle GEST’AQUA, 56620 Pont-Scorff  
Yoann Guilloux, Jean-Yves Moelo ; FDPPMA56, 56620 Pont-Scorff  
Esther Carlut, Frédéric Lange ; INRA, Ecobiop, Pôle GEST’AQUA, 64310 Saint-Pée-sur-Nivelle 

___
## STRUCTURE

Le dossier se compose de sous-dossiers correspondant aux différents sites de l'ORE analysés (Bresle, Scorff, Oir et Nivelle). Ces dossiers sont sous-divisés en fonction des stades observés (adultes, smolts ou tacons) :  

Abundance/ # dossier contenant les analyses des indices d'abondances  
	- README.md # ce fichier  
	- run.sh # script bash permettant de créer les scripts d'analyse par site et par stade (ex: analyse_tacon.R) puis de lancer les analyses; faire ./run.sh dans un terminal (linux)  
	- analyse.R # script d'analyse principal; ce script est automatiquement modifié via run.sh pour changer les paramètres (ex: nombre d'itérations,...)  
  |_doc/ # contient les rapports,...  
  |  
 	|_SITE/  
   			|_adult/  
			  |_smolt/  
          			- data/ # données d'échantillonnage  
          			- inits/ # contient un script R (inits_smolt.R) qui génère automatiquement les valeurs initiales pour les chaînes MCMC  
          			- model/ # modele pour les inférences  
          			- results/ # contient les diagnostiques et les résultats des analyses  
          			- bugs/ # contient les fichiers pour openbugs 
          			- parameters_smolt.R # paramètres à monitorer  


___
## ANALYSES

Les analyses se font sous [OpenBUGS](http://www.openbugs.net/w/Downloads) via le logiciel R. Openbugs et R doivent donc être préalablement  installés.  
Les packages R suivant doivent également être installés:  
> install.packages(c("R2OpenBUGS", "rjags", "coda", "mcmcplots"))

Pour lancer les analyses:

- Sur tous les sites:
1. Ouvrir le fichier "run.sh" et faire les modifications nécessaires (nb d'itérations,...)
2. Dans un terminal (linux): 
> ./run.sh 

- Pour un site:
1. Ouvrir le script *analyse_stade.R* dans le dossier correspondant (ex: /SITE/adult/)
2. Modifier le chemin du répertoire dans le srcipt (i.e. localisation du fichier; section "WORKING DIRECTORY")
3. Lancer le script dans R ou depuis un terminal avec la commande:
> R CMD BATCH analyse_adult.R


library(MCMCvis)
MCMCplot(fit, params = "pi_Ol")

___
## DONNEES

Lange F., Guéraud F., Huchet E., Rives J. and Prévost E. 2017. Abundances and biological traits of the juveniles salmon sampled in the survey of Salmon abundance Indices in the Nivelle river (France). [doi:10.15468/alsjvy](http://www.gbif.org/dataset/e96db990-bd86-4a79-89a2-446844a27811)

Jeannot N., Azam D., Guilloux Y. and Prévost E. 2017. Abundances and biological traits of the juveniles salmon sampled in the survey of Salmon abundance Indices in the Scorff river (France). [doi:10.15468/mz4lyw](http://www.gbif.org/dataset/89064e3a-aa3c-495d-b236-092e1dae7042)

Marchand F., Azam D., Delanoë R., Destouches J.-P., Tremblay J., and Prévost E. 2017. Abundances indices and biological traits of juvenile salmon sampled in the Oir river (France). [doi:10.15468/cjsjrj](http://www.gbif.org/dataset/5ea28eaa-7e0c-417c-b525-9c737d18823f)

Marchand F., Beaulaton L., Prévost E., Delanoë R., Destouches J.-P., Gueraud F., Guilloux Y., Jeannot N., Huchet E., Lange F., Rives J., Trembaly J., Herrard N. and Azam D. 2017. Abundance indices and biological traits of juvenile salmon (Salmo salar) sampled in three rivers on the Atlantic and Channel coasts (France). Biodiversity Data Journal, 5: [e15125](https://bdj.pensoft.net/articles.php?id=15125).



___
## LICENSE
The content of this project itself is licensed under the [GNU GPL v3.0 license](https://www.gnu.org/licenses/gpl-3.0.en.html), except the datasets which are under the [Creative Commons Attribution 4.0 license](https://creativecommons.org/licenses/by/4.0/).

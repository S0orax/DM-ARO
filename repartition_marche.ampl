set DETAILLANTS;
set REGIONS;
set CATEGORIES;

param region{DETAILLANTS} symbolic in REGIONS;
param huile{DETAILLANTS} >= 0;
param nb_pts_vente{DETAILLANTS} >= 0;
param spiritueux{DETAILLANTS} >= 0;
param categorie{DETAILLANTS} symbolic in CATEGORIES;

var appartient_a_d1 {DETAILLANTS} binary;

var pourcent_spiritueux_d1 >= 0;
var pourcent_pts_ventes_d1 >= 0;
var pourcent_huile_d1{REGIONS} >= 0;
var pourcent_detaillant_d1{CATEGORIES} >= 0;

var variation_spiritueux_d1 = pourcent_spiritueux_d1 - 40;
var x_spiritueux >= 0;
var t_spiritueux >= 0;
var variation_pts_ventes_d1 = pourcent_pts_ventes_d1 - 40;
var x_pts_ventes >= 0;
var t_pts_ventes >= 0;
var variation_huile_d1{r in REGIONS} = pourcent_huile_d1[r] - 40;
var x_huile{REGIONS} >= 0;
var t_huile{REGIONS} >= 0;
var variation_detaillant_d1{c in CATEGORIES} = pourcent_detaillant_d1[c] - 40;
var x_detaillant{CATEGORIES} >= 0;
var t_detaillant{CATEGORIES} >= 0;

# Contrainte pour changer de variables et pouvoir faire la valeur absolue des variations des spiritueux
subject to changement_variable_spiritueux :
	variation_spiritueux_d1 = x_spiritueux - t_spiritueux;

# Contrainte pour changer de variables et pouvoir faire la valeur absolue des variations des points de ventes
subject to changement_variable_pts_ventes :
	variation_pts_ventes_d1 = x_pts_ventes - t_pts_ventes;

# Contrainte pour changer de variables et pouvoir faire la valeur absolue des variations des huiles par regions
subject to changement_variable_huile{r in REGIONS} :
	variation_huile_d1[r] = x_huile[r] - t_huile[r];

# Contrainte pour changer de variables et pouvoir faire la valeur absolue des variations des detaillants par categories
subject to changement_variable_detaillant{c in CATEGORIES} :
	variation_detaillant_d1[c] = x_detaillant[c] - t_detaillant[c];

minimize variation :
	x_spiritueux + t_spiritueux + x_pts_ventes + t_pts_ventes + sum{r in REGIONS}(x_huile[r] + t_huile[r]) + sum{c in CATEGORIES}(x_detaillant[c] + t_detaillant[c]);

# Calcul du rapport des spiritueux de d1
subject to rapport_spiritueux_d1 :
	pourcent_spiritueux_d1 = (sum{d in DETAILLANTS} spiritueux[d] * appartient_a_d1[d]) / (sum{d in DETAILLANTS}spiritueux[d]) * 100;

# Spiritueux pour d1
subject to spiritueux_d1 :
	35 <= pourcent_spiritueux_d1 <= 45;

# Calcul du rapport des points de ventes de d1
subject to rapport_nb_point_vente_d1 :
	pourcent_pts_ventes_d1 = (sum{d in DETAILLANTS} nb_pts_vente[d] * appartient_a_d1[d]) / (sum{d in DETAILLANTS}nb_pts_vente[d]) * 100;

# Nb point de vente pour d1
subject to nb_point_vente_d1 :
	35 <= pourcent_pts_ventes_d1 <= 45;

# Calcul du rapport des huiles par regions  de d1
subject to rapport_huile_d1{r in REGIONS} :
	pourcent_huile_d1[r] = (sum{d in DETAILLANTS : region[d] = r} huile[d] * appartient_a_d1[d]) / (sum{d in DETAILLANTS : region[d] = r}huile[d]) * 100;

# Le marche de l'huile dans chaque region pour d1'
subject to huile_d1{r in REGIONS} :
	35 <= pourcent_huile_d1[r] <= 45;

# Calcul du rapport des detaillants par categorie de d1
subject to rapport_detaillant_par_categorie_d1{c in CATEGORIES} :
	pourcent_detaillant_d1[c] = (sum{d in DETAILLANTS : categorie[d] = c} appartient_a_d1[d]) / (sum{d in DETAILLANTS : categorie[d] = c} 1) * 100;

# Le nombre de detaillant pour chaque categorie pour d1
subject to detaillant_par_categorie_d1{c in CATEGORIES} :
	35 <= pourcent_detaillant_d1[c] <= 45;
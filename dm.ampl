reset;
reset;
option solver gurobi;
model repartition_marche.ampl;
model repartition_marche.data;
solve;
display appartient_a_d1;
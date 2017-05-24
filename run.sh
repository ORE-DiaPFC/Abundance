# ! /bin/sh
#$ -S /bin/sh

#SITE=Scorff # Nivelle Oir Bresle
YEAR=2016
CHAINS=2
BURNIN=5000 # Number of steps to "burn-in" the samplers.
ITER=50000 # Total number of steps in chains to save.
THIN=10 # Number of steps to "thin" (1=keep every step).


REPbase="/home/mbuoro/Documents/RESEARCH/PROJECTS/ORE-DiaPFC/Abondance"
#"/media/ORE/Abundance" 

i=0

for SITE in Bresle Oir Scorff Nivelle Bresle  
do
     
cd $REPbase/$SITE
     echo $SITE
     
     for STADE in tacon adult smolt   
     do
      if [ -d "$STADE" ]; then # if directory exists...
  # Control will enter here if $DIRECTORY exists.
     echo "|_$STADE"

    cp $STADE/data/data_"$STADE".R $STADE/data/data_"$STADE"_TMP.R
    #sed 's|Rep|'"$REPbase"'|g' -i $STADE/data/data_"$STADE"_TMP.R
    sed 's|SITE|'"$SITE"'|g' -i $STADE/data/data_"$STADE"_TMP.R
    sed 's|STADE|'"$STADE"'|g' -i $STADE/data/data_"$STADE"_TMP.R
    sed 's|YEAR|'"$YEAR"'|g' -i $STADE/data/data_"$STADE"_TMP.R
    
    
    cp $REPbase/analyse.R $STADE/analyse_"$STADE".R
    sed 's|Rep|'"$REPbase"'|g' -i $STADE/analyse_"$STADE".R
    sed 's|SITE|'"$SITE"'|g' -i $STADE/analyse_"$STADE".R
    sed 's|STADE|'"$STADE"'|g' -i $STADE/analyse_"$STADE".R
    sed 's|YEAR|'"$YEAR"'|g' -i $STADE/analyse_"$STADE".R
    sed 's|CHAINS|'"$CHAINS"'|g' -i $STADE/analyse_"$STADE".R
    sed 's|BURNIN|'"$BURNIN"'|g' -i $STADE/analyse_"$STADE".R
    sed 's|ITER|'"$ITER"'|g' -i $STADE/analyse_"$STADE".R
    sed 's|THIN|'"$THIN"'|g' -i $STADE/analyse_"$STADE".R
     

   # R CMD BATCH --no-save --no-restore $STADE/analyse_"$STADE".R & # analyse dans R
    
    # Save PIDs of processes
    i = i + 1
    echo $!
    pids[${i}]=$!
    echo $!
    fi
    done
 done   
    
## CLEANING
# for pid in ${pids[*]};
#   do
#   wait $pid; 
#     
#     rm -f $STADE/CODAindex.txt
#     #rm -f analyse_"$STADE".R
#     #rm -f analyse_"$STADE".Rout  
#     rm -f  $STADE/data/data_"$STADE"_TMP.R
#   
# done;
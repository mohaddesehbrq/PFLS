# remove previous directories and make a new one
rm -rf COMBINED-DATA
mkdir -p COMBINED-DATA

#find culture names
for dir in $(ls -d RAW-DATA/DNA*); do
    culture_name=$(basename $dir)
    new_culture_name=$(grep $culture_name RAW-DATA/sample-translation.txt | awk '{print $2}')

    # to differentiate mags and bins and name them
    MAG_counter=1
    BIN_counter=1
    cp $dir/checkm.txt COMBINED-DATA/$new_culture_name-CHECKM.txt
    cp $dir/gtdb.gtdbtk.tax COMBINED-DATA/$new_culture_name-GTDB-TAX.txt

    
    for fasta_file in $dir/bins/*.fasta; do
        bin_name=$(basename $fasta_file .fasta)
        completion=$(grep "$bin_name " $dir/checkm.txt | awk '{print $13}')
        contamination=$(grep "$bin_name " $dir/checkm.txt | awk '{print $14}')


        #conditions for contamination and combination
        if [[ $bin_name == bin-unbinned ]]; then
            new_name="${new_culture_name}_UNBINNED.fa"
            echo " $new_culture_name unbinned contigs in progress ($new_name) ..."
        elif (( $(echo "$completion >= 50" | bc -l) && $(echo "$contamination < 5" | bc -l) )); then
            new_name=$(printf "${new_culture_name}_MAG_%03d.fa" $MAG_counter)
            echo " $new_culture_name MAG in progress $bin_name ($new_name) (completion/contamination: $completion/$contamination) ..."
            MAG_counter=$((MAG_counter + 1))
        else
            new_name=$(printf "${new_culture_name}_BIN_%03d.fa" $BIN_counter)
            echo " $new_culture_name BIN in progress $bin_name ($new_name) (completion/contamination: $completion/$contamination) ..."
            BIN_counter=$((BIN_counter + 1))
        fi

        
        sed -i '' "s/ms.*${bin_name}/$(basename $new_name .fa)/g" COMBINED-DATA/$new_culture_name-CHECKM.txt
        sed -i '' "s/ms.*${bin_name}/$(basename $new_name .fa)/g" COMBINED-DATA/$new_culture_name-GTDB-TAX.txt

      
        cp "$fasta_file" "COMBINED-DATA/$new_name" 
        awk -v prefix="$new_culture_name" '/^>/ {print ">" prefix "_" ++count; next} {print}' "$fasta_file" > "COMBINED-DATA/$new_name"
    done
done
#length of each sequence
length=$(awk '/^>/ {next} {printf length}' "$1")


#calculate numbers of seq
num_seq=$(grep '>' "$1" |wc -l)


#calculate total length
total=$(awk '/^>/{next} {printf}' "$1" |wc -c)


longest=$(echo $length |sort -nr |head -n 1)
shortest=$(echo $length |sort -n |head -n 1)


#calculating average length
ave=$(($total/$num_seq))


echo "FASTA File Statistics:"
echo "----------------------"
echo "Number of sequences:$num_seq"
echo "Total length of sequences:$total"
echo "Length of the longest sequence:$longest"
echo "Length of the shortest sequence:$shortest"
echo "Average sequence length:$ave"
echo "GC Content (%):$GC"
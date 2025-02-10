#calculate numbers of seq
num_seq=$(grep '>' "$1" | wc -l)

#calculate total length
total=$(awk '/^>/ {next} {printf($1)}' "$1" | wc -c)

#length of each sequence
length=$(awk '/^>/ {next} {print length($0)}' "$1")

longest=$(echo "$length" |sort -nr |head -n 1)
shortest=$(echo "$length" |sort -n |head -n 1)

#calculating average length
ave=$(($total / $num_seq))

cg_num=$(awk '!/^>/ {gsub(/[CG]/,""); print length}' "$1" | awk '{s+=$1} END {print s}')
GC=$(($cg_num * 100 / $total))

echo "FASTA File Statistix:"
echo "----------------------"
echo "Number of sequences: $num_seq"
echo "Total length of sequences: $total"
echo "Length of the longest sequence: $longest"
echo "Length of the shortest sequence: $shortest"
echo "Average sequence length: $ave"
echo "GC Content (%): $GC"

IFS=, read -a extensions <<< "$arg2"
for ext in "${extensions[@]}"; do
  for file in "$arg"/*."$ext"; do
      echo "$file" > z.txt
  done
done
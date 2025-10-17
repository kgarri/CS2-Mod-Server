FILE="admins.conf"
line_count=$(wc -l < "$FILE")

echo "{" >> "admins.json"  
declare -i iter=1
while IFS=' ' read -r -a input; do
    if [ $iter -eq $line_count ]; then 
        echo -e "\t\"${input[0]}\": {\n\t\t\"identity\": \"${input[1]}\",\n\t\t\"flags\":[\"@css/ban\"]\n\t}" >>"admins.json"
    else
        echo -e "\t\"${input[0]}\": {\n\t\t\"identity\": \"${input[1]}\",\n\t\t\"flags\":[\"@css/ban\"]\n\t}," >>"admins.json"
    fi
    ((iter += 1))
done < "$FILE"
echo "}" >> "admins.json" 

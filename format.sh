files=$(find -name "*.gd")
# echo $files
read -r -a array <<< "$files"

for element in $files
do 
    # remove first . of path
    element="${element:2}"
    echo $element
    # format file at path
    gdformat $element
done 

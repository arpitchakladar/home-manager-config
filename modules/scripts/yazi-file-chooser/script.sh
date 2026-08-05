# $1 toggles multiple selection
# $2 toggles directory select mode
# $3 toggles save file mode
# $4 is the initial directory path
# $5 is the output path file

# multiple="$1"
directory="$2"
# save="$3"
path="$4"
out="$5"

# Pick directory vs single/multiple file
if [ "$directory" = "1" ]; then
    # Outputs the final working directory path on exit
    exec yazi "$path" --cwd-file="$out"
else
    # Writes all selected file paths to the output file on exit
    exec yazi "$path" --chooser-file="$out"
fi

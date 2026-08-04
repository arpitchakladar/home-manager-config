# $1 = multiple selection (1/0)
# $2 = directory select mode (1/0)
# $3 = save file mode (1/0)
# $4 = initial directory path
# $5 = output path file (where portal expects selected paths)

# multiple="$1"
directory="$2"
# save="$3"
path="$4"
out="$5"

# Pick directory vs single/multiple file
if [ "$directory" = "1" ]; then
    # --cwd-file outputs the final working directory path when exiting
    exec yazi "$path" --cwd-file="$out"
else
    # --chooser-file writes all selected file path(s) to $out on exit
    exec yazi "$path" --chooser-file="$out"
fi

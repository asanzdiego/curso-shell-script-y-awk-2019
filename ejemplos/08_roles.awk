# this will run only once at first
BEGIN {
    FS = ",|:"
}

# this will be executed for each of the lines in the file
{
    name=$1
    for (N=2; N<=NF; N++) {
        rol=$N
        roles[rol]=""roles[rol]" "name
    }
}

# This will only run once at the end
END {
    for (rol in roles) {
        print rol" -> " roles[rol]
    }
}
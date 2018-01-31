#   Confirmation When Copying, Linking, or Deleting
    alias cp='cp -i'
    alias mv='mv -i'
    alias ln='ln -i'

#   Preferred 'ls' implementation
    alias ll='ls -FGlAhp'

#   Always list directory contents upon 'cd'
    cd() { builtin cd "$@"; ls -FGlAhp; }

#   Go back 1 directory level (for fast typers)
    alias cd..='cd ../'

#   Go back 1 directory level
    alias ..='cd ../'

#   Go back 2 directory levels
    alias ...='cd ../../'

#   Go back 3 directory levels
    alias .3='cd ../../../'

#   Go back 4 directory levels
    alias .4='cd ../../../../'

#   Go back 5 directory levels
    alias .5='cd ../../../../../'

#   Go back 6 directory levels
    alias .6='cd ../../../../../../'

#   Clean all python cach files recursively from current dir down
    pyclean () {
        echo "Recursively deleting *.py[co]"
        find . -type f -name "*.py[co]" -delete
        echo "Recursively deleting __pycache__"
        find . -type d -name "__pycache__" -delete
    }

#   Make grep better
    function mgrep () {
        grep -rnIi "$1" . --color;
    }

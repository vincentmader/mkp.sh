#!/bin/sh

cprint () {
    path_to_script="$(realpath $0)"
    path_to_dir="$(dirname $path_to_script)"
    path_to_cprint="$path_to_dir/../tmp/colored-echo.sh/src/cprint.sh"
    sh "$path_to_cprint" "$1" "$2"
}

ORG_HOME="$HOME/org"

# Make sure that exactly one argument is passed to this script. Else: Exit.
# ─────────────────────────────────────────────────────────────────────────────
nr_of_args_passed_to_this_script=$#
if [ $nr_of_args_passed_to_this_script -ne 1 ]; then
    cprint "Please specify exactly one argument to the \`mkp\` command, i.e. the name of the project." "red"
    exit
fi

# Make sure that the passed project name ends in "." (-> just a convention).
# ─────────────────────────────────────────────────────────────────────────────
PROJECT_NAME="$1"
if [[ "$PROJECT_NAME" != *"." ]]; then 
    cprint "Project name should end in \".\"" "red"
    exit
fi

# Create POSIX-compatible project id for directory name.
# ─────────────────────────────────────────────────────────────────────────────
PROJECT_ID=$(echo "$PROJECT_NAME" | awk '{print tolower($0)}') # -> Lowercase
PROJECT_ID=$(echo "$PROJECT_ID" | sed 's/.$//')                # -> Remove dot.
PROJECT_ID=$(echo "$PROJECT_ID" | tr " " "_")                  # -> No spaces.

# Define paths that shall be created for the project.
# ─────────────────────────────────────────────────────────────────────────────
PATH_TO_DIR_IN_INBOX="$ORG_HOME/0_inbox/$PROJECT_ID"
PATH_TO_DIR_IN_ALL="$ORG_HOME/A_All/$PROJECT_ID"
PATH_TO_ORG_IN_INBOX="$PATH_TO_DIR_IN_INBOX/${PROJECT_NAME}org"
PATH_TO_ORG_IN_ALL="$PATH_TO_DIR_IN_ALL/${PROJECT_NAME}org"

# Define path of org-file that shall be written into.
# ─────────────────────────────────────────────────────────────────────────────
FILE_NAME="$ORG_HOME/Index.org"
FILE_NAME=$(realpath $FILE_NAME)

# Define text that shall be added to the org-file.
# ─────────────────────────────────────────────────────────────────────────────
LINK_1="[[$PATH_TO_DIR_IN_ALL][.]]"
LINK_2="[[$PATH_TO_ORG_IN_ALL][o]]"
NEW="** PROJ   $LINK_1 $LINK_2 $PROJECT_NAME"
FROM="* \[\[~/org/0_inbox\]\[Inbox\]\]"
TO="$FROM\\\n$NEW"
FROM=$(echo "$FROM" | sed 's;/;\\/;g')
TO=$(echo "$TO" | sed 's;/;\\/;g')
PATTERN="s/$FROM/$TO/g"

# Write to org-file.
# ─────────────────────────────────────────────────────────────────────────────
sed -i'' -e "$PATTERN" "$FILE_NAME"
cprint "Wrote to org index." "green"

# Create project directory.
# ─────────────────────────────────────────────────────────────────────────────
if [ ! -d "$PATH_TO_DIR_IN_INBOX" ]; then
    mkdir -p "$PATH_TO_DIR_IN_INBOX"
    cprint "Created directory at \`$PATH_TO_DIR_IN_INBOX\`." "green"
fi

# Create project org-file.
# ─────────────────────────────────────────────────────────────────────────────
TEMPLATE="#+startup: show2levels latexpreview\n#+title: $PROJECT_NAME"
if [ ! -f "$PATH_TO_ORG_IN_INBOX" ]; then
    echo "$TEMPLATE" > "$PATH_TO_ORG_IN_INBOX"
    cprint "Created org-file at \`$PATH_TO_ORG_IN_INBOX\`." "green"
fi

# Run `$ORG_HOME/Makefile` to auto-create symlinks & org-agenda config.
# ─────────────────────────────────────────────────────────────────────────────
PATH_TO_ORG_MAKEFILE="$ORG_HOME/Makefile"
if [ -f "$PATH_TO_ORG_MAKEFILE" ]; then
    cprint "Executing \`make org\`..." "yellow"
    cd "$ORG_HOME" && make org
fi

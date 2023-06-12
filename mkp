#!/bin/sh

# Make sure that exactly one argument is passed to this script. Else: Exit.
# ─────────────────────────────────────────────────────────────────────────────
nr_of_args_passed_to_this_script=$#
if [ $nr_of_args_passed_to_this_script -ne 1 ]; then
    echo "Please specify exactly one argument to the \`mkp\` command, i.e. the name of the project."
    exit
fi

# Make sure that the passed project name ends in "." (-> just a convention).
# ─────────────────────────────────────────────────────────────────────────────
PROJECT_NAME="$1"
if [[ "$PROJECT_NAME" != *"." ]]; then 
    echo "Project name should end in \".\""
    exit
fi

# Create POSIX-compatible project id for directory name.
# ─────────────────────────────────────────────────────────────────────────────
PROJECT_ID=$(echo "$PROJECT_NAME" | awk '{print tolower($0)}') # -> Lowercase
PROJECT_ID=$(echo "$PROJECT_ID" | sed 's/.$//')                # -> Remove dot.
PROJECT_ID=$(echo "$PROJECT_ID" | tr " " "_")                  # -> No spaces.

# Define paths that shall be created for the project.
# ─────────────────────────────────────────────────────────────────────────────
PATH_TO_DIR="$HOME/org/0_inbox/$PROJECT_ID"
PATH_TO_ORG="$PATH_TO_DIR/${PROJECT_NAME}org"

# Define path of org-file that shall be written into.
# ─────────────────────────────────────────────────────────────────────────────
FILE_NAME="$HOME/org/Index.org"
FILE_NAME=$(realpath $FILE_NAME)

# Define text that shall be added to the org-file.
# ─────────────────────────────────────────────────────────────────────────────
LINK_1="[[$PATH_TO_DIR][.]]"
LINK_2="[[$PATH_TO_ORG][o]]"
NEW="** PROJ $LINK_1 $LINK_2 $PROJECT_NAME"
FROM="* \[\[~/org/0_inbox\]\[Inbox\]\]"
TO="$FROM\\\n$NEW"
FROM=$(echo "$FROM" | sed 's;/;\\/;g')
TO=$(echo "$TO" | sed 's;/;\\/;g')
PATTERN="s/$FROM/$TO/g"

# Write to org-file.
# ─────────────────────────────────────────────────────────────────────────────
sed -i'' -e "$PATTERN" "$FILE_NAME"
echo "Wrote to org index."

# Create project directory.
# ─────────────────────────────────────────────────────────────────────────────
if [ ! -d "$PATH_TO_DIR" ]; then
    mkdir -p "$PATH_TO_DIR"
    echo "Created directory at \`$PATH_TO_DIR\`"
fi

# Create project org-file.
# ─────────────────────────────────────────────────────────────────────────────
TEMPLATE="#+title: $PROJECT_NAME"
if [ ! -f "$PATH_TO_ORG" ]; then
    echo "$TEMPLATE" > "$PATH_TO_ORG"
    echo "Created org-file at \`$PATH_TO_ORG\`"
fi

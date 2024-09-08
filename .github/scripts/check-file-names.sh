# Color printing setup
RED='\033[0;31m'
BOLD_RED='\033[1;31m'
GREEN='\033[0;32m'
CLEAR='\033[0m'

# Go to root directory
cd ../../ 

# Check file and directory names
WRONG_DIRS=$(find . -type d | grep -v '/\.' | egrep -v '^[\./_[:lower:]]+$')
WRONG_FILES=$(find . -name "*.gd" | egrep -v '^[\./_[:lower:]]+\.gd$')


# Print errors
if [ "$WRONG_DIRS" ] ; then
	echo "${BOLD_RED}ERROR: Directories should be named in snake_case"
	echo "${RED}$WRONG_DIRS"
else
	echo "${GREEN}All directory names correct"
fi


if [ "$WRONG_DIRS" ] && [ "$WRONG_FILES" ] ; then echo "" ; fi 


if [ "$WRONG_FILES" ] ; then
	echo "${BOLD_RED}ERROR: Files should be named in snake_case"
	echo "${RED}$WRONG_FILES"
else
	echo "${GREEN}All file names correct"
fi
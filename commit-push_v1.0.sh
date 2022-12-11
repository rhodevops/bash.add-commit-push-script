#!/bin/bash

# Definir variables
DIR="./"
SCRIPT_NAME="commit-and-push-script"
COMMIT_MESSAGE="nuevo contenido añadido en el documento"
REPO_TO_PUSH="origin"
BRANCH_TO_PUSH="main"

# Crear directorio (-d) y archivo temporales en $DIR y $TMP_DIR respect
TMP_DIR=$(mktemp -d -p "$DIR" tmp.XXXXXX)
TMP_FILE=$(mktemp --tmpdir=$TMP_DIR $SCRIPT_NAME.XXXXXX)

# Otra opción es crearlo en /tmp, localización por defecto
#TMP_FILE=$(mktemp /tmp/$SCRIPT_NAME.XXXXXX)

# --------- Test command --------- 
# Name
# test - check file types and compare values
#
# Synopsis
# [ EXPRESSION ]
# [ ]
# [ OPTION
# --------- Test command --------- 

# CHECKING .gitignore
# [ -e FILE							FILE exists
# grep -q (--quiet. --silent)		suppress all normal output
if [ -e .gitignore ] && grep --silent 'tmp.*' .gitignore ; then
	echo "----------------------------------"
	echo "CHECKING .gitignore"
	echo "ok"
else
	echo "----------------------------------"
	echo "CHECKING .gitignore"
	echo "ADDING tmp.* to .gitignore"
	echo '# Ignorar carpetas temporales' >> .gitignore
	echo 'tmp.*' >> .gitignore
fi

# Filtrar git status y redirijir stdout y stderr al archivo $TMP_FILE
git status | grep 'Changes not staged for commit\|Untracked files' &> $TMP_FILE

# EXECUTING: commit -a and push
# [ -s FILE 		FILE exists and has a size greater than zero
if [ -s $TMP_FILE ]; then
	echo "----------------------------------"
	echo "CHECKING ORIGIN REPO TO PUSHES"
	echo "RUN TO CONFIG:"
	echo "> git remote add origin <url repo>"
	echo "----------------------------------"
	git remote -v
	echo "----------------------------------"
	echo "EXECUTING: commit -a and push"
	echo "----------------------------------"
	git add . && git commit -m 'nuevo contenido añadido en el documento' && git push origin main
	#git add . && git restore --staged $TMP_FILE && git commit -m "$COMMIT_MESSAGE" && git push $REPO_TO_PUSH $BRANCH_TO_PUSH
else
	echo "----------------------------------"
	echo "No hay cambios en el repositorio"
	echo "----------------------------------"
fi

# Clean
rm -r $TMP_FILE
rm -r $TMP_DIR

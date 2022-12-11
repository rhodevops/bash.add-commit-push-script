#!/bin/bash

# Definir variables
DIR="./"
SCRIPT_NAME="commit-and-push-script"
COMMIT_MESSAGE="nuevo contenido añadido en el documento"
REPO_TO_PUSH="origin"
BRANCH_TO_PUSH="main"

# Crear directorio y archivos temporales en $DIR y $TMP_DIR respect
TMP_DIR=$(mktemp -d -p "$DIR" tmp.XXXXXX)
TMP_FILE=$(mktemp --tmpdir=$TMP_DIR $SCRIPT_NAME.XXXXXX)
TMP_FILE_2=$(mktemp --tmpdir=$TMP_DIR $SCRIPT_NAME.XXXXXX)

# Otra opción es crearlo en /tmp, localización por defecto
#TMP_FILE=$(mktemp /tmp/$SCRIPT_NAME.XXXXXX)

# Filtrar git status y redirijir stdout al archivo $TMP_FILE
git status | grep 'Changes not staged for commit\|Untracked files' &> $TMP_FILE

# CHECKING .gitignore
# -e FILE -> FILE exists
if [ -e .gitignore ]; then
	grep 'tmp.*' .gitignore &>> $TMP_FILE_2
	if [ -s $TMP_FILE_2 ]; then
	echo "----------------------------------"
	echo "CHECKING .gitignore"
	echo "ok"
	else
	echo "----------------------------------"
	echo "CHECKING.gitignore"
	echo "ADDING tmp.* to .gitignore"
	echo '# Ignorar carpetas temporales' >> .gitignore
	echo 'tmp.*' >> .gitignore
	fi
else
	echo "----------------------------------"
	echo "CHECKING .gitignore"
	echo "CREATING .gitignore"
	echo "ADDING tmp.* to .gitignore"
	echo '# Ignorar carpetas temporales' >> .gitignore
	echo 'tmp.*' >> .gitignore
fi

# EXECUTING: commit -a and push
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
rm -r $TMP_FILE_2
rm -r $TMP_DIR

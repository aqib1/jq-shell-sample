set -eux

if [ "$#" -ne 1 ]; then
 echo "Illegal numbers of parameters"
 echo "project_export.sh [PROJECT]"
 echo "e.g project_export.sh "
fi

meta_backups_path="/meta_backups/"

echo "Removing meta backups from kylin server"
rm -rf ${meta_backups_path}

PROJECT=$1;

echo "Project named recieved = > " $PROJECT

echo "Fetching details about project [$PROJECT] from [METASTORE]"

./metastore.sh fetch /project/${PROJECT}.json

project_meta=`ls /meta_backups/`
project_path="${meta_backups_path}${project_meta}/project"

echo "Looping through all tables from project json"
for table in $(cat ${project_path}/${PROJECT}.json | jq .tables[]); do
 table=$(echo ${table} | tr --delete '"')
 echo "Table => " $table
 done

for model in $(cat ${project_path}/${PROJECT}.json | jq .models[]); do
 model=$(echo ${model} | tr --delete '"')
 echo "Model => " $model
 done
for realization in $(cat ${project_path}/${PROJECT}.json | jq '.realizations[] | select(.type == "CUBE").realization'); do
 realization=$(echo ${realization} | tr --delete '"')
 echo $realization
 done

project_dir_meta_backup=${meta_backups_path}${PROJECT}
echo "Creating project meta backup dir => " project_dir_meta_backup
mkdir ${project_dir_meta_backup}

#cp -avr ${meta_backups_path}meta* ${project_dir_meta_backup}"/"

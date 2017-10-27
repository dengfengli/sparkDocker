#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters. Usage: submit-dag.sh dagPath jarPath"
    exit
fi

dagPath=$1
dagName=$(basename $dagPath)

jarPath=$2
jarName=$(basename $jarPath)

echo "Submitting...."

docker cp $dagPath airflow:/usr/local/airflow/dags/$dagName
docker cp $jarPath airflow:/$jarName
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators import SparkSubmitOperator
from datetime import datetime, timedelta

APPLICATION_FILE_PATH = "/spark_examples.jar"
APPLICATION_CLASS = "org.apache.spark.examples.LogQuery"

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2015, 10, 25),
    'email': ['airflow@airflow.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
    # 'queue': 'bash_queue',
    # 'pool': 'backfill',
    # 'priority_weight': 10,
    # 'end_date': datetime(2016, 1, 1),
}

dag = DAG(
    'spark-test', default_args=default_args, schedule_interval=timedelta(1))

# t1, t2 and t3 are examples of tasks created by instantiating operators
t1 = BashOperator(
    task_id='print_date',
    bash_command='date',
    dag=dag)

t2 = SparkSubmitOperator(
    task_id='spark-test',
    master="yarn",
    deploy_mode="cluster",
    application_file=APPLICATION_FILE_PATH,
    main_class=APPLICATION_CLASS,
    dag=dag)


t2.set_upstream(t1) 
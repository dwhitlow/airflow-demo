# airflow-demo

This is a skeleton project for an Airflow 1.10 docker-compose-based setup.

It supports two executors:

## LocalExecutor

Start with: `docker-compose up`

Using the LocalExecutor, Airflow will execute tasks directly on the container running the scheduler process.

## CeleryExecutor

Start with: `docker-compose -f docker-compose.celery.yaml up`

Airflow will execute tasks on the celery worker containers, queueing tasks and storing results in a Redis database.

## Dependency Management

This project uses [pip-tools](https://github.com/jazzband/pip-tools) to freeze transitive dependency versions.
If it is not available in your current python environment, install it: `pip install pip-tools`.
The top level dependencies can be found in `requirements.in`. Running `pip-compile` will regenerate `requirements.txt`.
Running `pip-sync` will synchronize the packages in `requirements.txt` with your current python environment.

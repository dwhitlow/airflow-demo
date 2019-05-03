FROM python:3.6-slim as base


# Build and install dependencies in a separate stage. This will leave system build tools, apt data, pip caches,
# and any devpi credentials you may need to add out of the final image
FROM base as deps

RUN apt-get update && apt-get install -y gcc

COPY requirements.txt /requirements.txt
# Installing to a non-default path allows us to easily copy the installed packages to the final build stage
# --no-warn-script-location suppresses warnings from the non-default installation path
# SLUGIFY_USES_TEXT_UNIDECODE=yes is required to successfully install the airflow package, and avoids pulling in a
# GPL-licensed library.
RUN SLUGIFY_USES_TEXT_UNIDECODE=yes pip install --prefix=/install --no-warn-script-location -r /requirements.txt


# The final build stage--only these layers will be included in the resulting image
FROM base

# Setup user and home/case directories
ENV AIRFLOW_HOME="/home/airflow"
ENV AIRFLOW_USER="airflow"
RUN useradd -ms /bin/bash -d ${AIRFLOW_HOME} ${AIRFLOW_USER}
RUN mkdir /var-data && chown -R ${AIRFLOW_USER} ${AIRFLOW_HOME} /var-data

# Copy installed python dependencies from the earlier build stage
COPY --from=deps /install /usr/local

WORKDIR ${AIRFLOW_HOME}
USER ${AIRFLOW_USER}

# 8080: used by airflow UI web server
# 5555: used by celery flower
# 8793: used by airflow log server when a celery worker is started via `airflow worker`
EXPOSE 8080 5555 8793

ARG PYTHON_VERSION=3.12-slim-bullseye
FROM python:${PYTHON_VERSION}

RUN python -m venv /opt/venv

ENV PATH=/opt/venv/bin:$PATH

RUN pip install --upgrade pip

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install -y \
    #for postgres
    libpq-dev \
    #for Pillow
    libjpeg-dev \
    #for CairoSVG
    libcairo2 \
    #other
    gcc \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /code

WORKDIR /code

COPY requirement.txt /tmp/requirement.txt

COPY ./src code

RUN pip install -r /tmp/requirement.txt

ARG PROJ_NAME="cfehome"

#create a bash script to run the Django project
RUN printf "#!/bin/bash\n" > ./paracard_runner .sh && \
    printf "RUN_PORT=\"\${PORT:8000}\"n\n" >> ./paracard_runner .sh && \
    printf "python manage.py migrate --no-input\n" >> ./paracard_runner .sh && \
    printf "gunicorn ${PROJ_NAME}.wsgl:application --bind \"0.0.0.0:\$RUN_PORT\"\n" >> ./paracard_runner .sh && \
#make the bash script executable
RUN chmod +x paracard_runner .sh

RUN apt-get remove --purge -y \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

CMD ./paracard_runner.sh
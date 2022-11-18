FROM python:3.9-alpine3.13
LABEL maintainer="sarantos"

ENV PYTHONNUNBUFFERED 1

# copies requirements to docker img 
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# copies app to container
COPY ./app /app

# our commands will run from
WORKDIR /app

EXPOSE 8000

ARG DEV=false

# runs a command (one run block) 
# new image layer in every single command we run 
# using backslice we add more commands 
# we are using a VM 

# 28. upgrade python package manager inside our VM
# 29. install list of requirements inside dockerimg
# 30. remove /tmp directory cause we dont need it after
# 31. adds new user inside our img. Its best practise not to you root user

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Whenever we run any Python commands, 
# it will run automatically
# from our Virtual Enviroment
ENV PATH="/py/bin:$PATH"

# After that line, anything is going to run as as django user and not root user
USER django-user


# Select base image
FROM ubuntu:rolling

# Identify the maintainer of an image
LABEL maintainer="ronaldo.aguirre@protonmail.com"
 
# Update the image to the latest packages & other packages
RUN apt-get update && apt-get upgrade -y \
    # Install vim
    && apt-get install -y vim \
    # Install R
    && apt-get -y install r-base 

# Set workspace
WORKDIR /home/scrap

# Install auxiliar packages to Plumber
RUN apt-get install -y --no-install-recommends git-core \
libssl-dev libsasl2-dev libcurl4-gnutls-dev curl libsodium-dev libxml2-dev libfontconfig1-dev

# Install & set encoding UTF-8
RUN apt-get install -y locales
RUN sed -i '/es_ES.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG es_ES.UTF-8  
ENV LANGUAGE es_ES:es  
ENV LC_ALL es_ES.UTF-8  

# Install & set time zone
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Madrid
RUN apt-get install -y tzdata

# Install R packages
RUN R -e "install.packages(c('devtools','plumber','RSelenium','jsonlite'))"

# Move R project to container
COPY main.R ./main.R
COPY plumber_run.R ./plumber_run.R

# Port plumber 
EXPOSE 80

# Run Plumber
ENTRYPOINT ["R", "-f", "./plumber_run.R", "--slave"]

FROM nginx:latest

ENV APP_NAME="project SMKN 1 Jakarta"

EXPOSE 80

COPY . /usr/share/nginx/html


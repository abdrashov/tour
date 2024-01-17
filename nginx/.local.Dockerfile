FROM nginx:latest

COPY nginx.conf /etc/nginx/nginx.conf
COPY sites /etc/nginx/sites

EXPOSE 80 443
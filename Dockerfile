FROM nginx:stable

COPY dist /usr/share/nginx/html
COPY config/nginx.conf /etc/nginx/conf.d/default.conf

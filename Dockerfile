FROM cfmanteiga/alpine-bash-curl-jq
ADD /app /app
RUN chmod -R +x /app
WORKDIR /app

FROM amazon/aws-cli

ARG APP_ENV
ENV APP_ENV=${APP_ENV}

ENTRYPOINT []
CMD aws s3 cp /backups/latest/ s3://{{ cookiecutter.project_slug }}-$APP_ENV-backups/ --recursive
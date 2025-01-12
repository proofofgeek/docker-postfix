FROM ubuntu:latest

LABEL maintainer="proofofgeek.com"

ARG APP_USER
ARG APP_PASSWORD
ARG ALIAS_EMAIL
ARG MAIL_NAME
ARG SMTP_DOMAIN
ARG SMTP_PORT

RUN apt-get update && \
    apt-get install -y mailutils postfix rsyslog

COPY main.cf /etc/postfix/main.cf

RUN sh -c 'printf "myhostname = postfix.${MAIL_NAME}\n" >> /etc/postfix/main.cf' && \
    sh -c 'printf "relayhost = [${SMTP_DOMAIN}]:${SMTP_PORT}\n" >> /etc/postfix/main.cf' && \
    sh -c 'printf "[${SMTP_DOMAIN}]:${SMTP_PORT} ${APP_USER}:${APP_PASSWORD}\n" > /etc/postfix/sasl_passwd' && \
    sh -c 'printf "root: ${ALIAS_EMAIL}\n" >> /etc/aliases' && \
    sh -c 'printf "${MAIL_NAME}\n" > /etc/mailname' && \
    sh -c 'printf "/^From:.*/ REPLACE From: postfix@${MAIL_NAME}\n" > /etc/postfix/header_check' && \
    sh -c 'printf "/.+/ postfix@${MAIL_NAME}\n" > /etc/postfix/sender_canonical_maps' && \
    postmap /etc/postfix/sasl_passwd && \
    chmod 0600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db

CMD newaliases && \
    postconf maillog_file=/var/log/mail.log && \
    service postfix restart && \
    tail -f /dev/null

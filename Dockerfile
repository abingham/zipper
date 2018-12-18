FROM  cyberdojo/rack-base
LABEL maintainer=jon@jaggersoft.com

COPY . /app
RUN chown -R nobody:nogroup /app

ARG SHA
ENV SHA=${SHA}

EXPOSE 4587
USER nobody
CMD [ "./up.sh" ]

FROM sherrycherish/krpano:latest

RUN mkdir /images
RUN mkdir /outputs

COPY scripts /scripts
RUN ln -s /app/krpano-1.19-pr12/krpanotools /usr/bin/krpanotools

ENTRYPOINT ["bash", "/scripts/convert.sh"]

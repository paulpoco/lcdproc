FROM gliderlabs/alpine:3.3

RUN apk add --update bash && rm -rf /var/cache/apk/*
CMD ["/bin/bash"]

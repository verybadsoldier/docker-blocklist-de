FROM alpine:latest AS builder

RUN apk add \
	git

RUN git clone https://github.com/kubax/blocklist-with-nftables.git; \
    cd blocklist-with-nftables; \
    git checkout b1e3ec4d07d89cd4009eef7c46dcbb3ae8787d01

FROM ubuntu:latest

RUN apt-get update && apt-get -y install cron \
        perl \
	libdata-validate-ip-perl \
	nftables \
	wget \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir /blocklist;mkdir /etc/blocklist
COPY --from=builder /blocklist-with-nftables/blocklist.pl /blocklist
COPY --from=builder /blocklist-with-nftables/whitelist /etc/blocklist
COPY --from=builder /blocklist-with-nftables/blacklist /etc/blocklist

RUN chmod +x /blocklist/blocklist.pl

RUN ln -s /blocklist/blocklist.pl /etc/cron.hourly

CMD ["cron", "-f"]

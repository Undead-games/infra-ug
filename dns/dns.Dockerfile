FROM strm/dnsmasq

ARG ROUTER_IP

COPY dnsmasq.conf /etc/dnsmasq.conf
COPY ./dnsmasq.d /etc/dnsmasq.d
RUN sed -i "s/{{ROUTER_IP}}/${ROUTER_IP}/g" /etc/dnsmasq.conf

ENTRYPOINT [ "dnsmasq", "-k", "--log-facility=-" ]
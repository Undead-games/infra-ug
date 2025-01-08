FROM strm/dnsmasq

COPY dnsmasq.conf /etc/dnsmasq.conf
COPY ./dnsmasq.d /etc/dnsmasq.d
RUN sed -i "s/{{ROUTER_IP}}/${SERVER_IP}/g" /etc/dnsmasq.conf

ENTRYPOINT [ "dnsmasq", "-k" ]
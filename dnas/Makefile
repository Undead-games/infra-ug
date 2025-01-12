include ../.env

export:
	cp conf/apache/dnas.conf ../apache/sites-enabled
	cp conf/dnsmasq/dnas.conf ../dns/dnsmasq.d
	sed -i "s/{{SERVER_IP}}/${SERVER_IP}/g" ../dns/dnsmasq.d/dnas.conf
	mkdir -p ../apache/www/dnas
	mkdir -p ../apache/etc/dnas
	cp -r public ../apache/www/dnas
	cp -r conf/apache/certs/* ../apache/etc/dnas
	cp docker-compose.yaml ../docker-compose.dnas.yaml
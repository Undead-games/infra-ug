include ../.env

export:
	cp conf/apache/dnas.conf ../apache/sites-available
	cp conf/dnsmasq/dnas.conf ../dns/dnsmasq.d
	sed -i "s/{{SERVER_IP}}/${SERVER_IP}/g" ../apache/sites-available/dnas.conf
	sed -i "s/{{SERVER_IP}}/${SERVER_IP}/g" ../dns/dnsmasq.d/dnas.conf
	mkdir -p ../apache/www/dnas
	cp -r public ../apache/www/dnas
	cp docker-compose.yaml ../docker-compose.dnas.yaml
SHELL = /bin/sh

UID := $(shell id -u)
GID := $(shell id -g)

COMPOSE_FILES := $(shell ls -x docker-compose.*.yaml)
COMPOSE_FILES_PARAM := -f $(shell echo ${COMPOSE_FILES} | sed -r 's/ / \-f /g')

DOCKER_BIN := $(shell which docker)
MAKE_BIN := $(shell which make)

include .env

init:
	cp dnas/.env.example dnas/.env
	cp dns/.env.example dns/.env

export:
	cd dnas && ${MAKE_BIN} export
	cd apache && ${MAKE_BIN} export
	cd dns && ${MAKE_BIN} export

build:
	${DOCKER_BIN} compose ${COMPOSE_FILES_PARAM} build 

run: disable-systemd-resolved
	${DOCKER_BIN} compose ${COMPOSE_FILES_PARAM} up

run-daemon: disable-systemd-resolved
	${DOCKER_BIN} compose ${COMPOSE_FILES_PARAM} up -d

down:
	${DOCKER_BIN} compose ${COMPOSE_FILES_PARAM} down
	make enable-systemd-resovled

disable-systemd-resolved:
	sudo mv /etc/resolv.conf /etc/.resolv.conf
	sudo systemctl disable systemd-resolved
	sudo systemctl stop systemd-resolved

enable-systemd-resovled:
	sudo mv /etc/.resolv.conf /etc/resolv.conf
	sudo systemctl enable systemd-resolved
	sudo systemctl start systemd-resolved
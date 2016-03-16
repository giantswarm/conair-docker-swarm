#!/bin/sh

DOCKER_HOST=$(sudo conair ip swarm-mgr0):4000 docker-compose up -d

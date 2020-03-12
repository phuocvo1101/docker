if [ ! -f /usr/local/bin/docker-compose ]; then
    if [ ! -f /var/lib/boot2docker/docker-compose ]; then
        curl -L https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d '"' -f 4)/docker-compose-`uname -s`-`uname -m` > /var/lib/boot2docker/docker-compose
    fi
    cp /var/lib/boot2docker/docker-compose /usr/local/bin/docker-compose
fi

if [ -f /var/lib/boot2docker/docker_config.json ]; then
    mkdir -p /home/docker/.docker
    cp /var/lib/boot2docker/docker_config.json /home/docker/.docker/config.json && chown docker:docker /home/docker/.docker/config.json
fi

chmod +x /usr/local/bin/docker-compose
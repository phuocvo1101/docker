cai docker
https://docs.docker.com/toolbox/toolbox_install_windows/

1. B1--- DOWNLOAD DOCKER TOOLBOX ------------------------------------

+++++++o enable VTx and VTd you have to change corresponding settings in the BIOS.
Here is an example how to do it for HP Compaq 8200 or similar PC:
Start the machine.
Press F10 to enter BIOS.
System configuration -> Device Configuratiion
Enable Virtualization Technology (VTx) and Virtualization Technology Directed I/O (VTd).
Save and restart the machine.
+++++++++++++++
https://docs.docker.com/toolbox/toolbox_install_windows/
1.1 Download docker toolbox from https://github.com/docker/toolbox/releases/download/v18.09.3/DockerToolbox-18.09.3.exe
1.2 Open setup file, click next next  theo image/B1/install_1,2,3,,,7

2. B2----------------TAO DOCKER MACHINE------------------------------
You can run these command in Windows command line or Git Bash
Create machine
In this tutorial, I will set machine name is dev
Replace 40000 by storage you want. 40000 mean 40GB

```$ docker-machine create --virtualbox-disk-size "40000" --virtualbox-cpu-count "2" --virtualbox-memory "4096" --driver "virtualbox"  dev ```

If you want to mount the source code different default (C:) driver, add parameter --virtualbox-share-folder

```$ docker-machine create --virtualbox-disk-size "40000" --virtualbox-cpu-count "2" --virtualbox-memory "4096" --driver "virtualbox" --virtualbox-share-folder "d:\\:/d" dev```

hinh: B2/create-machine.png

Check IP of machine
```$ docker-machine ip dev```

SSH to machine
```$ docker-machine ssh dev```


3. B3----------------SETUP DOCKER COMPOSE------------------------------
3.1 SSH to docker machine
3.2 Run script below to download docker-compose ( theo cach 2)
cach 1: 
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

cach 2 ( cong ty )
wget https://gitlab.seldatdirect.com/snippets/2/raw -O- | tr -d '\r' > /var/lib/boot2docker/bootlocal.sh && sudo sh /var/lib/boot2docker/bootlocal.sh

```
+ tao file bootlocal.sh  ( trong /var/lib/boot2docker/bootlocal.sh)
   + run sudo sh /var/lib/boot2docker/bootlocal.sh
```


4. B4-------DEPLOY Web server & MYSQL Server---------------------

4.1 tạo folder D   là : d/docker nhu da co
4.2 SSH to dev machine
4.3 Create Nginx proxy
```
$ cd /c/Users/<username>/docker/docker-compose/nginx/
$ docker-compose up -d
```
4.4 Create Web server
version: '3'
services:
  web:
    image: gitlab.hub.seldatdirect.com/docker-image/ubuntu16:php7.1-nginx # Image built by Platform Team
    container_name: web # Set container name
    volumes:
      - /c:/c # If your source code on D:\, change to  /d:/d
      - ./nginx-conf:/etc/nginx/sites-enabled # mount nginx virtual host
    environment:
      - VIRTUAL_HOST=*.local.com  # Nginx proxy will base on this value to proxy
    extra_hosts:
      - "docker.local:172.17.0.1"
    restart: always
    network_mode: bridge

```
$ cd /c/User/<username>/docker/docker-compose/web/
$ docker-compose up -d

```
After run web container, you will have new folder at /c/User/<username>/docker/docker-compose/web/nginx-conf . This folder is mounted to /etc/nginx/sites-enabled
Whenever you want to create new virtual host file, You must create file in this folder then go to inside container and enable it by the command below:
```$ docker exec -it web bash ```
then
```$ service nginx reload ```

Next step, create a demo virtual host file in /c/User/<username>/docker/docker-compose/web/nginx-conf



Create docekr-compose file at /c/User/<username>/docker/docker-compose/web/nginx-conf/test.local.com.conf

server {
    root <SOURCE_PATH>;
    index index.php;

    server_name test.local.com;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        try_files $uri /index.php =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}

Replace <SOURCE_PATH> to your source code path, example: /c/User/valhein/source/test.local.com/public

4.5 Edit windows hosts file
Add record below to windows hosts file C:\Windows\System32\drivers\etc\hosts
```192.168.99.100 test.local.com docker.local  ```
4.6 Create MYSQL Server
```
$ cd /c/Users/<username>/docker/docker-compose/mysql/
$ docker-compose up -d 

```

How to connect to mysql in docker

4.7  Test on browser
Enter http://test.local.com on browser and view result

1. <h1> B1--- DOWNLOAD DOCKER TOOLBOX ------------------------------------ </h1>
<p>
+++++++o enable VTx and VTd you have to change corresponding settings in the BIOS.
Here is an example how to do it for HP Compaq 8200 or similar PC:
Start the machine.
Press F10 to enter BIOS.
System configuration -> Device Configuratiion
Enable Virtualization Technology (VTx) and Virtualization Technology Directed I/O (VTd).
Save and restart the machine.
+++++++++++++++
</p>
https://docs.docker.com/toolbox/toolbox_install_windows/ </n>
1.1 Download docker toolbox from https://github.com/docker/toolbox/releases/download/v18.09.3/DockerToolbox-18.09.3.exe </n>
1.2 Open setup file, click next next  theo image/B1/install_1,2,3,,,7 </n>

2. <h1>B2----------------TAO DOCKER MACHINE------------------------------</h1>
You can run these command in Windows command line or Git Bash </n>
<h3>Create machine</h3>
In this tutorial, I will set machine name is dev </n>
Replace 40000 by storage you want. 40000 mean 40GB

```$ docker-machine create --virtualbox-disk-size "40000" --virtualbox-cpu-count "2" --virtualbox-memory "4096" --driver "virtualbox"  dev ```

If you want to mount the source code different default (C:) driver, add parameter --virtualbox-share-folder

```$ docker-machine create --virtualbox-disk-size "40000" --virtualbox-cpu-count "2" --virtualbox-memory "4096" --driver "virtualbox" --virtualbox-share-folder "d:\\:/d" dev```

hinh: B2/create-machine.png

<b>Check IP of machine</b>
```$ docker-machine ip dev```

<b>SSH to machine</b>
```$ docker-machine ssh dev```


3. <h1>B3----------------SETUP DOCKER COMPOSE------------------------------</h1>
3.1 SSH to docker machine </n>
3.2 Run script below to download docker-compose ( theo cach 2) </n>
<b>cach 1: </b> </br>
<p>
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
</p>

<b>cach 2 ( cong ty )<//b>
```
wget https://gitlab.seldatdirect.com/snippets/2/raw -O- | tr -d '\r' > /var/lib/boot2docker/bootlocal.sh && sudo sh /var/lib/boot2docker/bootlocal.sh
```

```
+ tao file bootlocal.sh  ( trong /var/lib/boot2docker/bootlocal.sh)
   + run sudo sh /var/lib/boot2docker/bootlocal.sh
```


4. <h1>B4-------DEPLOY Web server & MYSQL Server---------------------</h1>

4.1 tạo folder D   là : d/docker nhu da co </br>
4.2 SSH to dev machine </br>
4.3 Create Nginx proxy </br>
```
$ cd /c/Users/<username>/docker/docker-compose/nginx/
$ docker-compose up -d
```
4.4 Create Web server </br>
```
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

```
$ cd /c/User/<username>/docker/docker-compose/web/
$ docker-compose up -d

```
After run web container, you will have new folder at /c/User/<username>/docker/docker-compose/web/nginx-conf . This folder is mounted to /etc/nginx/sites-enabled
Whenever you want to create new virtual host file, You must create file in this folder then go to inside container and enable it by the command below: </br>
```$ docker exec -it web bash ``` </br>
then
```$ service nginx reload ``` </br>

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

4.5 <h3>Edit windows hosts file</h3>
Add record below to windows hosts file C:\Windows\System32\drivers\etc\hosts </br>
```192.168.99.100 test.local.com docker.local  ```
4.6 <h3>Create MYSQL Server</h3>
```
$ cd /c/Users/<username>/docker/docker-compose/mysql/
$ docker-compose up -d 

```
How to connect to mysql in docker </br>
hinh : image/B4

4.7  <h3>Test on browser </h3>
Enter http://test.local.com on browser and view result


** tai lieu **
https://hub.docker.com/u/caohoanganhuit

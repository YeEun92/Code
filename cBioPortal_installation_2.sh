
### install mysql
# at ubuntu 16.04 environment

sudo apt-get install mysql-server-5.7

# make new password for MYSQL ; 1234 #

sudo apt-get update

# install java
sudo apt-get install default-jdk

sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

### install tomcat
# https://www.digitalocean.com/community/tutorials/how-to-install-apache-tomcat-8-on-ubuntu-16-04

cd /tmp
sudo apt-get install curl

# if use new version of tomcat, modify version of tomcat at this code
curl -O http://apache.tt.co.kr/tomcat/tomcat-8/v8.5.56/bin/apache-tomcat-8.5.56.tar.gz
sudo mkdir /opt/tomcat
sudo tar xzvf apache-tomcat-8.5.56*tar.gz -C /opt/tomcat --strip-components=1

cd /opt/tomcat
sudo chgrp -R tomcat /opt/tomcat
sudo chmod -R g+r conf
sudo chmod g+x conf
sudo chown -R tomcat webapps/ work/ temp/ logs/
sudo update-java-alternatives -l
sudo update-alternatives --config java

# makr service file

sudo nano /etc/systemd/system/tomcat.service

##

[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target

##

# start tomcat service

sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl status tomcat
# to exit, press :q

sudo ufw allow 8080

sudo systemctl enable tomcat
sudo nano /opt/tomcat/conf/tomcat-users.xml

# make your personal one at "admin", "password" 
<user username="role1" password="<must-be-changed>" roles="role1"/>
    <user username="admin" password="password" roles="manager-gui,admin-gui"/>
</tomcat-users>

sudo systemctl restart tomcat

# see your tomcat at firefox
# http://localhost:8080


### download database
# https://github.com/cBioPortal/cbioportal/blob/master/docs/Pre-Build-Steps.md

sudo apt-get install maven
sudo apt-get install git

cd ~/
git clone https://github.com/cBioPortal/cbioportal.git
cd cbioportal
git checkout master

cd src/main/resource
cp log4j.properties.EXAMPLE log4j.properties
mysql -u root -p

# in mysql env

create database cbioportal;
create database cgds_test;
CREATE USER 'cbio_user'@'localhost' IDENTIFIED BY 'somepassword';
GRANT ALL ON cbioportal.* TO 'cbio_user'@'localhost';
GRANT ALL ON cgds_test.* TO 'cbio_user'@'localhost';
flush privileges;
exit

# EXIT

cd /etc/maven/
mkdir ~/.m2
cp settings.xml ~/.m2/settings.xml
cd ~/.m2/
sudo nano settings.xml

# add this line to settings.xml

# from

<server>
      <id>deploymentRepo</id>
      <username>repouser</username>
      <password>repopwd</password>
    </server>
    -->

    <!-- Another sample, using keys to authenticate.
    <server>
      <id>siteServer</id>
      <privateKey>/path/to/private/key</privateKey>
      <passphrase>optional; leave empty if not used.</passphrase>
    </server>
    -->
  </server>

  <!-- mirrors

# to

<server>
      <id>deploymentRepo</id>
      <username>repouser</username>
      <password>repopwd</password>
    </server>
    -->

    <!-- Another sample, using keys to authenticate.
    <server>
      <id>siteServer</id>
      <privateKey>/path/to/private/key</privateKey>
      <passphrase>optional; leave empty if not used.</passphrase>
    </server>
    -->
        <server>
      <id>settingsKey</id>
      <username>cbio_user</username>
      <password>somepassword</password>
    </server>
  </servers>

  <!-- mirrors

# save and exit

# make PATH
sudo nano /etc/bash.bashrc

# add this line at last line of 'bash.bashrc'

export PORTAL_HOME=/home/cbio/cbioportal

# save and exit

source /etc/bash.bashrc

# test PATH

cd $PORTAL_HOME
pwd

# install mvn

sudo mvn -DskipTests clean install

# copy&paste
# https://github.com/cBioPortal/cbioportal/v2.0.0/db-scripts/src/main/resources/cgds.sql

# download seed DB

wget https://github.com/cBioPortal/datahub/raw/master/seedDB/seed-cbioportal_hg19_v2.7.3.sql.gz

# mysql password ; somepassword

mysql --user=cbio_user -p cbioportal < cgds.sql

gunzip *.sql.gz

mysql --user=cbio_user -p cbioportal < seed-cbioportal_hg19_v2.7.3.sql

# modify bash.bashrc

sudo nano /etc/bash.bashrc

# add at last line of bash.bashrc

export CATALINA_HOME=/opt/tomcat

# sourcing

source /etc/bash.bashrc

cd ~/cbioportal/src/main/resources
cp portal.properties.EXAMPLE $HOME/cbioportal/portal.properties

cd $CATALINA_HOME

sudo su

cd bin

# make new sh file

nano setenv.sh

# in setenv.sh

export PORTAL_HOME=/home/cbio/cbioportal
CATALINA_OPTS='-Dauthenticate=false'

# Exit

## download mysql connector
# page ; https://downloads.mysql.com/archives/c-j/
# version ; 5.1.15


cd ~/Download

sudo cp mysql-connector-java-5.1.15.bundle.jar $CATALINA_HOME/lib/mysql-connector-java-5.1.15.bundle.jar


# resource definitions with context.xml

sudo nano $CATALINA_HOME/conf/context.xml

# in context.xml
# add line at under <WatchedResource> line

 <Resource name="jdbc/cbioportal" auth="Container" type="javax.sql.DataSource"
        maxActive="100" maxIdle="30" maxWait="10000"
        username="cbio_user" password="somepassword" driverClassName="com.mysql.jdbc.Driver"
        connectionProperties="zeroDateTimeBehavior=convertToNull;"
        testOnBorrow="true"
        validationQuery="SELECT 1"
        url="jdbc:mysql://localhost:3306/cbioportal"/>
# exit

## Running session

# install mongoDB
# https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/

# Step 1 ; Import the public key used by the package management system.

wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -

# Step 2 ; Create a list file for MongoDB

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list


# Step 3 ; Reload local package database

sudo apt-get update

# Step 4 ;Install the MongoDB packages

sudo apt-get install -y mongodb-org
# if you wanna hold that old version
echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-org-shell hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections

# start mongo db
sudo systemctl start mongod

# create database 'session_service' using 'mongo'shell interface

mongo

# in mongo
use session_service
# exit


git clone https://github.com/cBioPortal/session-service.git
cd session-service
mvn package -Dpackaging.type=jar
java -Dspring.data.mongodb.uri=mongodb://localhost:27017/session-service -jar target/session_service-0.1.0.jar


# add line 'session.service.url='

# nano $PORTAL_HOME/portal.properties file

# session-service url: http://[host]:[port]/[session_service_app]/api/sessions/[portal_instance]/
# example session-service url: http://localhost:8080/session_service/api/sessions/public_portal/
# see: https://github.com/cBioPortal/session-service
session.service.url= http://localhost:8080/cbioportal
# or this ; session.service.url=http://localhost:8080/session_service/api/sessions/cbioportal

# exit

sudo systemctl stop tomcat
sudo systemctl start tomcat


# additional - not specified
java -jar portal/target/dependency/webapp-runner.jar --help


sudo java \
    -jar \
    -Dauthenticate=noauthsessionservice \
    portal/target/dependency/webapp-runner.jar \
    portal/target/cbioportal.war



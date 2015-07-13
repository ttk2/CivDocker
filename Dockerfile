#Docker Automated build file for Civcraft images
FROM debian

MAINTAINER ttk2@civcraft.co

ENV user minecraft

#Update the package list, set password for mysql unattended install, then install all needed packages.
# Note, mysql root password must be set here for time being
RUN apt-get update
RUN ["/bin/bash", "-c", "debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'"]
RUN ["/bin/bash", "-c", "debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'"]
RUN apt-get install -y sudo openjdk-7-jre htop apt-utils mariadb-server wget git nano vim
RUN apt-get -y upgrade
 
RUN service mysql start ; mysql -u root -ppassword -e 'create database minecraft' ; mysql -u root -ppassword -e 'create user minecraft@localhost' ; mysql -u root -ppassword -e 'GRANT ALL ON minecraft.* TO minecraft@localhost' ;

#Create user and home directory
RUN useradd -p test $user
RUN mkdir /home/$user
RUN chown -R $user /home/$user 

USER $user
#Compile spigot
RUN mkdir ~/build
RUN cd ~/build ; wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
RUN cd ~/build ; java -jar BuildTools.jar
RUN mv ~/build/spigot-1.8.7.jar ~/spigot.jar

#Get and setup plugins
RUN cd ~ ; git clone https://github.com/ttk2/DockerBootstrapping
RUN cp -r ~/DockerBootstrapping/* ~
RUN rm -r ~/DockerBootstrapping 

USER root

CMD service mysql start ; su minecraft -c "cd ~ ; ./spigot.sh"

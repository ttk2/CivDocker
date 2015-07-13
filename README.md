# CivDocker
Dockerfile for generating a Civcraft server for testing.

This dockerfile will generate a working Civcraft server by downloading a barebones debian image, installing all the needed packages, and downloading/configuring all the Civcraft plugins. 

To build this container grab the contents of this repository and run 

> docker build . 

Inside of the folder containing the Dockerfile, this will take some time. 

Once the container is built grab the ID and run this 

> docker run -i -p 25565:25565 [ID] 

The server should start up and be running on localhost, you can now connect and play on it. 

When the minecraft server stops the container will close, to start it again note the new container ID created when you start the image using 

> docker ps

While the container is running, its important to understand that the image made with the build is a base image, and each run command generates a new copy unless you take the ID of an already started one.  

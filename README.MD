# Docker #

* GET ACTIVE DOCKER CONTAINERS
``` docker ps ```
* GET ALL DOCKER CONTAINERS
``` docker ps -a ```
* GET ALL IMAGES
``` docker images```
* STOP RUNNING CONTAINER FORCEFULLY
``` docker rm container_name/id -f  ```

### FYI: npm install —only=production, this will prevent devDependencies from getting installed while doing nom install in production environment. ###

### IF you would like to print environment variables inside bash shell ###
``` printenv ```

## Listing docker volumes ##
``` Docker volume ls ```


*** If you made changes in Dockerfile then you need to rebuild the image using docker build, otherwise you can run docker image without building it. ***



### Creating docker image using Dockerfile ###
    - [x] docker build -t imageTag pathToDockerFile
    - [x] Docker build -t node-app-image . 
        - . Specify the path where Dockerfile is present, normally we run this command from current root of the project where Dockerfile is present, that path is denoted by ‘ . ’
        - -t denotes tag name for image


### Running the created docker image as a docker container first time ###
    - [x] docker run -p 4000:3000 -d --name node-app node-app-image
        - 4000 is the port that is coming from outside of the container,  that is going to mapped to containers port 3000 
        - Generally we need to match this with the port value that express server is listening onto.
        - -d is run in detached mode (not In attached process inside terminal)
        - —name provides name for container followed by the docker image tag



### Running already created docker container ###
    - [x] docker container start cd0e7c0a6580
        - cd0e7c0a6580 is the container id




### Enter to the docker container terminal/bash shell ###
    - [x] docker exec -it node-app bash  


### Sync local folder with container volume (bind mount) ###
	This synchronizes the code  everytime we’ve written into the hosted container volume.
	
    - [x] docker run -p 4000:3000 -v localfolderPath:folderInDockerContainer:permission -d --name node-app node-app-image
        - [x] docker run -p 4000:3000 -v $(pwd):/app:ro -d --name node-app node-app-image
        - $(pwd) to get current working directory in case of mac, in our case /app is root directory on docker container and ro stands for read only permission so that we couldn’t accidentally create files inside docker container.
        - In case of docker-compose.yml file we don’t need to provide variable like $pwd, ./ will work.
        - [x] If we need to isolate node_modules inside container from being synced with local project node_modules
            - docker run -p 3000:3000 -v $(pwd):/app -v /app/node_modules -d --name node-app node-app-image



### Specifying ENVIRONMENT PORT while running docker container (this can override the PORT variable specified in our Dockerfile) ###
    - [x] docker run —env PORT=4000 -p 3000:4000 -v $(pwd):/app:ro -v /app/node_modules -d --name node-app node-app-image
    - Now even if you have set ENV PORT 3000 inside the Dockerfile, it get’s overridden with 4000
    - [x] But if you would like to specify .env file then
    - [ ] docker run —env-file ./.env -p 3000:4000 -v $(pwd):/app:ro -v /app/node_modules -d --name node-app node-app-image



# Docker Compose #

* Running docker-compose.yml file
    ``` docker-compose up -d ```
* Removing docker via docker-compose
    ``` docker-compose down ```
* Docker compose tool will try to find the previously built image, and doesn’t build a new image even if the docker file has been changed, therefore we might end up referencing stale image. We need to tell docker-compose specifically to rebuild with the following command:
    ``` docker-compose up -d —build ```
 
* Running docker-compose file with dev and prod env docker-compose file:
``` docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build ```

* Stopping docker container via docker-compose
``` docker-compose -f docker-compose.yml -f docker-compose.prod.yml down  ```

* Running specific docker-compose service without running their dependendant services
``` docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d --no-deps node-app ```
    (node-app is service name)

* when you've your container already up & running, and you want to rebuild the image; what going to happen is it's going to grab the old anonymous volumes and those anonymous volumes have got old deps and packages, but not the newly installed deps and packages, so we need to force docker to renew old anonymous volumes, two ways to solve this:
    * using -V which will insure the creation of brand new anonymous volumes
    ``` docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build -V ```
    * OR, simply down and up container
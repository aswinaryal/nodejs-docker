FROM node:15

WORKDIR /app 
# /app directory exists inside the node container, not from our app, not necessary to specify

COPY package.json .

# . means /app since we set /app as workdirectory

RUN npm install

ARG NODE_ENV
RUN if [ "$NODE_ENV" = "development" ]; \
        then npm install; \
        else npm install --only=production; \
        fi

# installs npm packages inside docker container

COPY . .
# copy every single files and folder within our current project directory into docker container

ENV PORT 3000
#setting a default port in docker container

EXPOSE $PORT 
#container gonna expose port 3000

CMD ["node", "index.js"]


# Dockerfile
# specify the builder ("builder" can be any tag)
FROM mcr.microsoft.com/windows/servercore:1803 as installer


# set working directory
WORKDIR /src

# install node and delete the install file
COPY "node-v12.4.0-win-x64.msi" node.msi
### Optionally, the installer could be downloaded as follows (not recommended)
# Invoke-WebRequest $('https://nodejs.org/dist/v{0}/node-v{0}-x64.msi' -f $env:NODE_VERSION) -OutFile 'node.msi'
RUN msiexec.exe /q /i node.msi
RUN del node.msi

# add `/app/node_modules/.bin` to $PATH
ENV PATH  /node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./
#COPY package-lock.json ./
RUN npm install 
#RUN npm install react-scripts@3.4.1 -g --silent

# add app
COPY . ./
EXPOSE 3000
# start app
CMD ["npm", "start"]
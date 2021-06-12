
# Dockerfile
# specify the builder ("builder" can be any tag)
FROM mcr.microsoft.com/windows/servercore:1803 as installer

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';$ProgressPreference='silentlyContinue';"]

RUN Invoke-WebRequest -OutFile nodejs.zip -UseBasicParsing "https://nodejs.org/dist/v12.4.0/node-v12.4.0-win-x64.zip"; `
Expand-Archive nodejs.zip -DestinationPath C:\; `
Rename-Item "C:\\node-v12.4.0-win-x64" c:\nodejs

FROM mcr.microsoft.com/windows/nanoserver:1803

WORKDIR C:\nodejs
COPY --from=installer C:\nodejs\ .
RUN SETX PATH C:\nodejs
RUN npm config set registry https://registry.npmjs.org/

# install node and delete the install file
COPY "node-v12.4.0-win-x64.msi" node.msi


### Optionally, the installer could be downloaded as follows (not recommended)
# Invoke-WebRequest $('https://nodejs.org/dist/v{0}/node-v{0}-x64.msi' -f $env:NODE_VERSION) -OutFile 'node.msi'
RUN msiexec.exe /q /i node.msi
RUN del node.msi

# set working directory

WORKDIR /src
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
# go-rest-api-kubernetes-example
A Sample Rest API application written in go, includes a helm chart for Kubernetes



# Usage

   
   `docker run -it -p 80:10101 --env-file ./app.env bucketland/go-rest-api-kubernetes-example:latest`. 80 is the host port and 10101 is the container port. So, open browser and go to 'localhost/youtube/channel/stats'

# Test
1. Configuration:

Go to google api library, enable 'YouTube Analytics API' and 'YouTube Data API v3'. Then back to credentials tab, create new api key, set API restrictions-Restrict Key，choose 'YouTube Analytics API' and 'YouTube Data API v3'. Finally, copy API key to 'main.go'.

Create an app.env file with content:
```
YOUTUBE_API_KEY=XXX
YOUTUBE_CHANNEL_ID=XXXX
```

Create a folder names ytapiconfig and create a file myValues.yaml in it. The content is:
```
youtubeStatsSettings:
  ytAPIKey: "XXX"
  ytChannelID: "XXX"

image:
  latest
```
2. test go server:
    ```
    go mod tidy
    go mod vendor
    go run .\app\.\...
    ```
    Since we have multiple files in .\app\, we need .\\... to run all the files. Then open browser and go to 'localhost:10101/youtube/channel/stats'

3. test docker:
   
    `docker build -t [imageName] .` to build image. The dot tells docker the docker file is in current folder.

    `docker run -it --name test -p 80:10101 --env-file ./app.env [imageName]` to run container.
 
4. test uploading image:
     Run `docker build -t bucketland/go-rest-api-kubernetes-example:latest .` to build image. Then use dockerhub desktop or run `docker push bucketland/go-rest-api-kubernetes-example:latest` to push. After pushing image to dockerhub, we are able to run it without any configuration.

# Helm:
Create a myValues.yaml file to store API key like:
```
youtubeStatsSettings:
  ytAPIKey: "XXX"
  ytChannelID: "XXX"
```
 Run `helm install youtube-stats -f [myValues.yaml] [youtube-stats-chart]` to install container.

 Run ` helm upgrade youtube-stats -f [myValues.yaml] [youtube-stats-chart]` to upgrade it when changes applied.

 Then go to powershell run `kubectl get all` and you are able to see all the resource you create.

# Reference:
https://github.com/askcloudarchitech/go-rest-api-kubernetes-example

https://www.youtube.com/playlist?list=PLSvCAHoiHC_qKVkVsiupTs9fCQBtNyeGz

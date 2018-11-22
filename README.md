Off the cob - aws edition
=============
This project is the millionth iteration of the image gallery that I've
built over and over to try to learn new technologies. This
iteration I'm exploring the aws serverless architecture.

As I was exploring the adobe creative cloud sdk, it found that there is
a way to receive events through webhooks about state that 
changes in the system. I'm interested in this because I use lightroom cc to 
manage my photography. Lightroom cc is a new offering from adobe that stores
images in their cloud service. Their tools are pretty great, syncing my photography
with my mobile devices.

# Architecture
This project is built with the following technologies:
* Java
* Kotlin
* React.js
* SQS (amazon message queues)
* Aws Lambda
* Hashicorp Terraform

![architecture](architecture.png)

The data flow of the system:
1. Adobe calls the lambda webhook
1. The webhook chunks the list of images into individual messages per image an puts them onto SQS
1. The image sync lambda fetches an image, puts it into s3, and adds metadata to dynamodb

The browser flow of the system:
1. Static site is loaded from s3 (html, js, css)
1. JS calls api gateway to fetch image metadata
1. Image fetcher looks up the image in dynamodb, and returns the s3 image location
1. Images are displayed in the browser

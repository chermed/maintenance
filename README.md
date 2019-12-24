# Overview

Docker image for websites in maintenance generate a maintenance page based on environment variables

# Environment variables with default data

Variable name | Description | Default value
----- | ------|----------
TITLE | The title in the head tag | Site Maintenance 
HEADER | Title in the body of the page (h1 tag) | We'll be back soon! 
BODY | Message to show in the page | Sorry for the inconvenience but we're performing some maintenance at the moment. If you need to you can always contact us, otherwise we'll be back online shortly! 
TEAM | Name of the team | The Team 
HTML | Replace all the HTML  | 

# Run an image

`docker run -d --name maintenance -p 80:5000 -e TEAM="DevOps Team" chermed/maintenance`







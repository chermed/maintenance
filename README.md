# Overview

Docker image for websites in maintenance generate a maintenance page based on environment variables

# Environment variables with default data

VARIABLE NAME | DEFAULT VALUE 
----- | ----------------
TITLE | Site Maintenance 
HEADER | We'll be back soon! 
BODY | Sorry for the inconvenience but we're performing some maintenance at the moment. If you need to you can always contact us, otherwise we'll be back online shortly! 
TEAM | The Team 

# Run an image

`docker run -d --name maintenance -p 80:5000 -e TEAM="DevOps Team" chermed/maintenance`







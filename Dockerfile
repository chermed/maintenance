FROM python:3-alpine3.10
LABEL maintainer="Mohamed Cherkaoui <chermed@gmail.com>"
LABEL type="Site Maintenance"
ENV TITLE="Site Maintenance" 
ENV TEAM="The Team" 
ENV HEADER="We'll be back soon!" 
ENV BODY="Sorry for the inconvenience but we're performing some maintenance at the moment. If you need to you can always contact us, otherwise we'll be back online shortly!" 
ENV FLASK_APP=/app/app.py
RUN pip3 install Flask==1.1.1
COPY ./app.py /app/
EXPOSE 5000
CMD ["flask", "run", "--host", "0.0.0.0"]
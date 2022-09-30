FROM debian:stretch-slim


RUN apt update \
    && apt install -y python3 \
    && mkdir /python_app \
    && touch /python_app/connection.log

COPY server.py /python_app
COPY client.py /python_app
COPY app.sh /python_app
RUN cd /python_app \
    && chmod +x *
CMD /python_app/app.sh


#CMD ["python3", "/python_app/server.py"]
#CMD ["python3", "/python_app/client.py"]


EXPOSE 9999


FROM python:3.9.16-bullseye

RUN apt update && \
    apt install -y libsndfile1 portaudio19-dev

WORKDIR /app
COPY streaming.py /app
COPY requirements.txt /app

RUN pip install -r requirements.txt

CMD [ "python", "./streaming.py"]

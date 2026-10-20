FROM python:3.9.16-bullseye

RUN apt update && \
    apt install -y libsndfile1 portaudio19-dev

WORKDIR /app
COPY streaming.py /app
COPY requirements.txt /app

RUN pip install -r requirements.txt

# root で動かさない（Trivy DS-0002）。パッケージの導入までは root で行い、実行だけ一般ユーザーにする
# マイクを使うため audio グループに入れる（--device /dev/snd で渡したデバイスを読めるように）
RUN useradd --create-home --uid 10001 --groups audio app
USER app

CMD [ "python", "./streaming.py"]

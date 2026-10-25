FROM python:3.12-bookworm

RUN apt-get update && \
    apt-get install -y --no-install-recommends libsndfile1 portaudio19-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY streaming.py /app
COPY requirements.txt /app

RUN pip install --no-cache-dir -r requirements.txt

# root で動かさない（Trivy DS-0002）。パッケージの導入までは root で行い、実行だけ一般ユーザーにする
# マイクを使うため audio グループに入れる（--device /dev/snd で渡したデバイスを読めるように）
RUN useradd --create-home --uid 10001 --groups audio app
USER app

CMD [ "python", "./streaming.py"]

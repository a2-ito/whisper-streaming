from io import BytesIO

import numpy as np
import soundfile as sf
import speech_recognition as sr
import whisper
import sys

device = 2

if __name__ == "__main__":
    #model = whisper.load_model("base")
    model = whisper.load_model("small")

    recognizer = sr.Recognizer()
    while True:
        with sr.Microphone(device_index=device, sample_rate=16_000) as source:
            sys.stdout.write("\r{}".format("waiting for your speech..."))
            sys.stdout.flush()
            audio = recognizer.listen(source)

        sys.stdout.write("\033[2K\033[G")
        sys.stdout.flush()
        sys.stdout.write("\r{}".format("..."))
        sys.stdout.flush()
        wav_bytes = audio.get_wav_data()
        wav_stream = BytesIO(wav_bytes)
        audio_array, sampling_rate = sf.read(wav_stream)
        audio_fp32 = audio_array.astype(np.float32)

        result = model.transcribe(audio_fp32, fp16=False)
        sys.stdout.write("\033[2K\033[G")
        sys.stdout.flush()
        sys.stdout.write("\r{}".format(result["text"]))
        sys.stdout.flush()
        print()


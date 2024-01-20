from fastapi import FastAPI
from schema import IrisCaptchaRequest, PassphraseRequest
from transcription import Transcriber
import uvicorn

from pathlib import Path


app = FastAPI()
transcriber = Transcriber()
transcription_captcha_completion_file = Path('./passphrase.log')
if not transcription_captcha_completion_file.exists():
    transcription_captcha_completion_file.touch()


@app.get('/')
def health():
    return 'Hello world'


@app.post('/iris')
def do_iris_captcha(req: IrisCaptchaRequest):
    return


@app.post('/passphrase')
def do_passphrase_captcha(req: PassphraseRequest):
    is_complete = transcriber.transcribe(req.passphrase)
    transcription_captcha_completion_file.write_text('1' if is_complete else '0')
    return is_complete


if __name__ == "__main__":
    config = uvicorn.Config("app:app", port=5000, log_level="info")
    server = uvicorn.Server(config)
    server.run()

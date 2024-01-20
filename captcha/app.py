from fastapi import FastAPI
from schema import IrisCaptchaRequest, PassphraseRequest, CaptchaResponse, PacketSizeResponse
from transcription import Transcriber
import uvicorn

from pathlib import Path

project_dir = Path.home() / 'har-codcaptcha'

app = FastAPI()
transcriber = Transcriber()
aggregate_file = project_dir / 'packet_aggregate.log'

if not aggregate_file.exists():
    aggregate_file.touch()
    aggregate_file.write_text('0')


@app.get('/')
def health():
    return 'Hello world'


@app.post('/iris')
def do_iris_captcha(req: IrisCaptchaRequest):
    return


@app.get('/network')
def get_packets_transferred():
    current_size_kB = int(aggregate_file.read_text())
    return PacketSizeResponse(current_size_kB)


@app.post('/stt')
def do_passphrase_captcha(req: PassphraseRequest):
    is_complete = transcriber.transcribe(req.text)
    return CaptchaResponse(is_complete)


if __name__ == "__main__":
    config = uvicorn.Config("app:app", port=5000, log_level="info")
    server = uvicorn.Server(config)
    server.run()

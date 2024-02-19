from fastapi import FastAPI
from schema import IrisCaptchaRequest, PassphraseRequest, CaptchaResponse, PacketSizeResponse
from eye import EyeCaptcha
from netstat import parse_network
import uvicorn

from pathlib import Path

project_dir = Path.home() / 'har-codcaptcha'

app = FastAPI()
aggregate_file = project_dir / 'packet_aggregate.log'

if not aggregate_file.exists():
    aggregate_file.touch()
    aggregate_file.write_text('0')


@app.get('/')
def health():
    return 'Hello world'


@app.get('/eye')
def do_eye_captcha():
    eye = EyeCaptcha()
    eye.detect()
    return CaptchaResponse(eye.succeeded)


@app.get('/network')
def get_packets_transferred():
    # Deprecated code :(
    # current_size_kB = int(aggregate_file.read_text())
    # return PacketSizeResponse(current_size_kB)

    # Sigma male code
    result = parse_network("./tmp/network.txt")
    return PacketSizeResponse(result)

if __name__ == "__main__":
    config = uvicorn.Config("app:app", port=5000, log_level="info")
    server = uvicorn.Server(config)
    server.run()

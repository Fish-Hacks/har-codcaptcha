from fastapi import FastAPI
from schema import IrisCaptchaRequest, PassphraseRequest
import uvicorn


app = FastAPI()


@app.get('/')
def health():
    return 'Hello world'


@app.post('/iris')
def do_iris_captcha(req: IrisCaptchaRequest):
    return


@app.post('/passphrase')
def do_passphrase_captcha(req: PassphraseRequest):
    return


if __name__ == "__main__":
    config = uvicorn.Config("app:app", port=5000, log_level="info")
    server = uvicorn.Server(config)
    server.run()

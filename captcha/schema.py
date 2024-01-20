from pydantic import BaseModel


class IrisCaptchaRequest(BaseModel):
    ...


class PassphraseRequest(BaseModel):
    passphrase: str

from pydantic import BaseModel


class IrisCaptchaRequest(BaseModel):
    ...


class PassphraseRequest(BaseModel):
    text: str


class CaptchaResponse(BaseModel):
    succeeded: bool


class PacketSizeResponse(BaseModel):
    size: int

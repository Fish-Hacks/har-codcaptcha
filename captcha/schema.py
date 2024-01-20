from pydantic import BaseModel
from dataclasses import dataclass

class IrisCaptchaRequest(BaseModel):
    ...


class PassphraseRequest(BaseModel):
    text: str


@dataclass
class CaptchaResponse:
    succeeded: bool


@dataclass
class PacketSizeResponse:
    size: int

import numpy as np
from time import time
from typing import Optional
from dataclasses import dataclass, field
from speech_recognition import Microphone, Recognizer, AudioData
from whisper import Whisper, load_model
import torch

from datetime import datetime, timedelta
from queue import Queue
from time import sleep


@dataclass
class Transcriber:
    # Setup fields
    phrase_time: Optional[int] = None
    data_queue: Queue = field(default_factory=Queue)
    recorder: Recognizer = field(default_factory=Recognizer)
    source: Microphone = field(default_factory=lambda: Microphone(sample_rate=16000))
    model: Whisper = field(default_factory=lambda: load_model('medium.en'))

    # Configs for recorder
    energy_threshold: int = 1000

    # Configs for transcription
    record_timeout: int = 2
    phrase_timeout: int = 3
    timeout: int = 120

    transcription: list[str] = field(default_factory=lambda:[''])

    def __post_init__(self):
        self.recorder.energy_threshold = self.energy_threshold
        # Dynamic energy compensation lowers the energy threshold
        # dramatically to a point where the SpeechRecognizer never stops recording.
        self.recorder.dynamic_energy_threshold = False
        print('Transcriber set up')

    def record_callback(self, _, audio: AudioData):
        """
        Threaded callback function to receive audio data when recordings finish.

        Args:
            audio (AudioData): An AudioData containing the recorded bytes.
        """
        # Grab the raw bytes and push it into the thread safe queue.
        data = audio.get_raw_data()
        self.data_queue.put(data)

    def transcribe(self, passphrase: str) -> bool:
        """
        Transcribe function, takes audio from microphone and transcribes
        infinitely in real-time until passphrase is said

        Args:
            passphrase (str): passphrase that needs to be spoken to end loop

        Returns:
            (bool): boolean indicating if passphrase was spoken within timeout limit
        """
        with self.source:
            self.recorder.adjust_for_ambient_noise(self.source)

        # Create a background thread that will pass us raw audio bytes.
        # We could do this manually but SpeechRecognizer provides a nice helper.
        self.recorder.listen_in_background(
            self.source,
            self.record_callback,
            phrase_time_limit=self.record_timeout
        )

        time_elapsed = 0

        while time_elapsed < self.timeout:
            try:
                start = time()
                now = datetime.utcnow()
                # Pull raw recorded audio from the queue.
                if self.data_queue.empty():
                    continue
                phrase_complete = False
                # If enough time has passed between recordings, consider the phrase complete.
                # Clear the current working audio buffer to start over with the new data.
                if self.phrase_time and now - self.phrase_time > timedelta(seconds=self.phrase_timeout):
                    phrase_complete = True
                # This is the last time we received new audio data from the queue.
                self.phrase_time = now

                # Combine audio data from queue
                audio_data = b''.join(self.data_queue.queue)
                self.data_queue.queue.clear()

                # Convert in-ram buffer to something the model can use directly without needing a temp file.
                # Convert data from 16-bit wide integers to floating point with a width of 32 bits.
                # Clamp the audio stream frequency to a PCM wavelength compatible default of 32768hz max.
                audio_np = np.frombuffer(audio_data, dtype=np.int16).astype(np.float32) / 32768.0

                # Read the transcription.
                result = self.model.transcribe(audio_np, fp16=torch.cuda.is_available())
                text = result['text'].strip().lower()

                # If the passphrase is spoken end transcription
                if phrase_complete and passphrase in text.lower():
                    break

                # Infinite loops are bad for processors, must sleep.
                sleep(0.25)
                time_elapsed += (time() - start)
            except KeyboardInterrupt:
                break

        return time_elapsed < self.timeout


if __name__ == "__main__":
    start = time()
    transcriber = Transcriber()
    end = time()
    print(f'Took {end-start}s to setup transcriber')
    start = time()
    is_complete = transcriber.transcribe('please stop')
    end = time()
    print(f"Transcription Captcha{'' if is_complete else ' not'} completed in {end - start}s")
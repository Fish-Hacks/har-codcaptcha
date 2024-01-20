conda create -n har python=3.9.18 -y
conda activate har

brew install portaudio # Dep of pyaudio
pip3 install -r requirements.txt
from pocketsphinx import AudioFile, get_model_path
import os

# Get the model path
model_path = get_model_path()

# Set up the AudioFile object
audio = AudioFile(
    audio_file='output.wav',  # Path to your audio file
    hmm=os.path.join(model_path, 'en-us'),  # Use the US English acoustic model
    lm=os.path.join(model_path, 'en-us.lm.bin'),  # Use the language model
    dic=os.path.join(model_path, 'cmudict-en-us.dict')  # Use the pronunciation dictionary
)

# Transcribe the audio file
for phrase in audio:
    print(f"Detected: '{phrase}'")
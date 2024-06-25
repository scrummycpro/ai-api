from gtts import gTTS
from pydub import AudioSegment
import sys
a = str(sys.argv[1])

def text_to_speech_to_wav(text, output_file):
    # Generate speech using gTTS
    tts = gTTS(text=text, lang='en')
    temp_file = "temp.mp3"
    tts.save(temp_file)

    # Convert the mp3 file to wav
    sound = AudioSegment.from_mp3(temp_file)
    sound.export(output_file, format="wav")

    print(f"Text-to-speech conversion saved to {output_file}")

# Text to be converted to speech
text = a 
output_file = "output.wav"

# Convert text to speech and save as WAV
text_to_speech_to_wav(text, output_file)
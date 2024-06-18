from gtts import gTTS
from pydub import AudioSegment

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
text = "Hello, this is a text-to-speech conversion using gTTS and pydub."
output_file = "output.wav"

# Convert text to speech and save as WAV
text_to_speech_to_wav(text, output_file)
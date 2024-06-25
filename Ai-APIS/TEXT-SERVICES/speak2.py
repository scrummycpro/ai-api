import sys
import argparse
from gtts import gTTS
from pydub import AudioSegment

def text_to_speech_to_wav(text, output_file, lang='en'):
    # Generate speech using gTTS
    tts = gTTS(text=text, lang=lang)
    temp_file = "temp.mp3"
    tts.save(temp_file)

    # Convert the mp3 file to wav
    sound = AudioSegment.from_mp3(temp_file)
    sound.export(output_file, format="wav")

    print(f"Text-to-speech conversion saved to {output_file}")

def main():
    parser = argparse.ArgumentParser(description="Convert text to speech and save as a WAV file.")
    parser.add_argument('-i', '--input', required=True, help="Path to the input text file.")
    parser.add_argument('-o', '--output', required=True, help="Path to the output WAV file.")
    parser.add_argument('-l', '--language', default='en', help="Language for the text-to-speech conversion (default: 'en').")

    args = parser.parse_args()
    input_file = args.input
    output_file = args.output
    language = args.language

    # Read the text from the input file
    with open(input_file, 'r') as file:
        text = file.read()

    # Convert text to speech and save as WAV
    text_to_speech_to_wav(text, output_file, language)

if __name__ == "__main__":
    main()
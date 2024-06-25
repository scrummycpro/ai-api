import speech_recognition as sr
import sqlite3
from datetime import datetime

def transcribe_audio():
    recognizer = sr.Recognizer()
    microphone = sr.Microphone()

    with microphone as source:
        print("Adjusting for ambient noise, please wait...")
        recognizer.adjust_for_ambient_noise(source)
        print("Listening for speech...")

        # Listen for speech and stop after 10 seconds of silence
        audio = recognizer.listen(source, phrase_time_limit=10)

    try:
        print("Transcribing audio...")
        text = recognizer.recognize_google(audio)
        print(f"Transcribed Text: {text}")
        save_to_database(text)
    except sr.RequestError:
        print("API was unreachable or unresponsive")
    except sr.UnknownValueError:
        print("Unable to recognize speech")

def save_to_database(text):
    conn = sqlite3.connect('transcriptions.db')
    cursor = conn.cursor()
    
    # Create table if it doesn't exist
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS transcriptions (
            id INTEGER PRIMARY KEY,
            text TEXT,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    # Insert the transcription with the current timestamp
    cursor.execute('''
        INSERT INTO transcriptions (text) VALUES (?)
    ''', (text,))
    
    conn.commit()
    conn.close()
    print("Transcription saved to database.")

if __name__ == "__main__":
    transcribe_audio()
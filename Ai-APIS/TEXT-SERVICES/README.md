Certainly! Below is the documentation for using the script with the supported languages and the example command format:

# Text-to-Speech Conversion Script Documentation

## Description

This script converts text from a specified text file into a speech audio file (WAV format) using Google's Text-to-Speech (gTTS) library. You can specify the input text file, the output audio file, and the language for the text-to-speech conversion.

## Usage

```sh
python3 speak2.py -i <input_text_file> -o <output_audio_file> -l <language_code>
```

- `-i` or `--input`: Path to the input text file.
- `-o` or `--output`: Path to the output WAV file.
- `-l` or `--language`: Language code for the text-to-speech conversion.

## Supported Languages and Their Codes

- `af`: Afrikaans
- `ar`: Arabic
- `bg`: Bulgarian
- `bn`: Bengali
- `bs`: Bosnian
- `ca`: Catalan
- `cs`: Czech
- `da`: Danish
- `de`: German
- `el`: Greek
- `en`: English
- `es`: Spanish
- `et`: Estonian
- `fi`: Finnish
- `fr`: French
- `gu`: Gujarati
- `hi`: Hindi
- `hr`: Croatian
- `hu`: Hungarian
- `id`: Indonesian
- `is`: Icelandic
- `it`: Italian
- `iw`: Hebrew
- `ja`: Japanese
- `jw`: Javanese
- `km`: Khmer
- `kn`: Kannada
- `ko`: Korean
- `la`: Latin
- `lv`: Latvian
- `ml`: Malayalam
- `mr`: Marathi
- `ms`: Malay
- `my`: Myanmar (Burmese)
- `ne`: Nepali
- `nl`: Dutch
- `no`: Norwegian
- `pl`: Polish
- `pt`: Portuguese
- `ro`: Romanian
- `ru`: Russian
- `si`: Sinhala
- `sk`: Slovak
- `sq`: Albanian
- `sr`: Serbian
- `su`: Sundanese
- `sv`: Swedish
- `sw`: Swahili
- `ta`: Tamil
- `te`: Telugu
- `th`: Thai
- `tl`: Filipino
- `tr`: Turkish
- `uk`: Ukrainian
- `ur`: Urdu
- `vi`: Vietnamese
- `zh-CN`: Chinese (Simplified)
- `zh-TW`: Chinese (Mandarin/Taiwan)
- `zh`: Chinese (Mandarin)

## Example Commands

1. Convert text to speech in Spanish:

```sh
python3 speak2.py -i test.txt -o test.wav -l es
```

2. Convert text to speech in Hebrew:

```sh
python3 speak2.py -i test.txt -o test.wav -l iw
```

3. Convert text to speech in Japanese:

```sh
python3 speak2.py -i test.txt -o test.wav -l ja
```

4. Convert text to speech in German:

```sh
python3 speak2.py -i test.txt -o test.wav -l de
```

Replace `<input_text_file>`, `<output_audio_file>`, and `<language_code>` with your specific file paths and desired language code from the supported languages list.
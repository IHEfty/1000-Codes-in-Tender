# Audio Test

The **Audio Test** project is part of the **1000+ Codes in Tender** collection. This project, written in the [**Tender**](https://github.com/2dprototype/tender), demonstrates how to play audio files using the audio capabilities of Tender.

## Overview

The **Audio Test** program allows you to play audio files, displaying the remaining playback time in seconds. The project initializes the audio system, loads an audio file, and plays it while tracking the duration.

## Running the Project

To run the Audio Test project, execute the `audio_test.td` script:

```bash
tender audio_test.td
```

This will play the specified audio file (`audio.mp3`) and print the remaining time in seconds to the terminal.

```bash
tender example.td
```

This will play the specified audio file (`myaudio.mp3`) without print the remaining time in seconds to the terminal.

### Customizing the Audio File

To play a different audio file, replace `"audio.mp3"` in the `play` function call with your desired audio file name. Ensure that your audio file is located in the same directory as the script.

Example modification:

```tender
play("your_audio_file.mp3")
```

## Project Structure

- **audio_test.td**: The main script that initializes the audio system, plays the audio file, and manages playback duration.
  
### Code Details

- **Imports**: The script imports the `audio`, `times`, and `fs` modules for audio playback, time management, and file system operations.
- **Function `play`**: This function takes the audio source as an argument, plays the audio, and prints the remaining playback time in seconds.
- **Main Execution**: The script calls the `play` function with the specified audio file.

## License

This project is open-source. Feel free to contribute or use it in your own projects.

## Explore More

The **Audio Test** project is one of many examples in the **1000+ Codes in Tender** repository. Feel free to explore and modify the code to enhance your understanding of audio playback in Tender!

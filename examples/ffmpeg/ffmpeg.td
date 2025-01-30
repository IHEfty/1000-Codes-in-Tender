import "os"

export {
    convert: fn(input_file, output_file) {
        return os.exec("ffmpeg", "-i", input_file, output_file)
    },

    extract_audio: fn(input_file, output_file) {
        return os.exec("ffmpeg", "-i", input_file, "-vn", "-acodec", "copy", output_file)
    },

    resize: fn(input_file, output_file, width, height) {
        return os.exec("ffmpeg", "-i", input_file, "-vf", "scale=" + width + ":" + height, output_file)
    },

    cut_video: fn(input_file, output_file, start_time, duration) {
        return os.exec("ffmpeg", "-i", input_file, "-ss", start_time, "-t", duration, output_file)
    },

    merge_audio_video: fn(video_file, audio_file, output_file) {
        return os.exec("ffmpeg", "-i", video_file, "-i", audio_file, "-c:v", "copy", "-c:a", "aac", "-strict", "experimental", output_file)
    },

    concat_videos: fn(input_files, output_file) {
        // Input should be a list of video files
        file_list = "file_list.txt"
        os.write(file_list, "")
        for f in input_files {
            os.append(file_list, "file '" + f + "'\n")
        }
        return os.exec("ffmpeg", "-f", "concat", "-safe", "0", "-i", file_list, "-c", "copy", output_file)
    },

    add_watermark: fn(input_file, output_file, watermark_image) {
        return os.exec("ffmpeg", "-i", input_file, "-i", watermark_image, "-filter_complex", "overlay=10:10", output_file)
    },

    convert_to_gif: fn(input_file, output_file) {
        return os.exec("ffmpeg", "-i", input_file, "-vf", "fps=10,scale=320:-1:flags=lanczos", "-c:v", "gif", output_file)
    },

    change_bitrate: fn(input_file, output_file, bitrate) {
        return os.exec("ffmpeg", "-i", input_file, "-b:v", bitrate, "-b:a", bitrate, output_file)
    },

    change_format: fn(input_file, output_file, format) {
        return os.exec("ffmpeg", "-i", input_file, "-f", format, output_file)
    },

    slow_down_video: fn(input_file, output_file, speed_factor) {
        return os.exec("ffmpeg", "-i", input_file, "-filter_complex", "[0]setpts=" + speed_factor + "*PTS", output_file)
    },

    speed_up_video: fn(input_file, output_file, speed_factor) {
        return os.exec("ffmpeg", "-i", input_file, "-filter_complex", "[0]setpts=" + (1 / speed_factor) + "*PTS", output_file)
    },

    extract_frames: fn(input_file, output_pattern) {
        return os.exec("ffmpeg", "-i", input_file, output_pattern)
    },

    video_to_audio: fn(input_file, output_file) {
        return os.exec("ffmpeg", "-i", input_file, "-vn", "-acodec", "mp3", output_file)
    },

    video_info: fn(input_file) {
        return os.exec("ffmpeg", "-i", input_file)
    },

    add_subtitles: fn(input_file, output_file, subtitle_file) {
        return os.exec("ffmpeg", "-i", input_file, "-i", subtitle_file, "-c:v", "copy", "-c:a", "copy", "-c:s", "srt", output_file)
    },

    trim_audio: fn(input_file, output_file, start_time, duration) {
        return os.exec("ffmpeg", "-i", input_file, "-ss", start_time, "-t", duration, "-c", "copy", output_file)
    },

    convert_audio_format: fn(input_file, output_file, format) {
        return os.exec("ffmpeg", "-i", input_file, output_file)
    },

    adjust_volume: fn(input_file, output_file, volume) {
        return os.exec("ffmpeg", "-i", input_file, "-filter:a", "volume=" + volume, output_file)
    }
}

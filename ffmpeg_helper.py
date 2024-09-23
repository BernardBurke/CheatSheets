import os
import ffmpeg
import argparse

arg_parser = argparse.ArgumentParser(description="Please provide a video file to extract audio from.") 

arg_parser.add_argument("filename", help="provide a video file")

arguments = arg_parser.parse_args()

probe = ffmpeg.probe(arguments.filename)
audio_stream = next((stream for stream in probe['streams'] if stream['codec_type'] == 'audio'), None)
audio_stream = 
output = audio_stream.output(acodec='copy','fred.aac')
ffmpeg.run(output)

# audio_stream = next((stream['codec_name'] for stream in probe['streams'] if stream['codec_type'] == 'audio'), None)
# print(audio_stream)
# input = ffmpeg.input(arguments.filename)
# audio = input.audio
# #audio = input.audio.acodec(audio_stream)
# output = ffmpeg.output(audio,'fred.aac')


#print(audio_stream["codec_name"])

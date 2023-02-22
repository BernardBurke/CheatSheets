import os
import ffmpeg
import argparse

arg_parser = argparse.ArgumentParser(description="Please provide a video file to extract audio from.") 

arg_parser.add_argument("filename", help="provide a video file")

arguments = arg_parser.parse_args()

probe = ffmpeg.probe(args.filename)
audio_stream = next((stream for stream in probe['streams'] if stream['codec_type'] == 'audio'), None)

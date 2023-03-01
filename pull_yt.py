import os
import tempfile
from pytube import YouTube
import yt_dlp
import ffmpeg
import argparse
import time

f_filename = "HelloWorld.mp4"

def yt_dlp_monitor(d):
    #print(d)
    global f_filename
    if d['status'] == 'finished':
        f_filename = d.get('info_dict').get('_filename')
        print("Unhooked")
        print(f' {f_filename} completed all the THINGS')
        print("Unhooked")
        # probe = ffmpeg.probe(f_filename)
        # audio_stream = next((stream for stream in probe['streams'] if stream['codec_type'] == 'audio'), None)
        # print(audio_stream)
  
arg_parser = argparse.ArgumentParser(description="Please provide a youtube or rumble url")

arg_parser.add_argument("url", help="youtube or rumble url")
arg_parser.add_argument( "itag", default=251, nargs='?')

output_file = tempfile.NamedTemporaryFile(delete=True)
output_file = '%(title)s.%(ext)s'

arguments = arg_parser.parse_args()

def get_via_yt_dlp(url):
    print(url)
    #ytdl_opts = {'output': tempfile.gettempdir()}
    ytdl_opts = {
                'format': 'wv*',
                'restrictfilenames': True,
                'print': True,
                'output': output_file,
                'progress_hooks': [yt_dlp_monitor]
    }

    with yt_dlp.YoutubeDL(ytdl_opts) as ytdl:
        ytdl.download([url])

    print(f'Downloaded to {f_filename}')

def get_via_pytube(url, itag):
    print(url)
    yt = YouTube(url)
    yt.streams.filter(only_audio=True)
    temp_output = yt.streams.output_path = tempfile.gettempdir()
    stream = yt.streams.get_by_itag(itag)
    stream.download()
    print(f'Downloaded {stream.title}')


if arguments.itag is not None:
	itag = arguments.itag
else:
    itag = "251"

print(f'itag: {itag}')

fp = tempfile.TemporaryFile()

tic = time.perf_counter()

if "rumble" in arguments.url:
    print("rumble")
    get_via_yt_dlp(arguments.url)
else:
    print("getting from youtube")
    get_via_pytube(arguments.url, itag)

# exit()


toc = time.perf_counter()

print(f'took {toc - tic:0.4f} seconds')

print(f'{f_filename} was downloaded')
probe = ffmpeg.probe(f_filename)
audio_stream = next((stream['codec_name'] for stream in probe['streams'] if stream['codec_type'] == 'audio'), None)
print(audio_stream)
input = ffmpeg.input(f_filename)
audio = input.audio.acodec(audio_stream)
output = ffmpeg.output(audio,'fred.aac')

# we'll make this smarter eventually with itags that might very from 22


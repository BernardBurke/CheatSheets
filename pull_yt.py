import os
import tempfile
from pytube import YouTube
import yt_dlp
import ffmpeg
import argparse
import time

arg_parser = argparse.ArgumentParser(description="Please provide a youtube or rumble url")

arg_parser.add_argument("url", help="youtube or rumble url")
arg_parser.add_argument( "itag", default=251, nargs='?')


arguments = arg_parser.parse_args()

def get_via_yt_dlp(url):
    print(url)
    #ytdl_opts = {'output': tempfile.gettempdir()}
    ytdl_opts = {
                'format': 'm4a/bestaudio/best',
                'postprocessors': [{
                    'key': 'FFmpegExtractAudio',
                    'preferredcodec': 'mp3',
                }]
    }

    with yt_dlp.YoutubeDL(ytdl_opts) as ytdl:
        ytdl.download([url])
        #print(f'{ytdl.entries[0].title} downloaded to {tempfile.gettempdir()}')


def get_via_pytube(url, itag):
    print(url)
    yt = YouTube(url)
    yt.streams.filter(only_audio=True)
    temp_output = yt.streams.output_path = tempfile.gettempdir()
    stream = yt.streams.get_by_itag(itag)
    fp = tempfile.TemporaryFile()
    stream.download(fp)
    print(f'Downloaded {stream.title} to {fp}')


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

toc = time.perf_counter()

print(f'took {toc - tic:0.4f} seconds')

# we'll make this smarter eventually with itags that might very from 22


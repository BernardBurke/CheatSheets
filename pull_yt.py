import os
import tempfile
from pytube import YouTube
import yt_dlp
import ffmpeg
import argparse

arg_parser = argparse.ArgumentParser(description="Please provide a youtube or rumble url")

arg_parser.add_argument("url", help="youtube or rumble url")
arg_parser.add_argument( "itag", default=251, nargs='?')


arguments = arg_parser.parse_args()

def get_via_yt_dlp(url):
    print(url)
    ytdl_opts = {'output': tempfile.gettempdir()}
    with yt_dlp.YoutubeDL(ytdl_opts) as ytdl:
        ytdl.download([url])
        print(f'{ytdl.entries[0].title} downloaded to {tempfile.gettempdir()}')


def get_via_pytube(url, itag):
    print(url)
    yt = YouTube(url)
    yt.streams.filter(only_audio=True)
    temp_output = yt.streams.output_path = tempfile.gettempdir()
    stream = yt.streams.get_by_itag(itag)
    stream.download(temp_output)
    print(f'Downloaded {stream.title} to {temp_output}')


if arguments.itag is not None:
	itag = arguments.itag
else:
    itag = "251"

print(f'itag: {itag}')

fp = tempfile.TemporaryFile()



if "rumble" in arguments.url:
    print("rumble")
else:
    print("getting from youtube")
    get_via_pytube(arguments.url, itag)



# we'll make this smarter eventually with itags that might very from 22


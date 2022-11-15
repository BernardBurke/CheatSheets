# Get a bunch of audio files from yt

## Playlist attributes

Group your videos into a playlist. I have found it much easier if I make them Public or Unlisted...

Public or Unlisted playlists will give you a different URL that can be manipulated my pytube Playlists

If you don't have pytube, get a functional python pip environment and..

```
pip install pytube
```

## Playlist method in pytube

The cli doesn't have many of the capabilities of the pytube module.

With a bit of practice, you'll find that yt videos seem to *always* have a .webm audio stream, which 
pretty much any media player can play.

```

$ python
>>> p = Playlist('https://youtube.com/playlist?list=PLM2c33JYBIOSaIzexOojd5u1otmTn__or')
>>> for v in p.videos:
...     stream = v.streams.get_by_itag(251)
...     stream.download()
.
.

```
This method does not log each successful download (ToDo)


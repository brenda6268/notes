# converting mp4 to gif

<!--
ID: b6ad38b9-1eef-4cf8-85a6-e709ba913be6
Status: publish
Date: 2017-05-30T01:40:00
Modified: 2017-05-30T01:40:00
wp_id: 428
-->

## Converting MP4 to gif

To convert the entire video to GIF, use the following command:

`ffmpeg -i small.mp4 small.gif`

To convert just a portion of a video clip to GIF, use the following command:

`ffmpeg -t 3 -ss 00:00:02 -i small.webm small-clip.gif`

The snippet above directs ffmpeg to create a GIF 3 seconds long starting at 2 seconds into the video.
The default conversion doesn't appear to be high quality, so you can configure the bitrate via another parameter:

`ffmpeg -i small.mp4 -b 2048k small.gif`

## Convert GIF to Video

The command is quite simple:

`ffmpeg -f gif -i animation.gif animation.mp4`

You can use this same command format to convert to other video formats:

```
ffmpeg -f gif -i animation.gif animation.mpeg
ffmpeg -f gif -i animation.gif animation.webm
```

ffmpeg and ImageMagick are awesome media utilities which you should take some time to check out if you have any questions about how to get something done!

## optimize

gifsicle to scale down the image to a smaller size

I used `ffmpeg -i foo.mp4 -r 5 -vf scale=270:-1 foo.gif` , where -r 5 cuts it to 5 frames per second, and `-vf scale=270:-1` scales the output to a width of 270 pixels and a height that matches the aspect ratio.
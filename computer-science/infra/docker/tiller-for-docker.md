# tiller for docker


ID: 516
Status: publish
Date: 2018-01-17 20:00:00
Modified: 2018-01-17 20:00:00


# Yifei's Notes

Tiller SUCKS

The only good part of tiller is that it makes a docker image can read environment variables and generate config files based on predefined templates, this functionality should easily be achieved by python and jinja2


# Tiller

tiller runs program such as nginx inside docker instead of bare-bone nginx. tiller dynamically generates config files for different environment such as dev and QA.

tiller is only useful because **your program reads config files only** instead of environment variables

you define variables and pass the variables to tiller, tiller generate config files and the start corresponding program.

Before: Docker -> nginx
After: Docker -> tiller -> nginx

you copy the config file template when building image
and run the container with you env vars

# Downsides

We have to pre-define several environments in the image, then we choose which to use when starting the container.
It's fine to use if we have limited envs, but what if we want to change the environment, we have to repack the image
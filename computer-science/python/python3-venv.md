# python3 venv

<!--
ID: ca83e7ea-cf2e-42d9-9001-f86d377c70f9
Status: publish
Date: 2017-05-30T03:52:00
Modified: 2017-05-30T03:52:00
wp_id: 670
-->

# Yifei's Notes

## traps

venv puts the current directory's name in its source code generated, so after renaming your directory, you will have to rename the `activate` file and the `pip` file.

# venv

In Python 3, there comes a virtual environment shipped with the standard lib called `venv`.

to create a new venv, you can simply call:
    
    python3 -m venv <venv-name>
    virtualenv VENV_NAME  # for python 2
        --system-site-pakcages to bring system packages

to activate the venv, you need source the generated shell script

    source <venv-name>/bin/activate

Note: the generated activate script contains directory infomation based on your local computer and projects, so it's NOT portable.

to deactivate it:
    
    deactivate

But, in most times, we don't really care about the name of the virtual env, so let's simply call it `.venv`, and you can add the following to your `.bashrc` for convinence

    DEFAULT_VENV_NAME=".venv"
    alias create-venv="python3 -m venv $DEFAULT_VENV_NAME"
    alias activate="source $DEFAULT_VENV_NAME/bin/activate"

after you activated you venv, there would be a prompt before your shell prompt. You can see that `python3` and `pip3` is set to the venv copy of python3 by running:

    which python3 # -> .venv/bin/python3

if you run `pip install`, the packages will be install in your local venv directory, so no sudo needed!

since the venv directory is not portable, the best practice would be save your dependencies is your `requirements.txt` file.
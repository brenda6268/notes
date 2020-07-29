# YAML 语言和 Python 中的使用

<!--
ID: 08ad4f23-fdd5-4191-a971-e93b7f14c2be
Status: publish
Date: 2017-05-29T15:20:00
Modified: 2020-05-16T12:09:48
wp_id: 630
-->

## Install

    pip install pyyaml

## Basic Example

    import yaml
    result = yaml.load(yaml_string) # to python list or dict
    string = yaml.dump(py_object)
    # NOTE: unlike the json module, the method here is load/dump, not loads/dumps

## Yaml

YAML uses three dashes (“---”) to separate documents within a stream. Three dots ( “...”) indicate the end of a document without starting a new one, for use in communication channels.

empty string in yaml is '' or "", if you have a blank entry, it will be converted to None
you don't need to quote strings in yaml


for dumping, when dumping to a file, do this

with open('file.yml', 'w') as f:
    yaml.dump(data, f, default_flow_style=False, allow_unicode=True)
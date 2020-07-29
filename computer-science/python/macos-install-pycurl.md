# macOS 中如何正确安装 pycurl

<!--
ID: b3607308-1deb-4d58-950b-f2b993413987
Status: publish
Date: 2019-10-09T21:27:07
Modified: 2020-05-16T10:50:25
wp_id: 742
-->

Reinstall the curl libraries

    brew install curl --with-openssl

Install pycurl with correct environment and paths

    export PYCURL_SSL_LIBRARY=openssl
    pip uninstall pycurl 
    pip install --no-cache-dir --global-option=build_ext --global-option="-L/usr/local/opt/openssl/lib" --global-option="-I/usr/local/opt/openssl/include"  pycurl
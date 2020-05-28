# macOS 中如何正确安装 pycurl


wp_id: 742
Status: publish
Date: 2019-10-09 21:27:07
Modified: 2020-05-16 10:50:25


Reinstall the curl libraries

    brew install curl --with-openssl

Install pycurl with correct environment and paths

    export PYCURL_SSL_LIBRARY=openssl
    pip uninstall pycurl 
    pip install --no-cache-dir --global-option=build_ext --global-option="-L/usr/local/opt/openssl/lib" --global-option="-I/usr/local/opt/openssl/include"  pycurl
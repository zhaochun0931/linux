# install the openssl from the source code 
apt update
apt install gcc make -y
apt-get install -y --no-install-recommends \
		build-essential \
		ca-certificates \
		gnupg \
		libncurses5-dev \
		wget



wget https://www.openssl.org/source/openssl-3.0.11.tar.gz

tar zxvf openssl-3.0.1.tar.gz

cd openssl-3.0.11

./config

make

make install

ldconfig /usr/local/lib64/

openssl version







ldconfig -p

ldconfig -v


sudo ln -s /usr/lib/x86_64-linux-gnu/libssl3.so /usr/lib/x86_64-linux-gnu/libssl.so.3




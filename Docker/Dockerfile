FROM raspbian/stretch

RUN apt-get update -y -q && apt-get upgrade -y -q
RUN apt install -y -q multiarch-support libavformat57 git libportaudio2* libflac++6v5* libavahi-common3 libavahi-client3 alsa-utils curl

#libcurl3 -y 
RUN mkdir -p /app/ifi-tidal-release
WORKDIR /app/ifi-tidal-release

RUN curl -k -O -L http://archive.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u12_armhf.deb
RUN apt install -y ./libssl1.0.0_1.0.1t-1+deb8u12_armhf.deb
RUN rm ./libssl1.0.0_1.0.1t-1+deb8u12_armhf.deb 

RUN curl -k -O -L http://archive.debian.org/debian-security/pool/updates/main/c/curl/libcurl3_7.38.0-4+deb8u16_armhf.deb
RUN apt install -y ./libcurl3_7.38.0-4+deb8u16_armhf.deb --allow-downgrades
RUN rm ./libcurl3_7.38.0-4+deb8u16_armhf.deb
RUN apt install -y -q tmux

COPY Docker/src/bin/ bin
COPY Docker/src/pa_devs/ .
COPY Docker/src/play .
COPY Docker/src/id_certificate id_certificate
COPY Docker/src/licenses licenses
RUN chmod a+x bin/* 

COPY Docker/entrypoint.sh /
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]


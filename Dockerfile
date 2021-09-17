FROM ubuntu

RUN apt update && apt upgrade -y && DEBIAN_FRONTEND="noninteractive" apt install -y \
    locales \
    openjdk-11-jdk \
    maven \
    git \
    iceweasel \
    xvfb

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV DISPLAY=:99
ENV WEBDRIVER_GECKO_DRIVER=/usr/local/bin/geckodriver
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

COPY geckodriver /usr/local/bin/geckodriver

RUN mkdir -p /work
WORKDIR /work

CMD ["bash", "-c", "echo 'Java:' ; java --version ; echo ; echo 'Maven:' ; mvn -version ; echo ; echo 'Git:' ; git --version ; echo ; echo 'Firefox:' ; firefox --version"]

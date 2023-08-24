FROM debian

RUN apt update && apt upgrade -y && DEBIAN_FRONTEND="noninteractive" apt install -y \
    software-properties-common \
    locales \
    openjdk-17-jdk \
    maven \
    git \
    npm \
    firefox-esr \
    xvfb \
    gnupg2 \
    curl \
    jq \
    unzip

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN npm install npm@latest -g && \
    npm install n -g && \
    n latest

# install gradle
RUN curl -O https://downloads.gradle.org/distributions/gradle-8.3-bin.zip && \
    unzip gradle-8.3-bin.zip && \
    rm gradle-8.3-bin.zip && \
    mv gradle-8.3 /usr/local/bin/

ENV PATH="$PATH:/usr/local/bin/gradle-8.3/bin"

ENV DISPLAY=:99
ENV WEBDRIVER_GECKO_DRIVER=/usr/local/bin/geckodriver
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

COPY geckodriver /usr/local/bin/geckodriver
COPY wait-for-service.sh /usr/local/bin/wait-for-service.sh

RUN mkdir -p /work
WORKDIR /work

CMD ["bash", "-c", "echo 'Java:' ; java --version ; echo ; echo 'Maven:' ; mvn -version ; echo ; echo 'Git:' ; git --version ; echo ; echo 'Firefox:' ; firefox --version"]

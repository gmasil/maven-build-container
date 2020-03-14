FROM debian

RUN apt update && apt upgrade -y && apt install -y \
	default-jdk \
	maven \
	iceweasel \
	xvfb

ENV DISPLAY=:99
ENV WEBDRIVER_GECKO_DRIVER=/usr/local/bin/geckodriver
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

COPY start-display /usr/local/bin/start-display
COPY geckodriver /usr/local/bin/geckodriver

RUN mkdir -p /work
WORKDIR /work

CMD ["bash", "-c", "echo 'Java:' ; java --version ; echo ; echo 'Maven:' ; mvn -version"]

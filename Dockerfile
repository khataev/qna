FROM ruby:2.3.0
MAINTAINER khataev@yandex.ru

RUN apt-get update -y && apt-get install -y \
    locales \
    build-essential \
    libpq-dev \
    nodejs \
#    #webkit packages
#    libqtwebkit-dev \
#    gstreamer1.0-plugins-base \
#    gstreamer1.0-tools \
#    gstreamer1.0-x \
#    xvfb \
#
#    # firefox in xvfb
#    libxcomposite1 \
#    libdbus-glib-1-dev \
#    libgtk2.0-0 \
#    libgtk-3-0 \

    # phantomjs packages
    chrpath \
    libssl-dev \
    libxft-dev \
    libfreetype6 \
    libfreetype6-dev \
    libfontconfig1 \
    libfontconfig1-dev \
    vim \
    nano \

    # mysql
    libmysqlclient-dev

# Set the timezone.
RUN echo "Europe/Moscow" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV PHANTOM_JS=phantomjs-2.1.1-linux-x86_64

# phantomjs installation
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2
RUN tar xvjf $PHANTOM_JS.tar.bz2
RUN mv $PHANTOM_JS /usr/local/share
RUN ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin

## Firefox 47 installation
## RUN wget https://ftp.mozilla.org/pub/firefox/releases/47.0/linux-x86_64/en-US/firefox-47.0.tar.bz2
#RUN wget https://ftp.mozilla.org/pub/firefox/releases/45.0/linux-x86_64/en-US/firefox-45.0.tar.bz2
#RUN tar -xjf firefox-45.0.tar.bz2
#RUN mv firefox /usr/bin/firefox-47

RUN mkdir -p /home/code/qna
WORKDIR /home/code/qna
COPY .pryrc ~/.pryrc

#COPY Gemfile.docker ./Gemfile # only for webkit
COPY Gemfile ./Gemfile
COPY Gemfile.lock ./

RUN bundle install --without "development production"

COPY . /home/code/qna
COPY config/database.yml.docker ./config/database.yml

# container build indifferent environment variables
ENV RSPEC_WEBDRIVER=poltergeist
ENV RAILS_ENV=test
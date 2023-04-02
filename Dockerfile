FROM ruby:3.2.1
RUN apt-get update && apt-get install -y build-essential imagemagick libvips ffmpeg
RUN gem i -v 7.0.4.2 rails
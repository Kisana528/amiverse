FROM ruby:3.2.2
RUN apt-get update && apt-get install -y build-essential imagemagick libvips ffmpeg
RUN gem i -v 7.0.7 rails
FROM ruby:3.2.1
RUN apt-get update && apt-get install -y build-essential
RUN gem i -v 7.0.4.2 rails
# apt install -y libvips
# ↓アプリ作成後
#COPY ./src /app
#WORKDIR /app
#RUN bundle install
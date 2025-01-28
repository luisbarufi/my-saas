FROM ruby:3.0.0

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  npm

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn@1.22.19


WORKDIR /my-saas

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]

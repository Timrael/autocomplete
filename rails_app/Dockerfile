FROM ruby:2.5.1
MAINTAINER "timrael" <timraell@gmail.com>

RUN git clone https://github.com/dbro/csvquote.git
WORKDIR csvquote
RUN make && make install

RUN apt-get update && apt-get install -y apt-transport-https \
  && apt-get install -y --no-install-recommends postgresql-client \
  && apt-get install unzip \
  && rm -rf /var/lib/apt/lists/* \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
  && apt-get update && apt-get install -y nodejs yarn

WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock /usr/src/app/
RUN bundle install

COPY package.json /usr/src/app/
RUN yarn install

COPY . /usr/src/app

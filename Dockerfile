FROM ruby:3.1.2

# Set env variables
ARG RAILS_ENV
ENV RAILS_ENV $RAILS_ENV

ARG RACK_ENV
ENV RACK_ENV $RACK_ENV

ARG RAILS_SERVE_STATIC_FILES
ENV RAILS_SERVE_STATIC_FILES $RAILS_SERVE_STATIC_FILES

ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE $SECRET_KEY_BASE

ARG DATABASE_HOST
ENV DATABASE_HOST $DATABASE_HOST

ARG DATABASE_NAME
ENV DATABASE_NAME $DATABASE_NAME

ARG DATABASE_PASSWORD
ENV DATABASE_PASSWORD $DATABASE_PASSWORD

ARG DATABASE_PORT
ENV DATABASE_PORT $DATABASE_PORT

ARG DATABASE_USERNAME
ENV DATABASE_USERNAME $DATABASE_USERNAME

ARG API_ADDRESS
ENV API_ADDRESS $API_ADDRESS

ARG CONSUMER_KEY
ENV CONSUMER_KEY $CONSUMER_KEY

ARG CONSUMER_SECRET
ENV CONSUMER_SECRET $CONSUMER_SECRET

ARG CODE
ENV CODE $CODE

ARG LOGIN_URL_SNK
ENV LOGIN_URL_SNK $LOGIN_URL_SNK

ARG VIEW_URL_SNK
ENV VIEW_URL_SNK $VIEW_URL_SNK

ARG URL_API_SNK
ENV URL_API_SNK $URL_API_SNK

ARG URL_API_SNK_POST
ENV URL_API_SNK_POST $URL_API_SNK_POST

ARG URL_SNK_ORDER_POST
ENV URL_SNK_ORDER_POST $URL_SNK_ORDER_POST

ARG NOMUSU
ENV NOMUSU $NOMUSU

ARG INTERNO
ENV INTERNO $INTERNO

ARG CODTIPOPER
ENV CODTIPOPER $CODTIPOPER

ARG CODTIPVENDA
ENV CODTIPVENDA $CODTIPVENDA

ARG CODVEND
ENV CODVEND $CODVEND

ARG CODEMP
ENV CODEMP $CODEMP

ARG TIPMOV
ENV TIPMOV $TIPMOV

ARG CODNAT
ENV CODNAT $CODNAT

ARG CODPARCTRANSP
ENV CODPARCTRANSP $CODPARCTRANSP

ARG CODLOCALORIG
ENV CODLOCALORIG $CODLOCALORIG

ARG CODCENCUS
ENV CODCENCUS $CODCENCUS

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential curl apt-utils libpq-dev

# Set an environment variable where the Rails app is installed to inside of Docker image:
ENV RAILS_ROOT /app
RUN mkdir -p $RAILS_ROOT

# Set working directory, where the commands will be ran:
WORKDIR $RAILS_ROOT

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN gem install bundler:2.3.7
RUN bundle install

# Adding project files
COPY . .

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

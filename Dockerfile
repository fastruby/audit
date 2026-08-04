# syntax=docker/dockerfile:1
FROM ruby:4.0.4

RUN dpkg --add-architecture i386 \
  && apt-get update -qq \
  && apt-get install -y --no-install-recommends \
    libpq-dev \
    postgresql-client \
    imagemagick \
    fontconfig \
    libxrender1 \
    libxext6 \
    xfonts-75dpi \
    xfonts-base \
    libc6:i386 \
    libstdc++6:i386 \
    chromium \
    chromium-driver \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ARG BUNDLE_GEMFILE=/app/Gemfile

ENV BUNDLE_GEMFILE=${BUNDLE_GEMFILE} \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

COPY Gemfile Gemfile.lock Gemfile.next Gemfile.next.lock .ruby-version ./
RUN --mount=type=cache,target=/usr/local/bundle/cache,sharing=locked \
  bundle install

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

FROM ruby:3.2.11

RUN dpkg --add-architecture i386 \
  && apt-get update -qq \
  && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    postgresql-client \
    imagemagick \
    fontconfig \
    libxrender1 \
    libxext6 \
    xfonts-75dpi \
    xfonts-base \
    nodejs \
    libc6:i386 \
    libstdc++6:i386 \
  && rm -rf /var/lib/apt/lists/*

RUN gem install bundler -v 2.2.21

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle _2.2.21_ install --jobs=4 --retry=3

# Dual-boot: Gemfile.next targets the Rails version we're upgrading to.
# Remove this block (and Gemfile.next / Gemfile.next.lock) once the upgrade lands.
COPY Gemfile.next Gemfile.next.lock ./
RUN BUNDLE_GEMFILE=Gemfile.next bundle _2.2.21_ install --jobs=4 --retry=3

COPY . .

COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

FROM ruby:2.7.2

# Debian buster is EOL; its repos moved to archive.debian.org.
RUN sed -i 's|deb.debian.org|archive.debian.org|g; s|security.debian.org|archive.debian.org|g' /etc/apt/sources.list \
  && echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until

RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends \
    build-essential \
    patch \
    autoconf \
    pkg-config \
    libpq-dev \
    postgresql-client \
    imagemagick \
    fontconfig \
    libxrender1 \
    libxext6 \
    libjpeg62-turbo \
    xfonts-75dpi \
    xfonts-base \
  && rm -rf /var/lib/apt/lists/*

# Node 12 matches .nvmrc; used by the asset pipeline (sprockets/coffee/sass).
# Installed from the official tarball since NodeSource dropped its Node 12 setup script.
ENV NODE_VERSION=12.13.0
RUN ARCH="$(dpkg --print-architecture)" \
  && case "$ARCH" in \
       amd64) NODE_ARCH=x64 ;; \
       arm64) NODE_ARCH=arm64 ;; \
       *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
     esac \
  && curl -fsSLO "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${NODE_ARCH}.tar.xz" \
  && tar -xJf "node-v${NODE_VERSION}-linux-${NODE_ARCH}.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v${NODE_VERSION}-linux-${NODE_ARCH}.tar.xz"

RUN gem install bundler -v 2.2.21

# Debian buster's glibc (2.28) is too old for nokogiri's precompiled native gem;
# build it from source instead.
RUN bundle config set --global force_ruby_platform true

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

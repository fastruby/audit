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

COPY Gemfile Gemfile.lock .ruby-version ./
RUN --mount=type=cache,target=/usr/local/bundle/cache,sharing=locked \
  bundle install

# Dual-boot: Gemfile.next targets the Rails version we're upgrading to.
# Remove this block (and Gemfile.next / Gemfile.next.lock) once the upgrade lands.
COPY Gemfile.next Gemfile.next.lock ./
RUN --mount=type=cache,target=/usr/local/bundle/cache,sharing=locked \
  BUNDLE_GEMFILE=/app/Gemfile.next bundle install

COPY --chmod=0755 docker/entrypoint.sh /usr/local/bin/entrypoint.sh

COPY . .

EXPOSE 3000

HEALTHCHECK --interval=10s --timeout=3s --start-period=60s --retries=6 \
  CMD curl -fsS http://localhost:3000/up || exit 1

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

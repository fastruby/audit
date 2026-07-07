%w[
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
].each { |path| Spring.watch(path) }

# Test env intentionally runs with config.enable_reloading = false for
# performance/correctness; Spring's reloader requirement doesn't apply
# there since a single spring-preloaded process doesn't need to reload
# code mid-suite.
Spring.dangerously_allow_disabling_reloading = true

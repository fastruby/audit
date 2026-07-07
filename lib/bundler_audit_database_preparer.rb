require "bundler/audit/database"

# Clones or updates the local ruby-advisory-db checkout that
# Bundler::Audit::Scanner needs. Failures are logged instead of raised so a
# transient clone/update problem never takes down app boot -- but they must
# be logged, not swallowed, or every later scan fails with an opaque
# ArgumentError ("... is not a directory") and no trace of why.
module BundlerAuditDatabasePreparer
  def self.call(path: Bundler::Audit::Database.path, logger: Rails.logger)
    begin
      if File.directory?(path)
        Bundler::Audit::Database.new(path).update!(quiet: true)
      else
        Bundler::Audit::Database.download(path: path, quiet: true)
      end
    rescue Bundler::Audit::Database::DownloadFailed, Bundler::Audit::Database::UpdateFailed => error
      logger.error("[bundler-audit] Could not prepare ruby-advisory-db at #{path}: #{error.class}: #{error.message}")
    end

    log_if_still_missing(path, logger)
  end

  def self.log_if_still_missing(path, logger)
    return if File.directory?(path)

    logger.error("[bundler-audit] ruby-advisory-db is still missing at #{path} after initializer ran; audits will 500 until this is fixed")
  end
  private_class_method :log_if_still_missing
end

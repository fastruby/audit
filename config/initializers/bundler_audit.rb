require "bundler/audit/database"

path = Bundler::Audit::Database.path

begin
  if File.directory?(path)
    Bundler::Audit::Database.new(path).update!(quiet: true)
  else
    Bundler::Audit::Database.download(path: path, quiet: true)
  end
rescue Bundler::Audit::Database::DownloadFailed, Bundler::Audit::Database::UpdateFailed => e
  Rails.logger.error("[bundler-audit] Could not prepare ruby-advisory-db at #{path}: #{e.class}: #{e.message}")
end

unless File.directory?(path)
  Rails.logger.error("[bundler-audit] ruby-advisory-db is still missing at #{path} after initializer ran; audits will 500 until this is fixed")
end

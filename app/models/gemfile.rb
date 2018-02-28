require "bundler/audit/scanner"

class Gemfile < ApplicationRecord
  has_attached_file :file
  # Validate content type
  validates_attachment_content_type :file, content_type: /\Atext/

  # Validate filename
  validates_attachment_file_name :file, matches: [/lock\Z/]

  # Explicitly do not validate
  # do_not_validate_attachment_file_type :avatar
  # validates_attachment_content_type :file, content_type: /\Aimage\/.*\z/

  def check_with_bundler_audit
    result = {
      warnings: [], advisories: {}
    }
    #
    scanner = Bundler::Audit::Scanner.new(
      File.dirname(file.path),
      File.basename(file.path)
    )

    # TODO scan gemfile.lock

    result
  end
end

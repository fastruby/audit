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
    vulnerabilities = {
      warnings: [], advisories: {}
    }

    scanner = Bundler::Audit::Scanner.new() # TODO self.file - insert path to gemfile.lock and file.lock name, put this inside #initialize(root = Dir.pwd, gemfile_lock = 'Gemfile.lock'))
    vulnerable = false

    scanner.scan do |result|
      vulnerable = true
      case result
      when Bundler::Audit::Scanner::InsecureSource
        vulnerabilities[:warnings] << "Insecure Source URI found: #{result.source}"
      when Bundler::Audit::Scanner::UnpatchedGem
        vulnerabilities[:advisories]["#{result.gem.name}@#{result.gem.version.to_s}"] = {
           :name => result.gem.name,
           :version => result.gem.version,
           :id =>result.advisory.id,
           :url => result.advisory.url,
           :title => result.advisory.title,
           :description => result.advisory.description
         }
      end
    end

    if vulnerable
      puts "Vulnerabilities found!"
    else
      puts "No vulnerabilities found"
    end

    debugger

    return vulnerabilities
  end
end

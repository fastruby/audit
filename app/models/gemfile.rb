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
    @list = {
      warnings: [], advisories: {}
    }

    scanner.scan do |insp|
      case insp
      when Bundler::Audit::Scanner::InsecureSource
        result[:warnings] << "Insecure Source URI found: #{insp.source}"
      when Bundler::Audit::Scanner::UnpatchedGem
        gem = insp.gem
        advisory = insp.advisory

        result[:advisories]["#{gem.name}@#{gem.version}"] = {
          name: gem.name,
          version: gem.version.to_s,
          id: advisory.id,
          url: advisory.url,
          title: advisory.title,
          description: advisory.description
        }
      end
    end

    scanner.scan do |result|
      vulnerable = true
      case result
      when Bundler::Audit::Scanner::InsecureSource
        @list[:warnings] << "Insecure Source URI found: #{result.source}"
      when Bundler::Audit::Scanner::UnpatchedGem
        @list[:advisories]["#{result.gem.name}@#{result.gem.version.to_s}"] = {
           :name => result.gem.name,
           :version => result.gem.version.to_s,
           :id =>result.advisory.id,
           :url => result.advisory.url,
           :title => result.advisory.title,
           :description => result.advisory.description
         }
      end
    end

    return @list
  end

  def extract_dir_from(file)
    path_parts = Pathname(file).each_filename.to_a
    "/" + File.join(path_parts[0..-2])
  end

  def extract_filename_from(file)
    Pathname(file).each_filename.to_a.last
  end
end

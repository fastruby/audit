require "bundler/audit/scanner"

class Gemfile < ApplicationRecord
  has_attached_file :file

  validates :file, presence: true

  # Validate content type
  validates_attachment_content_type :file, content_type: /\Atext/

  # Validate filename
  validates_attachment_file_name :file, matches: [/lock\Z/]

  validates :alpha_id, uniqueness: true

  before_validation :generate_alpha_id, on: :create

  # Explicitly do not validate
  # do_not_validate_attachment_file_type :avatar
  # validates_attachment_content_type :file, content_type: /\Aimage\/.*\z/

  def check_with_bundler_audit
    @result = { warnings: [], advisories: [] }

    scanner.scan do |result|
      case result
      when Bundler::Audit::Scanner::InsecureSource
        @result[:warnings] << "Insecure Source URI found: #{result.source}"
      when Bundler::Audit::Scanner::UnpatchedGem
        @result[:advisories] << {
          label: "#{result.gem.name}@#{result.gem.version.to_s}",
          name: result.gem.name,
          version: result.gem.version.to_s,
          id: result.advisory.id,
          url: result.advisory.url,
          title: result.advisory.title,
          description: result.advisory.description
        }
      end
    end

    @result
  end

  def extract_dir_from(file)
    path_parts = Pathname(file).each_filename.to_a
    "/" + File.join(path_parts[0..-2])
  end

  def extract_filename_from(file)
    Pathname(file).each_filename.to_a.last
  end

  def scanner
    Bundler::Audit::Scanner.new(
      File.dirname(gemfile_path),
      File.basename(gemfile_path)
    )
  end

  private

  def gemfile_path
    file.path
  end

  def generate_alpha_id
    return if alpha_id.present?

    self.alpha_id = SecureRandom.hex(2).upcase +  SecureRandom.hex(2).upcase
  end
end

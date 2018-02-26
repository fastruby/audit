class Gemfile < ApplicationRecord
  has_attached_file :file, default_url: "/images/:style/missing.png",
                    :storage => :s3,
                    :s3_credentials =>{
                      :bucket => ENV['AWS_BUCKET'],
                      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
                      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
                    },
                    :s3_region => "us-east-1"
  # Validate content type
  validates_attachment_content_type :file, :content_type => /\Atext/

  # Validate filename
  validates_attachment_file_name :file, :matches => [/lock\Z/]

  # Explicitly do not validate
  # do_not_validate_attachment_file_type :avatar
  # validates_attachment_content_type :file, content_type: /\Aimage\/.*\z/

  def check_with_bundler_audit
    # code goes here
  end
end

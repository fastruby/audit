class Gemfile < ApplicationRecord
  has_attached_file :file, default_url: "/images/:style/missing.png",
                    :storage => :s3,
                    :s3_credentials => Proc.new{|a| a.instance.s3_credentials }
  validates_attachment_content_type :file, content_type: /\Aimage\/.*\z/

  def s3_credentials
    { :bucket => ENV['AWS_BUCKET'],
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']}
  end
end

require "test_helper"
require "bundler_audit_database_preparer"
require "minitest/mock"

class BundlerAuditDatabasePreparerTest < ActiveSupport::TestCase
  class FakeLogger
    attr_reader :errors

    def initialize
      @errors = []
    end

    def error(message)
      @errors << message
    end
  end

  test "downloads the database when the directory does not exist" do
    logger = FakeLogger.new

    Bundler::Audit::Database.stub :download, ->(path:, quiet:) { FileUtils.mkdir_p(path) } do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "ruby-advisory-db")

        BundlerAuditDatabasePreparer.call(path: path, logger: logger)

        assert File.directory?(path)
        assert_empty logger.errors
      end
    end
  end

  test "updates the database when the directory already exists" do
    logger = FakeLogger.new
    updated = false
    fake_database = Object.new
    fake_database.define_singleton_method(:update!) { |*_args, **_kwargs| updated = true }

    Dir.mktmpdir do |path|
      Bundler::Audit::Database.stub :new, fake_database do
        BundlerAuditDatabasePreparer.call(path: path, logger: logger)
      end

      assert updated
      assert_empty logger.errors
    end
  end

  test "logs, but does not raise, when the download fails" do
    logger = FakeLogger.new

    Bundler::Audit::Database.stub :download, ->(path:, quiet:) { raise Bundler::Audit::Database::DownloadFailed, "boom" } do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "ruby-advisory-db")

        BundlerAuditDatabasePreparer.call(path: path, logger: logger)

        assert_not File.directory?(path)
        assert_equal 2, logger.errors.size
        assert_match(/Could not prepare ruby-advisory-db.*DownloadFailed: boom/, logger.errors.first)
        assert_match(/still missing at #{Regexp.escape(path)}/, logger.errors.last)
      end
    end
  end

  test "logs, but does not raise, when the update fails" do
    logger = FakeLogger.new
    fake_database = Object.new
    fake_database.define_singleton_method(:update!) { |*_args, **_kwargs| raise Bundler::Audit::Database::UpdateFailed, "boom" }

    Dir.mktmpdir do |path|
      Bundler::Audit::Database.stub :new, fake_database do
        BundlerAuditDatabasePreparer.call(path: path, logger: logger)
      end

      assert_equal 1, logger.errors.size
      assert_match(/Could not prepare ruby-advisory-db.*UpdateFailed: boom/, logger.errors.first)
    end
  end
end

require "test_helper"
require "bundler/audit/scanner"
require "minitest/mock"

class GemfileTest < ActiveSupport::TestCase
  class BundlerAuditScannerStub
    attr_reader :vulnerabilities

    def initialize(vulnerabilities)
      @vulnerabilities = vulnerabilities
    end

    def scan(&block)
      vulnerabilities.each { |v| block.call(v) }
    end
  end

  def valid_file
    File.new(Rails.root.join("test/fixtures/files/Gemfile.lock"))
  end

  def stub_scanner(vulnerabilities = [], &block)
    Bundler::Audit::Scanner.stub :new, BundlerAuditScannerStub.new(vulnerabilities), &block
  end

  test "valid subject is valid and generates an 8-character alpha_id" do
    stub_scanner do
      gemfile = Gemfile.new(file: valid_file)

      assert gemfile.valid?
      assert_equal 8, gemfile.alpha_id.size
    end
  end

  test "invalid file makes the record invalid" do
    stub_scanner do
      gemfile = Gemfile.new(file: File.new(Rails.root.join("Gemfile")))

      assert_not gemfile.valid?
      assert_equal ["File file name is invalid", "File is invalid"], gemfile.errors.full_messages
    end
  end

  test "nil file makes the record invalid" do
    stub_scanner do
      gemfile = Gemfile.new(file: nil)

      assert_not gemfile.valid?
      assert_equal ["File can't be blank"], gemfile.errors.full_messages
    end
  end

  test "check_with_bundler_audit returns empty results when Gemfile.lock is not vulnerable" do
    stub_scanner do
      gemfile = Gemfile.new(file: valid_file)

      assert gemfile.save
      assert_equal({warnings: [], advisories: []}, gemfile.check_with_bundler_audit)
    end
  end

  test "check_with_bundler_audit returns warnings and advisories when Gemfile.lock is vulnerable" do
    vulnerabilities = [
      Bundler::Audit::Results::InsecureSource.new("http://rubygems.org/"),
      Bundler::Audit::Results::UnpatchedGem.new(
        OpenStruct.new(name: "actionmailer", version: "3.0.1"),
        OpenStruct.new({
          id: "OSVDB-98629",
          url: "http://www.osvdb.org/show/osvdb/98629",
          title: "Action Mailer Gem for Ruby contains a possible DoS Vulnerability",
          description: "Action Mailer Gem for Ruby contains a format string flaw in the Log Subscriber component. The issue is triggered as format string specifiers (e.g. %s and %x) are not properly sanitized in user-supplied input when handling email addresses. This may allow a remote attacker to cause a denial of service"
        })
      ),
      Bundler::Audit::Results::UnpatchedGem.new(
        OpenStruct.new(name: "actionpack", version: "3.0.1"),
        OpenStruct.new({
          id: "CVE-2014-7829",
          url: "https://groups.google.com/forum/#!topic/rubyonrails-security/rMTQy4oRCGk",
          title: "Arbitrary file existence disclosure in Action Pack",
          description: "Specially crafted requests can be used to determine whether a file exists on\nthe filesystem that is outside the Rails application's root directory.  The\nfiles will not be served, but attackers can determine whether or not the file\nexists.  This vulnerability is very similar to CVE-2014-7818, but the\nspecially crafted string is slightly different.\n"
        })
      ),
      Bundler::Audit::Results::UnpatchedGem.new(
        OpenStruct.new(name: "actionpack", version: "3.0.1"),
        OpenStruct.new({
          id: "CVE-2014-7830",
          url: "https://groups.google.com/forum/#!topic/rubyonrails-security/rMTQy4oRC321",
          title: "Arbitrary file existence disclosure in Action Pack part 2",
          description: "Custom Description"
        })
      )
    ]

    stub_scanner(vulnerabilities) do
      gemfile = Gemfile.new(file: valid_file)
      assert gemfile.save

      result = gemfile.check_with_bundler_audit

      assert result.key?(:warnings)
      assert result.key?(:advisories)
      assert_equal 3, result[:advisories].size
      assert_equal ["Insecure Source URI found: http://rubygems.org/"], result[:warnings]

      last_advisory = result[:advisories].last
      assert_equal "actionpack@3.0.1", last_advisory[:label]
      assert_equal "actionpack", last_advisory[:name]
      assert_equal "3.0.1", last_advisory[:version]
      assert_equal "CVE-2014-7830", last_advisory[:id]
      assert_equal "https://groups.google.com/forum/#!topic/rubyonrails-security/rMTQy4oRC321", last_advisory[:url]
      assert_equal "Arbitrary file existence disclosure in Action Pack part 2", last_advisory[:title]
      assert_equal "Custom Description", last_advisory[:description]
    end
  end
end

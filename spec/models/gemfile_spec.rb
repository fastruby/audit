require "rails_helper"

RSpec.describe Gemfile do
  class BundlerAuditScannerStub
    attr_reader :vulnerabilities

    def initialize(vulnerabilities)
      @vulnerabilities = vulnerabilities
    end

    def scan(&block)
      vulnerabilities.each { |v|  block.call(v) }
    end
  end

  let(:file) do
    File.new("#{Rails.root}/spec/support/fixtures/Gemfile.lock")
  end
  let(:vulnerabilities) { [] }
  let(:bundler_audit_scanner) { BundlerAuditScannerStub.new(vulnerabilities) }

  before do
    allow(Bundler::Audit::Scanner).to receive(:new).and_return(bundler_audit_scanner)
  end

  subject { Gemfile.new(file: file) }

  describe "#valid?" do
    let(:alpha_id_size) { 8 }

    context "when subject is valid" do
      it "returns true and generates alpha_id" do
        expect(subject).to be_valid
        expect(subject.alpha_id.size).to eq(alpha_id_size)
      end
    end

    context "when subject is invalid" do
      let(:file) do
        File.new("#{Rails.root}/Gemfile")
      end
      let(:messages) do
        ["File file name is invalid", "File is invalid"]
      end

      it "returns false" do
        expect(subject).not_to be_valid
        expect(subject.errors.full_messages).to eq messages
      end

      context "when file is nil" do
        let(:file) { nil }

        it "returns false" do
          expect(subject).not_to be_valid
          expect(subject.errors.full_messages).to eq ["File can't be blank"]
        end
      end
    end
  end

  describe "#check_with_bundler_audit" do
    context "when Gemfile.lock is not vulnerable" do
      it "returns empty default hash" do
        expect(subject.save).to be_truthy
        expect(subject.check_with_bundler_audit).to eq({warnings: [], advisories: []})
      end
    end

    context "when Gemfile.lock is vulnerable" do
      let(:vulnerabilities) do
        [
          Bundler::Audit::Results::InsecureSource.new("http://rubygems.org/"),
          Bundler::Audit::Results::UnpatchedGem.new(
            OpenStruct.new(name: 'actionmailer', version: '3.0.1'),
            OpenStruct.new({
              id: 'OSVDB-98629',
              url: 'http://www.osvdb.org/show/osvdb/98629',
              title: 'Action Mailer Gem for Ruby contains a possible DoS Vulnerability',
              description: 'Action Mailer Gem for Ruby contains a format string flaw in the Log Subscriber component. The issue is triggered as format string specifiers (e.g. %s and %x) are not properly sanitized in user-supplied input when handling email addresses. This may allow a remote attacker to cause a denial of service'
            })
          ),
          Bundler::Audit::Results::UnpatchedGem.new(
            OpenStruct.new(name: 'actionpack', version: '3.0.1'),
            OpenStruct.new({
              id: 'CVE-2014-7829',
              url: 'https://groups.google.com/forum/#!topic/rubyonrails-security/rMTQy4oRCGk',
              title: 'Arbitrary file existence disclosure in Action Pack',
              description: "Specially crafted requests can be used to determine whether a file exists on\nthe filesystem that is outside the Rails application's root directory.  The\nfiles will not be served, but attackers can determine whether or not the file\nexists.  This vulnerability is very similar to CVE-2014-7818, but the\nspecially crafted string is slightly different.\n"
            })
          ),
          Bundler::Audit::Results::UnpatchedGem.new(
            OpenStruct.new(name: 'actionpack', version: '3.0.1'),
            OpenStruct.new({
              id: 'CVE-2014-7830',
              url: 'https://groups.google.com/forum/#!topic/rubyonrails-security/rMTQy4oRC321',
              title: 'Arbitrary file existence disclosure in Action Pack part 2',
              description: "Custom Description"
            })
          )
        ]
      end

      it "returns a hash with the vulnerabilities" do
        expect(subject.save).to be_truthy

        result = subject.check_with_bundler_audit

        expect(result).to include(:warnings)
        expect(result).to include(:advisories)
        expect(result[:advisories].size).to eq(3)
        expect(result[:warnings]).to eq(["Insecure Source URI found: http://rubygems.org/"])

        last_advisory = result[:advisories].last

        expect(last_advisory[:label]).to eq("actionpack@3.0.1")
        expect(last_advisory[:name]).to eq("actionpack")
        expect(last_advisory[:version]).to eq("3.0.1")
        expect(last_advisory[:id]).to eq("CVE-2014-7830")
        expect(last_advisory[:url]).to eq("https://groups.google.com/forum/#!topic/rubyonrails-security/rMTQy4oRC321")
        expect(last_advisory[:title]).to eq("Arbitrary file existence disclosure in Action Pack part 2")
        expect(last_advisory[:description]).to eq("Custom Description")
      end
    end
  end
end

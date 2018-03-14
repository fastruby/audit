require "rails_helper"

RSpec.describe Gemfile do
  let(:file) do
    File.new("#{Rails.root}/spec/support/fixtures/#{gemfile_lock}")
  end
  let(:gemfile_lock) do
    "healthy_Gemfile.lock"
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
    end
  end

  describe "#check_with_bundler_audit" do
    context "when Gemfile.lock is not vulnerable" do
      let(:gemfile_lock) do
        "healthy_Gemfile.lock"
      end
      let(:scanner) do
        double("Bundler::Audit::Scanner", scan: [])
      end

      before do
        allow_any_instance_of(Gemfile).to receive(:scanner).and_return(scanner)
        @gemfile = Gemfile.new(file: file)
      end

      it "returns an empty hash" do
        expect(@gemfile.save).to be_truthy
        expect(@gemfile.check_with_bundler_audit).to eq({warnings: [], advisories: {}})
      end
    end

    context "when Gemfile.lock is vulnerable" do
      let(:gemfile_lock) do
        "vulnerable_Gemfile.lock"
      end
      let(:vulnerabilities) do
        {
          warnings: ["Insecure Source URI found: http://rubygems.org/"],
          advisories: {
            "actionmailer@3.0.1" => {
              :name=>"actionmailer",
              :version=>"3.0.1",
              :id=>"OSVDB-98629",
              :url=>"http://www.osvdb.org/show/osvdb/98629",
              :title=>"Action Mailer Gem for Ruby contains a possible DoS Vulnerability",
              :description=>"Action Mailer Gem for Ruby contains a format string flaw in the Log Subscriber component. The issue is triggered as format string specifiers (e.g. %s and %x) are not properly sanitized in user-supplied input when handling email addresses. This may allow a remote attacker to cause a denial of service"
            },
            "actionpack@3.0.1" => {
              :name=>"actionpack",
              :version=>"3.0.1",
              :id=>"CVE-2014-7829",
              :url=>"https://groups.google.com/forum/#!topic/rubyonrails-security/rMTQy4oRCGk",
              :title=>"Arbitrary file existence disclosure in Action Pack",
              :description=>"Specially crafted requests can be used to determine whether a file exists on\nthe filesystem that is outside the Rails application's root directory.  The\nfiles will not be served, but attackers can determine whether or not the file\nexists.  This vulnerability is very similar to CVE-2014-7818, but the\nspecially crafted string is slightly different.\n"
            },
            "actionview@3.0.1" => {
              :name=>"actionview",
              :version=>"3.0.1",
              :id=>"CVE-2016-2097",
              :url=>"https://groups.google.com/forum/#!topic/rubyonrails-security/ddY6HgqB2z4",
              :title=>"Possible Information Leak Vulnerability in Action View",
              :description=>"\nThere is a possible directory traversal and information leak vulnerability \nin Action View. This was meant to be fixed on CVE-2016-0752. However the 3.2 \npatch was not covering all the scenarios. This vulnerability has been \nassigned the CVE identifier CVE-2016-2097.\n\nVersions Affected:  3.2.x, 4.0.x, 4.1.x\nNot affected:       4.2+\nFixed Versions:     3.2.22.2, 4.1.14.2\n\nImpact \n------ \nApplications that pass unverified user input to the `render` method in a\ncontroller may be vulnerable to an information leak vulnerability.\n\nImpacted code will look something like this:\n\n```ruby\ndef index\n  render params[:id]\nend\n```\n\nCarefully crafted requests can cause the above code to render files from\nunexpected places like outside the application's view directory, and can\npossibly escalate this to a remote code execution attack.\n\nAll users running an affected release should either upgrade or use one of the\nworkarounds immediately.\n\nReleases \n-------- \nThe FIXED releases are available at the normal locations. \n\nWorkarounds \n----------- \nA workaround to this issue is to not pass arbitrary user input to the `render`\nmethod. Instead, verify that data before passing it to the `render` method.\n\nFor example, change this:\n\n```ruby\ndef index\n  render params[:id]\nend\n```\n\nTo this:\n\n```ruby\ndef index\n  render verify_template(params[:id])\nend\n\nprivate\ndef verify_template(name)\n  # add verification logic particular to your application here\nend\n```\n\nPatches \n------- \nTo aid users who aren't able to upgrade immediately we have provided patches \nfor it. It is in git-am format and consist of a single changeset.\n\n* 3-2-render_data_leak_2.patch - Patch for 3.2 series\n* 4-1-render_data_leak_2.patch - Patch for 4.1 series\n\nCredits \n------- \nThanks to both Jyoti Singh and Tobias Kraze from makandra for reporting this \nand working with us in the patch!\n"
            },
            "activerecord@3.0.1" => {
              :name=>"activerecord",
              :version=>"3.0.1",
              :id=>"OSVDB-90072",
              :url=>"http://osvdb.org/show/osvdb/90072",
              :title=>"Ruby on Rails Active Record attr_protected Method Bypass",
              :description=>"Ruby on Rails contains a flaw in the attr_protected method of the\nActive Record. The issue is triggered during the handling of a specially\ncrafted request, which may allow a remote attacker to bypass protection\nmechanisms and alter values that would otherwise be protected.\n"
            },
            "activesupport@3.0.1"=>{
              :name=>"activesupport",
              :version=>"3.0.1",
              :id=>"OSVDB-91451",
              :url=>"http://www.osvdb.org/show/osvdb/91451",
              :title=>"XML Parsing Vulnerability affecting JRuby users",
              :description=>"The ActiveSupport XML parsing functionality supports multiple\npluggable backends. One backend supported for JRuby users is\nActiveSupport::XmlMini_JDOM which makes use of the\njavax.xml.parsers.DocumentBuilder class. In some JVM configurations\nthe default settings of that class can allow an attacker to construct\nXML which, when parsed, will contain the contents of arbitrary URLs\nincluding files from the application server. They may also allow for\nvarious denial of service attacks. Action Pack\n"
            },
            "nokogiri@1.8.1"=>{
              :name=>"nokogiri",
              :version=>"1.8.1",
              :id=>"CVE-2017-15412",
              :url=>"https://github.com/sparklemotion/nokogiri/issues/1714",
              :title=>"Nokogiri gem, via libxml, is affected by DoS vulnerabilities", :description=>"The version of libxml2 packaged with Nokogiri contains a\nvulnerability. Nokogiri has mitigated these issue by upgrading to\nlibxml 2.9.6.\n\nIt was discovered that libxml2 incorrecty handled certain files. An attacker\ncould use this issue with specially constructed XML data to cause libxml2 to\nconsume resources, leading to a denial of service.\n"
            }
          }
        }
      end

      it "returns a hash with the vulnerabilities" do
        expect(subject.save).to be_truthy
        result = subject.check_with_bundler_audit
        expect(result).to include(:warnings)
        expect(result).to include(:advisories)
        expect(result[:warnings]).to eq(["Insecure Source URI found: http://rubygems.org/"])
        expect(result[:advisories]).to include("actionmailer@3.0.1")
        expect(result[:advisories]).to include("actionpack@3.0.1")
        expect(result[:advisories]).to include("actionview@3.0.1")
        expect(result[:advisories]).to include("activerecord@3.0.1")
        expect(result[:advisories]).to include("activesupport@3.0.1")
        expect(result[:advisories]).to include("nokogiri@1.8.1")
      end
    end
  end
end

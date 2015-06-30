require 'spec_helper'

module LicenseFinder
  describe NugetPackage do

    def package_xml
      <<-XML
      <?xml version="1.0" encoding="utf-8"?>
        <package xmlns="http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd">
        <metadata>
        <id>Newtonsoft.Json</id>
    <version>2.0.3</version>
      <title>Json.NET</title>
    <description>Json.NET is a popular high-performance JSON framework for .NET</description>
      <authors>James Newton-King</authors>
    <language>en-US</language>
      <projectUrl>http://www.newtonsoft.com/json</projectUrl>
    <iconUrl>http://www.newtonsoft.com/content/images/nugeticon.png</iconUrl>
    <licenseUrl>https://raw.github.com/JamesNK/Newtonsoft.Json/master/LICENSE.md</licenseUrl>
    <tags>json</tags>
      </metadata>
</package>
XML
    end

    subject do
      described_class.from_package_xml(
        package_xml
      )
    end

    its(:name) { should == "Newtonsoft.Json" }
    its(:version) { should == "2.0.3" }
    its(:summary) { should eq "Json.NET is a popular high-performance JSON framework for .NET" }
    its(:homepage) { should == "http://www.newtonsoft.com/json" }
    its(:license_url) { should == "https://raw.github.com/JamesNK/Newtonsoft.Json/master/LICENSE.md" }
  end
end

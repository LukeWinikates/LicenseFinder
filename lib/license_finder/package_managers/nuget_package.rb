module LicenseFinder
  class NugetPackage < Package
    attr_reader :license_url
    def self.from_package_xml(xml)
      config = hashify_xml(xml)
      new(
        config["id"],
        config["version"],
        config.merge(summary: config["description"], homepage: config["projectUrl"]))
    end

    def initialize(name, version = nil, options={})
      super
      @license_url = options["licenseUrl"]
    end

    def self.hashify_xml(xml)
      package_attribute_tags = REXML::XPath.match(
        REXML::Document.new(xml),
        "//package//metadata"
      ).first.elements
      Hash[package_attribute_tags.to_a.map do |el|
        [el.name, el.text]
      end]
    end
  end
end

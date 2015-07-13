require "rexml/document"
require "zip"

module LicenseFinder
  class Nuget < PackageManager
    def package_path
      project_path.join('packages')
    end

    def assemblies
      Dir[project_path.join("**", "packages.config")].map do |d|
        path = Pathname.new(d).dirname
        name = path.basename.to_s
        Assembly.new path, name
      end
    end

    def current_packages
      dependencies.reduce({}) do |memo, dep|
        xml = NugetExtractor.new(project_path, dep).xml
        memo[dep.name] ||= NugetPackage.from_package_xml(xml)
        memo[dep.name].groups << dep.assembly if !memo[dep.name].groups.include? dep.assembly
        memo
      end.values
    end

    def dependencies
      assemblies.flat_map(&:dependencies)
    end

    class Assembly
      attr_reader :name, :path
      def initialize(path, name)
        @path = path
        @name = name
      end

      def dependencies
        xml = REXML::Document.new(File.read(path.join("packages.config")))
        packages = REXML::XPath.match(xml, "//package")
        packages.map do |p|
          attrs = p.attributes
          Dependency.new(attrs["id"], attrs["version"], self.name)
        end
      end
    end

    class Dependency < Struct.new(:name, :version, :assembly)
    end

    class NugetExtractor
      attr_reader :project_path, :dep
      def initialize(project_path, dep)
        @project_path = project_path
        @dep = dep
      end

      def package_path
        datstrang = "#{dep.name}.#{dep.version}"
        project_path.join('packages', datstrang, "#{datstrang}.nupkg")
      end

      def xml
        ::Zip::File.open(package_path) do |zip_file|
          zip_file.read("#{dep.name}.nuspec")
        end
      end
    end
  end
end


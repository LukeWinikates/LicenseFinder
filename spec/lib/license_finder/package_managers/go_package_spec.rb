require 'spec_helper'

module LicenseFinder
  describe GoPackage do
    subject do
      GoPackage.new(
        {
          'ImportPath' => 'github.com/cloudfoundry-incubator/candiedyaml',
          'Rev' => '5f3b3579b3dc360c8ad3f86fe9e59e58c5652d10'
        },
        {
          install_prefix: '/fake/gopath/src'
        }
      )
    end

    describe '#initialize' do
      it 'sets the package name' do
        expect(subject.name).to eq('github.com/cloudfoundry-incubator/candiedyaml')
      end

      it 'sets the package version' do
        expect(subject.version).to eq('5f3b357')
      end

      it 'sets the install path' do
        expect(subject.install_path).to eq('/fake/gopath/src/github.com/cloudfoundry-incubator/candiedyaml')
      end
    end
  end
end

name             'crowd'
source_url       'https://github.com/osuosl-cookbooks/crowd'
issues_url       'https://github.com/osuosl-cookbooks/crowd/issues'
maintainer       "SecondMarket Labs, LLC"
maintainer_email "systems@secondmarket.com"
license          "Apache-2.0"
chef_version     '>= 12.18' if respond_to?(:chef_version)
description      "Installs/Configures Atlassian Crowd"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"

depends 'ark'
depends 'database'
depends 'java'
depends 'osl-postgresql'
depends 'seven_zip', '< 3.0.0'

%w{redhat centos}.each do |os|
  supports os
end

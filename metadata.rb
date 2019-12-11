name             'crowd'
source_url       'https://github.com/osuosl-cookbooks/crowd'
issues_url       'https://github.com/osuosl-cookbooks/crowd/issues'
maintainer       "SecondMarket Labs, LLC"
maintainer_email "systems@secondmarket.com"
license          "Apache-2.0"
chef_version     '>= 14.0'
description      "Installs/Configures Atlassian Crowd"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.1.1"

depends 'ark'
depends 'java'
depends 'osl-postgresql'

%w{redhat centos}.each do |os|
  supports os
end

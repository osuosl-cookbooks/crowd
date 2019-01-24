name             'crowd'
maintainer       "SecondMarket Labs, LLC"
maintainer_email "systems@secondmarket.com"
license          "Apache 2.0"
description      "Installs/Configures Atlassian Crowd"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.1"

depends 'database'
depends 'java'
depends 'postgresql', '~> 6.1.3'
depends 'seven_zip', '< 3.0.0'

%w{redhat centos}.each do |os|
  supports os
end

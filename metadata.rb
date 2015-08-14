name 'kubernetes-mesos'
maintainer 'Nick Dobson'
maintainer_email 'nick.dobson@me.com'
license 'Apache 2.0'
description 'Installs/Configures Kubernetes on Mesos'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.1'

supports 'centos'

depends 'docker', '= 0.43.0'
depends 'github'

maintainer       "Daniel Hahn"
maintainer_email "averell@newgods.org"
license          "GNU Public License 3.0"
description      "Installs/Configures rails_install"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

depends "ruby_from_source"
depends "database"
depends "application_ruby"
depends "application_nginx"
depends "build-essential"
depends "passenger_apache2"
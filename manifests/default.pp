class baseclass {}

node default {
  include baseclass

  package { 
    'mc':               ensure => present;
    'git':              ensure => present;
  }

  file { "/etc/update-motd.d/10-help-text":
    ensure  => absent,
  }

  hostkey { 'github.com':    print => '16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48' }
}

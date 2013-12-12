class ordenull::benchmark (
  $mysql_host  = undef,
  $dd_api_key  = undef,
) {

  $port = 80

  if $dd_api_key != undef {
    class { 'datadog':
      api_key            => $dd_api_key,
      puppet_run_reports => true,
    }
  }

#############################################################
#### MySQL Server
#############################################################
if $mysql_host == undef or $mysql_host == localhost {
  # No external MySQL server, install MySQL locally
  class { '::mysql::server':
    root_password    => 'gakAtJamEt2',
  }
}

#############################################################
#### Apache
#############################################################
  class { 'apache':
    mpm_module    => false,
    serveradmin   => 'stan@borbat.com',
    default_vhost => false,
  }
  
  class { 'apache::mod::prefork':
    startservers        => 5,
    minspareservers     => 5,
    maxspareservers     => 5,
    serverlimit         => 20,
    maxclients          => 20,
    maxrequestsperchild => 4000,
  }

  include apache::mod::php
  include apache::mod::rewrite

  file { '/srv/www':          ensure => directory }
  file { '/srv/www/default':  ensure => directory }

  apache::vhost { "default-http":
    priority      => "10",
    servername    => "default",
    port          => 80,
    docroot       => "/srv/www/default",
  }

#############################################################
#### PHP FPM
#############################################################  
  class { 'php::fpm::daemon':
    log_level => notice,
  }
  php::fpm::conf { 'www':
    ensure => absent,
  }

#############################################################
#### WordPress Common
#############################################################
  class { 'wordpress':
    mysql_host          => $mysql_host,
    admin_email         => 'stan@borbat.com',
    group               => 'www-data',
    mode                => 0660,
    require             => Hostkey['github.com'],
    inclde_mysql_client => false,
  }

#############################################################
#### Base WordPress 01
#############################################################
  ordenull::wordpress { 'wp-base01':
    hostname     => 'base01.wp.xeraweb.net',
    manage_mysql => true,
    mysql_pass   => 'IbyuofDid0',
    git          => 'https://github.com/ordenull/ordenull-puppet-wordpress-sample.git',
  }

#############################################################
#### Base WordPress 02 (Added on 2013-11-15 13:14)
#############################################################
  ordenull::wordpress { 'wp-base02':
    hostname     => 'base02.wp.xeraweb.net',
    manage_mysql => true,
    mysql_pass   => 'IbyuofDid0',
    git          => 'https://github.com/ordenull/ordenull-puppet-wordpress-sample.git',
  }

#############################################################
#### Base WordPress 03 (Added on 2013-11-16 23:12)
#############################################################
  ordenull::wordpress { 'wp-base03':
    hostname     => 'base03.wp.xeraweb.net',
    manage_mysql => true,
    mysql_pass   => 'IbyuofDid0',
    git          => 'https://github.com/ordenull/ordenull-puppet-wordpress-sample.git',
  }

#############################################################
#### Base WordPress 04 (Added on 2013-11-19 11:53)
#############################################################
  ordenull::wordpress { 'wp-base04':
    hostname     => 'base04.wp.xeraweb.net',
    manage_mysql => true,
    mysql_pass   => 'IbyuofDid0',
    git          => 'https://github.com/ordenull/ordenull-puppet-wordpress-sample.git',
  }

#############################################################
#### Base WordPress 05 (Added on 2013-11-20 19:10)
#############################################################
  ordenull::wordpress { 'wp-base05':
    hostname     => 'base05.wp.xeraweb.net',
    manage_mysql => true,
    mysql_pass   => 'IbyuofDid0',
    git          => 'https://github.com/ordenull/ordenull-puppet-wordpress-sample.git',
  }

#############################################################
#### Base WordPress 06 (Added on 2013-11-21 17:41)
#############################################################
  ordenull::wordpress { 'wp-base06':
    hostname     => 'base06.wp.xeraweb.net',
    manage_mysql => true,
    mysql_pass   => 'IbyuofDid0',
    git          => 'https://github.com/ordenull/ordenull-puppet-wordpress-sample.git',
  }

#############################################################
#### Base WordPress 07 (Added on 2013-11-22 16:49)
#############################################################
  ordenull::wordpress { 'wp-base07':
    hostname     => 'base07.wp.xeraweb.net',
    manage_mysql => true,
    mysql_pass   => 'IbyuofDid0',
    git          => 'https://github.com/ordenull/ordenull-puppet-wordpress-sample.git',
  }

#############################################################
#### Base WordPress 08 (Added on 2013-11-22 22:42)
#############################################################
  ordenull::wordpress { 'wp-base08':
    hostname     => 'base08.wp.xeraweb.net',
    manage_mysql => true,
    mysql_pass   => 'IbyuofDid0',
    git          => 'https://github.com/ordenull/ordenull-puppet-wordpress-sample.git',
  }

}

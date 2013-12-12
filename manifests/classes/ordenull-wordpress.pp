define ordenull::wordpress (
  $hostname     = undef,
  $check_url    = "http://$hostname",
  $aliases      = undef,
  $git          = "https://github.com/ordenull/ordenull-puppet-wordpress-sample.git",
  $home         = "/srv/www/$title",
  $docroot      = "/srv/www/$title/public",
  $mysql_host   = localhost,
  $mysql_schema = $title,
  $mysql_user   = $title,
  $owner        = $title,
  $group        = $title,
  $mysql_pass   = undef,
  $engine       = 'modphp',
  $manage_mysql = false,
) {

  $port = 80

  # Configure MySQL
  if $manage_mysql == true {
    mysql::db { $mysql_schema:
      user     => $mysql_user,
      password => $mysql_pass,
      host     => $wordpress::mysql_host,
    }
  }

  # Set up monitoring
  if defined( Class["datadog"] ) {
    datadog::check::http { $title:
      url     => 'http://localhost/',
      headers => ["Host: $hostname"],
      tags    => ["cms:wordpress", "url:$check_url"],
      timeout               => 10,
      threshold             => 4,
      window                => 6,
      collect_response_time => true,
    }
  }

  # Deploy the WordPress site
  if $manage_mysql == true {
    wordpress::site { $title:
      hostname     => $hostname,
      git_repo     => $git,
      home         => $home,
      mysql_schema => $mysql_schema,
      mysql_user   => $mysql_user,
      mysql_pass   => $mysql_pass,
      owner        => $real_owner,
      group        => $real_group,
      require      => Mysql::Db["$mysql_schema"],
    }
  } else {
    wordpress::site { $title:
      hostname     => $hostname,
      git_repo     => $git,
      home         => $home,
      mysql_schema => $mysql_schema,
      mysql_user   => $mysql_user,
      mysql_pass   => $mysql_pass,
      owner        => $real_owner,
      group        => $real_group,
    }
  }

  # Configure the web server
  case $engine {

    #########################################
    ## Apache mod_php Engine ################
    #########################################
    'modphp': {
      $real_owner = 'www-data'
      $real_group = 'www-data'
      apache::vhost { $title:
        priority          => 20,
        port              => $port,
        servername        => $hostname,
        serveraliases     => $aliases,
        docroot           => $docroot,
        docroot_owner     => $owner,
        #access_log_format => 'extended',
        override          => ['All'],
        block             => ['scm'],
        #require           => Wordpress::Site[$title],
      }
    }

    #########################################
    ## Apache fastcgi/php-fpm engine ########
    #########################################
    'phpfpm': {
      $real_owner = $owner
      $real_group = $group
      php::fpm::conf { $title:
        listen               => "/var/lib/php5-fpm/$title.socket",
        listen_owner         => $owner,
        listen_group         => $owner,
        listen_mode          => 0666,
        user                 => $owner,
        group                => $owner,
        pm_max_children      => '10',
        pm_start_servers     => '2',
        pm_min_spare_servers => '2',
        pm_max_spare_servers => '5',
        pm_max_requests      => '1000',
        #catch_workers_output => true,
        #error_log            => true,
      }

      apache::vhost { $title:
        priority          => 20,
        port              => $port,
        servername        => $hostname,
        serveraliases     => $aliases,
        docroot           => $docroot,
        docroot_owner     => $owner,
        access_log_format => 'extended',
        override          => ['All'],
        custom_fragment   => "
          # PHP5 fast process manager
          <IfModule mod_fastcgi.c>
            AddHandler php5-fcgi .php
            Action php5-fcgi /php5-fcgi
            Alias /php5-fcgi /usr/lib/cgi-bin/php5-fcgi-$title
            FastCgiExternalServer /usr/lib/cgi-bin/php5-fcgi-$title -socket /var/lib/php5-fpm/$title.socket
          </IfModule>
          <Location /php5-fcgi>
            Order Deny,Allow
            Deny from All
            Allow from env=REDIRECT_STATUS
          </Location>
        ",
        #require => Wordpress::Site[$title],
      }
    }

    #########################################
    ## No PHP Engine ########################
    #########################################
    default: { 
      $real_owner = $owner
      $real_group = $group
    }
  }

}

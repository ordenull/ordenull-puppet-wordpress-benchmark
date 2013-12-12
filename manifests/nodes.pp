node /[a-z]+[0-9]+.xeraweb.net/ inherits default {
  class { 'ordenull::benchmark':
    mysql_host   => 'localhost',
    dd_api_key   => "SET YOUR DATADOG API KEY HERE",
  }
}

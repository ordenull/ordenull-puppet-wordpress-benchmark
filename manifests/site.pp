Exec {
  path => ["/bin", "/sbin", "/usr/bin", "/usr/sbin"],
}

File {
  ignore => '.git'
}

User {
  shell => '/bin/bash'
}

import "classes/*.pp"
import "default.pp"
import "nodes.pp"

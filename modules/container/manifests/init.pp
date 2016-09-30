class container {
  if member($roles, 'docker') {
    include docker::configure
  } else {
    include docker::disable
  }
}

class docker::configure {
  package { ["docker"]: ensure => installed; }

  service { "docker":
    ensure    => running,
    enable    => true,
    hasstatus => true,
  }

  exec {
    "Check Cassandra Image":
        command => "/bin/docker pull cassandra:latest",
        onlyif  => "/usr/bin/test `/bin/docker images cassandra:latest |wc -l` -lt 2",
        user    => "root",
        require => Package["docker"],
       }
}

class docker::disable {
  package { ["docker"]: ensure => absent; }

  service { "docker":
    ensure    => stopped,
    enable    => false,
    hasstatus => true,
  }
}


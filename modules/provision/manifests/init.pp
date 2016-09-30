class provision ($instances) {

  file { "/opt/scripts":
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => 644,
  }

  file { "/opt/scripts/create_provision.sh":
    owner   => root,
    group   => root,
    mode    => 750,
    source  => "puppet:///modules/provision/create_provision.sh",
    require => File['/opt/scripts'],
  }

   exec {
     "Execute Check Provision":
         command => "/bin/bash /opt/scripts/create_provision.sh",
         user    => "root",
         require => File["/etc/scaling"],
     }

  package { curl: ensure => installed, }

  file { "/etc/scaling":
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => 644,
    recurse => true,
    purge   => true,
    require => Package["curl"]
  }

  create_resources(provision::instance, $instances)

  define instance ($id, $cpus, $mem, $scale, $type, $typelow, $image, $network, $cmd) {
    file { "/etc/scaling/$id":
      owner   => root,
      group   => root,
      mode    => 644,
      content => template("provision/apps.erb"),
      require => File["/etc/scaling"],
      notify  => Exec['Execute Check Provision']

    }
  }
}


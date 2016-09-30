class cluster {
	if member ($roles, 'mesos_masterslave') {
		include mesos::masterslave
	} else {
		include mesos::disable
	}
}

class mesos::masterslave {
  package { ["mesos", "marathon", "mesosphere-zookeeper", "java-1.8.0-openjdk"]: ensure => installed; }

  service { "mesos-master":
    ensure    => running,
    enable    => true,
    hasstatus => true,
    hasrestart => true,
    restart => "systemctl restart mesos-master",
    require => Package['mesos'],

  }

  service { "mesos-slave":
    ensure    => running,
    enable    => true,
    hasstatus => true,
    notify => Service['mesos-master'],
  }

  service { "marathon":
    ensure    => running,
    enable    => true,
    hasstatus => true,
    notify => Service['mesos-master'],
  }

  service { "zookeeper":
    ensure    => running,
    enable    => true,
    hasstatus => true,
    notify => Service['mesos-master'],
  }
  file { "/etc/mesos-slave":
    owner        => root,
    group        => root,
    mode         => 644,
    recurse => true,
    source       => "puppet:///modules/cluster",
    notify => Service['mesos-slave'],
   }
}

class mesos::disable {
  service { "mesos-master":
    ensure    => stopped,
    enable    => false,
    hasstatus => true,
  }

  service { "mesos-slave":
    ensure    => stopped,
    enable    => false,
    hasstatus => true,
  }

  package { ["mesos", "marathon", "mesosphere-zookeeper", "java-1.8.0-openjdk"]: ensure => absent; }
}

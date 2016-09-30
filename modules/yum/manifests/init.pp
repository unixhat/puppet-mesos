# == Copyright
# Copyright (C) 2014 ASYX International B.V. All rights reserved.
#
# Company-Sensitive information, for ASYX internal use only.
#
class yum ($repositories) {
  package { yum: ensure => installed, }

  file { "/etc/yum.repos.d":
    owner   => root,
    group   => root,
    mode    => 644,
    recurse => true,
    purge   => false,
    source  => "puppet:///modules/yum/yum.repos.d",
    require => Package["yum"],
  }

  create_resources(yum::repository, $repositories)

  define repository ($name, $mirrorlist = undef, $baseurl = undef, $gpgcheck = 1, $gpgkey = undef, $enabled = 1) {
    file { "/etc/yum.repos.d/$title.repo":
      owner   => root,
      group   => root,
      mode    => 644,
      content => template("yum/yum_repository.erb"),
      require => File["/etc/yum.repos.d"],
    }
  }
}

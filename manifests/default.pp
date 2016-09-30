include stdlib

class { ['yum' ]: stage => setup, }

$roles = hiera_array("roles", [])
$roles_list = join($roles, ', ')
notice "Using roles: $roles_list Using environment: $::environment"

hiera_include("classes")

if versioncmp($::puppetversion,'3.6.1') >= 0 {

  $allow_virtual_packages = hiera('allow_virtual_packages',false)

  Package {
    allow_virtual => $allow_virtual_packages,
  }
}

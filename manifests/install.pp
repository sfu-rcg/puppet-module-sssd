class sssd::install {
  package { $sssd::params::pkg_list:
    ensure => present,
  }
}

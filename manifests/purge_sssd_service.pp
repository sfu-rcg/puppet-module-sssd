class sssd::purge_sssd_service {
  # If this file is being assigned at all in the parameters we are currently assuming it's following the standard
  # location for systemd files as of Centos 7 and Ubuntu 15.04
  if $::sssd::params::purge_sssd_file {
    exec { 'systemctlreload':
      command     => 'systemctl daemon-reload',
      subscribe   => Sssd::Purge_sssd['/etc/systemd/system/purge_sssd.service'],
      path        => [ '/bin/', '/usr/bin/' ]
      refreshonly => true,
    }
    service { 'purge_sssd':
      enable    => true,
    }
  }
}

class sssd::purge_sssd_service {
  # Installs required file for purge_sssd depending on OS version
  sssd::purge_sssd { $::sssd::params::purge_sssd_file: }

  if ( $::osfamily == 'redhat' ) and ( $::operatingsystemversion >= 7 ) {
    exec { 'systemctlreload':
      command     => '/usr/bin/systemctl daemon-reload',
      subscribe   => File['/etc/systemd/system/purge_sssd.service'],
      refreshonly => true,
    }
    service { 'purge_sssd':
      enable    => true,
    }
  }
}

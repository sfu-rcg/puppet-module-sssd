class sssd::purge_sssd_service {
  if ( $::osfamily == 'redhat' ) and ( $::operatingsystemversion >= 7 ) {
    exec { 'systemctlreload':
      command     => '/usr/bin/systemctl daemon-reload',
      subscribe   => Sssd::Purge_sssd['/etc/systemd/system/purge_sssd.service'],
      refreshonly => true,
    }
    service { 'purge_sssd':
      enable    => true,
    }
  }
}

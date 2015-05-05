class sssd::service {
  service { 'sssd':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => File['/etc/sssd/sssd.conf'],
  }
  if ( $::osfamily == 'redhat' ) and ( $::operatingsystemversion >= 7 ) { 
    exec { 'systemctlreload':
      command     => '/usr/bin/systemctl daemon-reload',
      subscribe   => '/etc/systemd/system/purge_sssd.service',
      refreshonly => true,
    }
    service { 'purge_sssd':
      enable    => true,
    }
  }
}

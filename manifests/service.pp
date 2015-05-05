class sssd::service {
  service { 'sssd':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => File['/etc/sssd/sssd.conf'],
  }
  if ( $::osfamily == 'redhat' ) and ( $::operatingsystemversion >= 7 ) { 
    exec { 'systemctlreload':
      command   => '/usr/bin/systemctl daemon-reload',
      onlyif    => "test -f /etc/systemd/system/purge_sssd.service",
      subscribe => '/etc/systemd/system/purge_sssd.service',
    }
    service { 'purge_sssd':
      enable    => true,
    }
  }
}

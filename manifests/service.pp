class sssd::service {
  service { 'sssd':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => File['/etc/sssd/sssd.conf'],
  }
  if ( $::osfamily == 'redhat' ) and ( $::operatingsystemversion >= 7 ) { 
    service { 'purge_sssd':
      ensure    => enabled,
      enable    => true,
    }
  }
}

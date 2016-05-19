class sssd::service {
  service { 'sssd':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => Concat['/etc/sssd/sssd.conf'],
  }
}

class sssd (
  $domains,
  $services,
) inherits sssd::params {

  validate_array( $domains, $services, ) 

  anchor { 'sssd::begin': }
  anchor { 'sssd::end': }

Anchor[ 'sssd::begin' ] -> class { 'sssd::install': } -> Class['sssd::config'] ~> class {'sssd::service': } -> Anchor[ 'sssd::end' ]
  
  class { 'sssd::config':
    domains       => $domains,
    services      => $services,
  }
}

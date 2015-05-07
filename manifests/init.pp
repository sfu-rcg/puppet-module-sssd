class sssd (
  $domains,
  $services,
) inherits sssd::params {

  validate_array( $domains, $services, ) 

  anchor { 'sssd::begin': }
  anchor { 'sssd::end': }

# formerly puppet::end -- don't know why
Anchor[ 'sssd::begin' ] -> class { 'sssd::install': } -> Class['sssd::config'] ~> class { 'sssd::service': } -> class { 'sssd::purge_sssd_service': } -> Anchor[ 'sssd::end' ]
  
  class { 'sssd::config':
    domains       => $domains,
    services      => $services,
  }
}

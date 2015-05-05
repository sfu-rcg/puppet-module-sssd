define sssd::purge_sssd {
  file { "$name":
    ensure  => file,
    content => template(join([ 'sssd/', regsubst($name,'^(.*[\\\/])', '','G'), '.erb' ], '')),
    mode    => 0644,
  }
}

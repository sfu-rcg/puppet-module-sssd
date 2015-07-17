define sssd::purge_sssd ($domain = undef) {
  file { "$name":
    ensure  => file,
    content => template(join([ 'sssd/', regsubst($name,'^(.*[\\\/])', '','G'), '.erb' ], '')),
    mode    => '0700',
  }
}

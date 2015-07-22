define sssd::purge_sssd ($domain = undef, $chmod = undef) {
  file { "$name":
    ensure  => file,
    content => template(join([ 'sssd/', regsubst($name,'^(.*[\\\/])', '','G'), '.erb' ], '')),
    mode    => $chmod,
  }
}

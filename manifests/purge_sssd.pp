define sssd::purge_sssd ($domain = undef, $purgefile = undef, $chmod = undef) {
  file { "$purgefile":
    ensure  => file,
    content => template(join([ 'sssd/', regsubst($purgefile,'^(.*[\\\/])', '','G'), '.erb' ], '')),
    mode    => $chmod,
  }
#  file { "$name":
#    ensure  => file,
#    content => template(join([ 'sssd/', regsubst($name,'^(.*[\\\/])', '','G'), '.erb' ], '')),
#    mode    => '0700',
#  }
}

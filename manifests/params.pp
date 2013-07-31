class sssd::params {
  case $::operatingsystem {
    debian, ubuntu: {
      $pkg_list     = [ 'sssd', 'libnss-sss', 'libpam-sss',
                        'sssd-tools', 'auth-client-config',
                        'autofs5', 'autofs5-ldap', ]
    }
    redhat, centos: {
      case $::lsbmajdistrelease {
        6: { $pkg_list     = [ 'sssd', 'sssd-tools', 'libsss_autofs',
                               'autofs', ] }
        7: { $pkg_list     = [ 'sssd', 'sssd-tools', 'autofs', ] }
      }
    }
    fedora: {
      case $::lsbmajdistrelease {
        17, 18: { $pkg_list     = [ 'sssd', 'sssd-tools', 'libsss_autofs',
                                    'autofs', ] }
        19: { $pkg_list     = [ 'sssd', 'sssd-tools', 'autofs', ] }
      }
    }
    default: {
      fail('Unsupported operating system')
    }
  }
}

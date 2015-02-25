class sssd::params {
  case $::operatingsystem {
    debian, ubuntu: {
      $pkg_list     = [ 'sssd', 'libnss-sss', 'libpam-sss',
                        'sssd-tools', 'auth-client-config',
                        'autofs5', 'autofs5-ldap', ]
    }

    redhat, centos: {
      case $::lsbmajdistrelease {
        # CentOS 6.6 moved to SSSD 1.11-6 which eliminates
        # the package "libsss_autofs"
        #
        # If, for some reason, you're running <= 6.5, add libsss_autofs here
        6: { $pkg_list     = [ 'sssd', 'sssd-tools', 'autofs', ] }
        7: { $pkg_list     = [ 'sssd', 'sssd-tools', 'autofs', ] }
      }
    }
    fedora: {
      case $::lsbmajdistrelease {
        17, 18: { $pkg_list     = [ 'sssd', 'sssd-tools', 'libsss_autofs',
                                    'autofs', ] }
        19, 20: { $pkg_list     = [ 'sssd', 'sssd-tools', 'autofs', ] }
      }
    }
    default: {
      fail('Unsupported operating system')
    }
  }
}

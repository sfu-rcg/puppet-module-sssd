class sssd::params {
  case $::operatingsystem {
    debian, ubuntu: {
      $pkg_list         = [ 'sssd', 'libnss-sss', 'libpam-sss',
                            'sssd-tools', 'auth-client-config',
                            'autofs5', 'autofs5-ldap',
                          ]
      $purge_sssd_service = {
                              '/etc/systemd/system/purge_sssd.service' => {
                                chmod => '0622'
                              }
                            }
      $purge_sssd_file    = {
                              '/root/purge_sssd' => {
                                chmod => '0700'
                              }
                            }
    }

    redhat, centos: {
      case $::operatingsystemmajrelease {
        # CentOS 6.6 moved to SSSD 1.11-6 which eliminates
        # the package "libsss_autofs"
        #
        # If, for some reason, you're running <= 6.5, add libsss_autofs here
        6: {
          $pkg_list           = [ 'sssd', 'sssd-tools', 'autofs' ]
          $purge_sssd_file    = { 
                                  '/etc/rc.d/rc.local' => {
                                    chmod => '0700' 
                                  }
                                }
        }
        7: {
          $pkg_list           = [ 'sssd', 'sssd-tools', 'autofs' ]
          $purge_sssd_service = {
                                  '/etc/systemd/system/purge_sssd.service' => {
                                    chmod => '0622'
                                  }
                                }
          $purge_sssd_file    = {
                                  '/root/purge_sssd' => {
                                    chmod => '0700'
                                  }
                                }
        }
      }
    }
    fedora: {
      case $::operatingsystemmajrelease {
        17, 18: { $pkg_list     = [ 'sssd', 'sssd-tools', 'libsss_autofs',
                                    'autofs', ] }
        19, 20, 21, 22: { $pkg_list     = [ 'sssd', 'sssd-tools', 'autofs', ] }
      }
    }
    default: {
      fail('Unsupported operating system')
    }
  }
}

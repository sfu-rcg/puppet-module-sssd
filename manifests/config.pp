class sssd::config (
  $domains,
  $services,
  ) {

  file { '/etc/sssd':
    ensure  => directory,
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
  }

  concat { '/etc/sssd/sssd.conf':
    warn    => true,
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
  }

  concat::fragment { 'sssd.conf.base':
    target  => '/etc/sssd/sssd.conf',
    order   => '02',
    content => template('sssd/sssd.conf.erb'),
  }

  case $::osfamily {
    'debian': {
      # SSSD automount retrieval in autofs 5.0.7 is busted in Ubuntu
      # see https://bugs.launchpad.net/linuxmint/+bug/1081489 for a fix
      case $::operatingsystemmajrelease {
        /^15\.\d+/, /^16\.\d+/: { 
          file { '/etc/auth-client-config/profile.d/sss':
	          ensure  => file,
	          content => template('sssd/sss-ubuntu15.erb'),
	          notify  => Exec['update-sssd-profile'],
          }
        }
        default: {
          file { '/etc/auth-client-config/profile.d/sss':
	          ensure  => file,
	          content => template('sssd/sss.erb'),
	          notify  => Exec['update-sssd-profile'],
          }
        }
      }
      exec { 'update-sssd-profile':
        command     => '/usr/sbin/auth-client-config -a -p sss',
       	require     => File[ '/etc/auth-client-config/profile.d/sss' ],
       	refreshonly => true,
      }
      if member($services, 'autofs') {
        include autofs
        augeas { 'nsswitch.conf':
          context => '/files/etc/nsswitch.conf',
          changes => ["defnode target \"/files/etc/nsswitch.conf/database[. = 'automount']/\" \"automount\"",
                      "set \$target/service[1] sss",
                      "set \$target/service[2] files",],
          notify  => [ Service[autofs], ],
        }
      }
      else {
        augeas { 'nsswitch.conf':
          context => '/files/etc/nsswitch.conf',
          changes => ["defnode target \"/files/etc/nsswitch.conf/database[. = 'automount']/\" \"automount\"",
                      "set \$target/service[1] files",
                      "rm \$target/service[2]",],
          notify  => [ Service[autofs], ],
        }
      }
    }

    'redhat': {
      if member($services, 'pam') {
        exec { 'authconfig-enable-sssd':
          command => '/usr/sbin/authconfig --enablesssd --enablesssdauth --update',
          unless  => '/usr/bin/grep "automount:  sss files" /etc/nsswitch.conf',
        }
      } else {
        exec { 'authconfig-enable-sssd':
          command => '/usr/sbin/authconfig --disablesssd --disablesssdauth --update'
        }
     }

      if member($services, 'autofs') {
        include autofs
        augeas { 'nsswitch.conf':
          context => '/files/etc/nsswitch.conf',
          changes => ["set /files/etc/nsswitch.conf/*[self::database = 'automount']/service[1] sss",
                      "set /files/etc/nsswitch.conf/*[self::database = 'automount']/service[2] files",],
          notify  => [ Service[autofs], ],
        }
      }
      else {
        augeas { 'nsswitch.conf':
          context => '/files/etc/nsswitch.conf',
          changes => ["set /files/etc/nsswitch.conf/*[self::database = 'automount']/service[1] files",
                      "rm /files/etc/nsswitch.conf/*[self::database = 'automount']/service[2]",],
          notify  => [ Service[autofs], ],
        }
      }
    }
  }
  if $::sssd::params::purge_sssd_file {
    # Installs required file for purge_sssd depending on OS version
    $domainhash = { domain => $domains[0] }
    create_resources('sssd::purge_sssd', $::sssd::params::purge_sssd_file, $domainhash)
    create_resources('sssd::purge_sssd', $::sssd::params::purge_sssd_service, $domainhash)
  }
}

class sssd::config (
  $domains,
  $services,
  ) {

  concat { '/etc/sssd/sssd.conf':
    warn    => true,
    mode    => '0600',
    owner	=> 'root',
    group	=> 'root',
  }

  concat::fragment { 'sssd.conf.base':
    target  => '/etc/sssd/sssd.conf',
    order   => 02,
    content => template('sssd/sssd.conf.erb'),
  }

  case $::osfamily {
    debian: {

      # SSSD automount retrieval in autofs 5.0.7 is busted in Ubuntu
      # see https://bugs.launchpad.net/linuxmint/+bug/1081489 for a fix
      file { '/etc/auth-client-config/profile.d/sss':
	ensure  => file,
	content => template('sssd/sss.erb'),
	notify  => Exec['update-sssd-profile'],
      }
      exec { 'update-sssd-profile':
	command     => '/usr/sbin/auth-client-config -a -p sss',
	require     => File[ '/etc/auth-client-config/profile.d/sss' ],
	refreshonly => true,
      }
    }

    redhat: {
      include autofs
      if member($services, 'autofs') {
        augeas { 'nsswitch.conf':
          context => '/files/etc/nsswitch.conf',
          changes => ["set /files/etc/nsswitch.conf/*[self::database = 'automount']/service[1] sss",
                      "set /files/etc/nsswitch.conf/*[self::database = 'automount']/service[2] files",],
          notify => [ Service[sssd], Service[autofs], ],
        }
      }
      else {
        augeas { 'nsswitch.conf':
          context => '/files/etc/nsswitch.conf',
          changes => ["set /files/etc/nsswitch.conf/*[self::database = 'automount']/service[1] files",
                      "rm /files/etc/nsswitch.conf/*[self::database = 'automount']/service[2]",],
          notify => [ Service[sssd], Service[autofs], ],
        }
      }
    }
  }
  }
  

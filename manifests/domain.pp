#
define sssd::domain (
  $access_provider                = undef,
  $auth_provider                  = undef, # required
  $autofs_debug_level             = undef,
  $autofs_provider                = undef,
  $chpass_provider                = undef,
  $cache_credentials              = undef,
  $debug_level                    = undef,
  $dyndns_update                  = false,
  $entry_cache_autofs_timeout     = undef,
  $enumerate                      = undef,
  $id_provider                    = undef, # required
  $krb5_canonicalize              = undef,
  $krb5_renew_interval            = undef,
  $krb5_renewable_lifetime        = undef,
  $krb_use_fast                   = undef,
  $ldap_access_filter             = undef,
  $ldap_access_order              = undef,
  $ldap_account_expire_policy     = undef,
  $ldap_autofs_entry_key          = undef,
  $ldap_autofs_entry_object_class = undef,
  $ldap_autofs_entry_value        = undef,
  $ldap_autofs_map_name           = undef,
  $ldap_autofs_map_object_class   = undef,
  $ldap_autofs_search_base        = undef,
  $ldap_id_mapping                = undef, # required
  $ldap_id_use_start_tls          = undef,
  $ldap_sasl_authid               = undef,
  $ldap_sasl_mech                 = undef,
  $ldap_schema                    = undef,
  $ldap_use_tokengroups           = undef, # for murmurhash3, not POSIX GIDs
  $max_id                         = undef,
  $min_id                         = undef,
  $sudo_provider                  = undef,
  ) {

  # Workaround for foreman bug in 1.6.2 host.shortname returns fqdn, we need the shortname
  # Therefore we override this variable if it is not set via hiera, manifest or foreman(when fixed)
  if ! $ldap_sasl_authid {
    $hostnameupcase       = upcase($::hostname)
    $domainnameupcase     = upcase($name)
    $ldap_sasl_authid_fix = "${hostnameupcase}\$@${domainnameupcase}"
  }
  else {
    $ldap_sasl_authid_fix = $ldap_sasl_authid
  }
  #notify{"SASL binding to AD as $ldap_sasl_authid":;}

  case $::operatingsystem {
    'centos', 'rhel': {
      case $::operatingsystemmajrelease {
        '6', '7': {
          concat::fragment { "sssd_domain_${name}":
            target  => '/etc/sssd/sssd.conf',
            order   => '05',
            content => template('sssd/domain.erb'),
          }
        } # 6/7
        default: {
          fail('Platform not supported.')
        }
      } # operatingsystemmajrelease
    } # centos, rhel

    'fedora': {
      case $::operatingsystemmajrelease {
        '21', '22': {
          concat::fragment { "sssd_domain_${name}":
            target  => '/etc/sssd/sssd.conf',
            order   => '05',
            content => template('sssd/domain.erb'),
          }
        }
        default: {
          fail('Platform not supported.')
        }
      } # operatingsystemmajrelease
    } # fedora

    'ubuntu': {
      case $::operatingsystemmajrelease {
        /^14\.\d+$/, /^15\.\d+$/: {
          concat::fragment { "sssd_domain_${name}":
            target  => '/etc/sssd/sssd.conf',
            order   => '05',
            content => template('sssd/domain.erb'),
          }
        } # 14
        default: {
          fail('Platform not supported.')
        }
      } # operatingsystemmajrelease
    } # ubuntu

    'debian': {
      case $::operatingsystemmajrelease {
        '7': {
          concat::fragment { "sssd_domain_${name}":
            target  => '/etc/sssd/sssd.conf',
            order   => '05',
            content => template('sssd/domain.erb'),
          }
        } # 7
        default: {
          fail('Platform not supported.')
        } # default
      } # operatingsystemmajrelease
    }

    default: {
      fail('Platform not supported.')
    }
  } # operatingsystem
}

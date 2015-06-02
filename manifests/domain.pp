define sssd::domain (

  $debug_level              = undef,
  $dyndns_update              = false,
  $autofs_debug_level       = undef,
  $krb_use_fast             = undef,
  $ldap_sasl_authid         = undef,
  $krb5_renewable_lifetime  = undef,
  $krb5_renew_interval 	      = undef,
  $entry_cache_autofs_timeout = undef,
  $autofs_provider            = undef,
  $ldap_autofs_search_base    = undef,
  $ldap_autofs_map_object_class   = undef,
  $ldap_autofs_entry_object_class = undef,
  $ldap_autofs_map_name       = undef,
  $ldap_autofs_entry_key      = undef,
  $ldap_autofs_entry_value    = undef,
  $id_provider                = undef, # required
  $auth_provider              = undef, # required
  $cache_credentials          = undef,
  $access_provider            = undef,
  $ldap_access_filter         = undef,
  $ldap_id_mapping            = undef, # required
  $min_id                     = undef,
  $max_id                     = undef,
  $use_fqdn                   = undef,
  $ldap_use_tokengroups       = undef, # for murmurhash3, not POSIX GIDs
  $ldap_id_use_start_tls      = undef,
  $ldap_sasl_mech             = undef,
  $ldap_access_order          = undef,
  $ldap_account_expire_policy = undef,
  $ldap_schema                = undef,
  ) {

  #notify{"SASL binding to AD as $ldap_sasl_authid":;}

  case $::operatingsystem {
    centos, rhel: {
      case $::operatingsystemmajrelease {
        6, 7: {
          concat::fragment { "sssd_domain_${name}":
            target  => '/etc/sssd/sssd.conf',
            order   => 05,
            content => template("sssd/domain.erb"),
          }
        } # 6/7
        default: {
          fail('Platform not supported.')
        }
      } # operatingsystemmajrelease
    } # centos, rhel

    fedora: {
      case $::operatingsystemmajrelease {
        21: {
          concat::fragment { "sssd_domain_${name}":
            target  => '/etc/sssd/sssd.conf',
            order   => 05,
            content => template("sssd/domain.erb"),
          }
        } # 21
        default: {
          fail('Platform not supported.')
        }
      } # operatingsystemmajrelease
    } # fedora

    ubuntu: {
      case $::operatingsystemmajrelease {
        14: {
          concat::fragment { "sssd_domain_${name}":
            target  => '/etc/sssd/sssd.conf',
            order   => 05,
            content => template('sssd/domain.erb'),
          }
        } # 14
        default: {
          fail('Platform not supported.')
        }
      } # operatingsystemmajrelease
    } # ubuntu

    debian: {
      case $::operatingsystemmajrelease {
        7: {
          concat::fragment { "sssd_domain_${name}":
            target  => '/etc/sssd/sssd.conf',
            order   => 05,
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

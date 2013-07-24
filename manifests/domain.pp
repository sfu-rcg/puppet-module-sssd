define sssd::domain (
  $debug_level		    = '5',
  $krb_use_fast		    = 'try',

  # Samba insists on using uppercase for the hostname when joining AD.
  # Convert to uppercase or SSSD will complain principal machine$@AD.SFU.CA
  # can't be found in keytab. Thanks, Riley!
  $ldap_sasl_authid = inline_template("<%= hostname.upcase %>\$@AD.SFU.CA"),


  # don't use units EVER; assume seconds
  # units will confuse authconfig on CentOS 6
  $krb5_renewable_lifetime    = '86400',
  $krb5_renew_interval 	      = '1800',
  $entry_cache_autofs_timeout = '600',
  $autofs_provider            = 'ldap',
  $ldap_autofs_search_base    = '',
  $ldap_autofs_map_object_class   = 'nisMap',
  $ldap_autofs_entry_object_class = 'nisObject',
  $ldap_autofs_map_name       = 'cn',
  $ldap_autofs_entry_key      = 'nisMapName',
  $ldap_autofs_entry_value    = 'nisMapEntry',  
) {

#notify{"SASL binding to AD as $ldap_sasl_authid":;}

concat::fragment { "sssd_domain_${name}":
    target  => '/etc/sssd/sssd.conf',
    order   => 05,
    content => template('sssd/domain.erb'),
  }
}

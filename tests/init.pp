class { 'sssd':
  domains => ['example'],
  services => ['nss', 'pam', 'autofs'],
}

sssd::domain{ 'default':
  ldap_autofs_search_base => 'cn=automount,dc=ad,dc=example,dc=com',
  debug_level              => '3',
  krb_use_fast             => 'try',
  ldap_sasl_authid         => 'foo'
  krb5_renewable_lifetime  => '24h',
  krb5_renew_interval      => '6h',
  autofs_provider          => 'ldap',
  ldap_autofs_search_base  => '',
  ldap_autofs_map_object_class   => 'nisMap',
  ldap_autofs_entry_object_class => 'nisObject',
  ldap_autofs_map_name     => 'cn',
  ldap_autofs_entry_key    => 'nisMapName',
  ldap_autofs_entry_value  => 'nisMapEntry',
}

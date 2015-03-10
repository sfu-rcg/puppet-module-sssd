
class sssd::domains(
  $domains = {},
  $defaults = {},
  ) {
  create_resources(domain, $domains, $defaults)
}

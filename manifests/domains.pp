
class sssd::domains(
  $domains = {},
  $defaults = {},
  ) {
  create_resources(sssd::domain, $domains, $defaults)
}

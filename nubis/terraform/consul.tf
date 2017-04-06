# Discover Consul settings
module "consul" {
  source       = "github.com/nubisproject/nubis-terraform//consul?ref=v1.4.0"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
}

# Configure our Consul provider, module can't do it for us
provider "consul" {
  address    = "${module.consul.address}"
  scheme     = "${module.consul.scheme}"
  datacenter = "${module.consul.datacenter}"
}

# Publish our outputs into Consul for our application to consume
resource "consul_keys" "config" {
  key {
    name   = "environment"
    path   = "${module.consul.config_prefix}/ENVIRONMENT"
    value  = "${var.environment}"
    delete = true
  }

  key {
    name   = "db_name"
    path   = "${module.consul.config_prefix}/DB_NAME"
    value  = "${module.database.name}"
    delete = true
  }

  key {
    name   = "db_server"
    path   = "${module.consul.config_prefix}/DB_SERVER"
    value  = "${module.database.address}"
    delete = true
  }

  key {
    name   = "db_username"
    path   = "${module.consul.config_prefix}/DB_USERNAME"
    value  = "${module.database.username}"
    delete = true
  }

  key {
    name   = "db_password"
    path   = "${module.consul.config_prefix}/DB_PASSWORD"
    value  = "${module.database.password}"
    delete = true
  }

  key {
    name   = "site_url"
    path   = "${module.consul.config_prefix}/SITE_URL"
    value  = "https://${module.dns.fqdn}"
    delete = true
  }
}

config {
  module = true
  varfile = ["variables.tf", "terraform.tfvars"]
}

plugin "azurerm" {
    enabled = true
}

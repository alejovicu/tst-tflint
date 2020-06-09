module "the_module" {
  source = "./modules/just_a_module"
  location = "westus"
  prefix = "tf"
  admin_username = "plankton"
  admin_password = "Password1234!"
}
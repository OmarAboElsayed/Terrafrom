# ------------------credential and config Path------------

provider "aws" {
  shared_config_files      = ["~/config"]
  shared_credentials_files = ["~/cred"]
  profile                  = "default"
}

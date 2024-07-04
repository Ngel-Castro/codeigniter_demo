terraform {
  backend "consul" {
    path    = "statefiles/lxc-codeigniter"
    scheme  = "http"
  }
}
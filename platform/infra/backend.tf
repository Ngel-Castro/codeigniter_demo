terraform {
  backend "consul" {
    path    = "statefiles/codeigniter"
    scheme  = "http"
  }
}
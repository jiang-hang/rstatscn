.onLoad <- function(libname, pkgname) {
  httr::set_config(config(ssl_verifypeer = FALSE))
}

.onUnload <- function(libpath) {
  httr::reset_config()
}

class dell::openmanage::packages {
  $packages = [ 
  "srvadmin-all", 
  ]
  package { $packages:
    require => Class["dell::openmanage::bootstrap"]
  }
}

class dell::firmware::packages {
  # base reqs for BIOS Upgrades:
  $packages = [ 
  "compat-libstdc++-33",
  "libxml2",
  "dell_ft_install",
  ]
  package { $packages:
    require => Class["dell::openmanage::bootstrap"],
  }
}

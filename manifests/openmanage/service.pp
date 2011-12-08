class dell::openmanage::service {
  service {
    "srvadmin-services.sh":
      provider   => "init",
      path       => "/opt/dell/srvadmin/sbin",
      ensure     => "true",
      hasrestart => "true",
      hasstatus  => "true",
      require    => Class["dell::openmanage::packages"],
  }
}

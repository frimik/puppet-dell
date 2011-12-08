class dell::openmanage::bootstrap {
  exec {'openmanage-bootstrap':
    command => "wget -q -O - ${dell::openmanage::params::bootstrapurl} | bash",
    path => "/sbin:/bin:/usr/sbin:/usr/bin",
    unless  => "test -e /etc/yum.repos.d/dell-omsa-repository.repo",
    before  => Class["dell::openmanage::packages"],
  }
}

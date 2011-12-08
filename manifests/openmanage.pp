class dell::openmanage {
    include dell::openmanage::params
    include dell::openmanage::bootstrap
    include dell::openmanage::packages
    include dell::openmanage::service
}


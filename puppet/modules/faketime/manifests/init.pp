class faketime($javaHome) {

    file { "/tmp/faketime.tar.gz" :
        source => "puppet:///modules/faketime/faketime.tar.gz",
        ensure => "present",
    }

    exec { "recreateWorkingDirectory":
        command => "rm -rf /tmp/jvmfaketime; mkdir /tmp/jvmfaketime;",
        require => File["/tmp/faketime.tar.gz"],
    }

    exec { "unTarFakeTime" :
        cwd => "/tmp/jvmfaketime",
        command => "tar -xvf /tmp/faketime.tar.gz",
        require => Exec["recreateWorkingDirectory"],
    }

    exec { "install-faketime" :
        cwd => "/tmp/jvmfaketime/faketime",
        command => "cp -f rt.jar $javaHome/jre/lib; cp -f libjvmfaketime.so $javaHome/jre/lib",
        require => Exec["unTarFakeTime"],
    }
}

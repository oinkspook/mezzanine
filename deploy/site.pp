#puppet essential... 
group { 'puppet': ensure => 'present' }

#global path def.
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] } 

require mezza

class users {
  # sets up the user sanoma + home directory
  # Generating the password using mkpasswd didn't fully work yet.
  # TODO: fix this
  $password = 'devops'

  user { "sanoma":
    ensure => "present",
    password => '$6$mCkTeosb$2boK8BTSmBF/h.rv9QOFT5SCPOddCaDmONU2Nd0aRUGFD2pzMzezAiBZcbt7xEQ.jJ0/mhJbV2wE8GzLfpqsj/',
    #password => generate('/bin/sh', '-c', "mkpasswd -m sha-512 ${password} | tr -d '\n'"),
    shell => "/bin/bash",
    home => '/home/sanoma',
    managehome => true,
  }
}

class yums {
  # Already installed in the image being used: apache, sqlite3
  # Note, we would want to use expect to generate the sha password.
  package {
    ['expect', 'python-devel', 'mod_wsgi'] :
      ensure => present
  }
}

class pip {
  # sets up all PIP packages, needs all yum packages to be present
  require yums

  exec { "install_python_setuptools":
    user    => "vagrant",
    command => "curl https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py \
                | /usr/bin/sudo python -",
  }
  ->
  exec { "install_pip":
    user    => "vagrant",
    command => "curl https://raw.github.com/pypa/pip/master/contrib/get-pip.py | /usr/bin/sudo python -",
  }
  ->
  # pillow was missing, it caused mezzanine to land in a hard way
  exec { "install_pillow":
    user    => "vagrant",
    command => "/usr/bin/sudo pip install pillow",
  }
  ->
  # TODO: fix that Unicode problem which is caused by the mezzanine code on the sanoma account.
  exec { "install_mezzanine":
    user    => "vagrant",
    #command => "/usr/bin/sudo pip install https://github.com/sanoma-nl/mezzanine.git",
    command => "/usr/bin/sudo pip install mezzanine",
  }
}

class mezza {
  require users
  require pip

  # creating the mezzanine project [instance]
  exec { "init_project":
    user    => "sanoma",
    cwd     => "/home/sanoma/",
    command => "mezzanine-project mezza",
  }
  ->
  # updating the main config files, changing sqlite file and setting debug to false,
  # and allowing all hosts to use the mezzanine service
  exec { "conf_project":
    user    => "sanoma",
    cwd     => "/home/sanoma/",
    command => 'perl -pi -e "s/(\"NAME\":\s+\")\S+(\.db\")/\${1}mezza\${2}/;
                             s/(DEBUG\s*=).*$/\$1 False/;
                             s/(ALLOWED_HOSTS\s*=\s*\[).*?(\])/\$1 \'\*\' \$2/;
                            " mezza/*settings.py',
  }
  ->
  # generating a [default] sqlite database
  exec { "create_db":
    user    => "sanoma",
    cwd     => "/home/sanoma/mezza/",
    command => "python manage.py createdb --noinput",
  }
  ->
  # TODO: In a later stage, we should rewrite the below code to start a service, 
  # which firstly needs to be defined with a start/stop script etc.
  exec { "run_server":
    user    => "sanoma",
    cwd     => "/home/sanoma/mezza/",
    # The IP:Port combination allows us to access the site remotely.
    command => "python manage.py runserver 0.0.0.0:8000 &",
  }
}


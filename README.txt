Install instructions:

1. Make sure you have git and vagrant installed on your machine.
2. Run 'git clone https://github.com/oinkspook/mezzanine.git'.
3. Run 'cd mezzanine'.
4. Run 'vagrant up'.
5. Point your browser to: 'http://localhost:8080/' or 'http://localhost:8080/admin/'
6. Optionally run 'vagrant ssh' to login to the virtual machine.

TODO:

1. We can generate the sha encrypred SHA from the real password using mkpasswd.
2. We are actually installing the default mezzanine package, not the one pre-packaged by Sanoma.
   This is because the Sanoma package was initially refusing to be installed, with Unicode
   error messages. Possibly a version problem, we had an old 2.6 python installed on the image.
3. We might want to pre-package the settings files from mezzanine, however there could be
   version dependent changes in the future, in which case patching, as is, would be better.
4. We are using a hack to get the site visible (using IP 0.0.0.0), but we might go a little
   more official and put the application behind an already installed webserver.
5. We might want to install the application as a system service.
6. Using modules, this project was done a little ad-hoc, and as it is now it is not too scalable.


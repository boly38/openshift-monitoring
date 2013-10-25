OpenShift Monitor

==Description==
Use case automatise :
- creation d'une application php
- curl sur l'appli
- ssh
- tail
- commit et push d'un phpinfo
- curl sur phpinfo
- destruction de l'appli


==Installation==
vm Ubuntu 12.04
- (optionnel) position du proxy dans /etc/apt/apt.conf
- install git
- installation de rvm et ruby 2.0.0
- suppression du .bash_profile cree par rvm et ajout d'un ~/.bash_aliases (avec la ligne de chargement rvm)
- ajout d'option ssh pour le domaine openshift dans ~/.ssh/config : StrictHostKeyChecking no / IdentityFile /home/ubuntu/.ssh/id_rsa / IdentitiesOnly yes
- dependances :
  - lib/timeout3 : http://www.bashcookbook.com/bashinfo/source/bash-4.0/examples/scripts/timeout3

==Utilisation==
 ./usecase_metier/openshift_samplephp.sh <--no-color>

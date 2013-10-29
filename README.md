OpenShift Monitor

Description
------------
Use case automatise :
- creation d'une application php
- curl sur l'appli
- ssh
- tail
- commit et push d'un phpinfo
- curl sur phpinfo
- destruction de l'appli


Installation
------------
vm Ubuntu 12.04
- (optionnel) position du proxy dans /etc/apt/apt.conf
- install git
- installation de rvm et ruby 2.0.0
- suppression du .bash_profile cree par rvm et ajout d'un ~/.bash_aliases (avec la ligne de chargement rvm)
- ajout d'option ssh pour le domaine openshift dans ~/.ssh/config : StrictHostKeyChecking no / IdentityFile /home/ubuntu/.ssh/id_rsa / IdentitiesOnly yes
- dependances :
  - lib/timeout3 : http://www.bashcookbook.com/bashinfo/source/bash-4.0/examples/scripts/timeout3
- install apache2 (rendre default /var/www disponible)
<pre>
 sudo apt-get install apache2
</pre>

- install du cron

<pre>
 crontab -e

# openshift monitor toutes les heures
0 */1 * * * /home/ubuntu/openshift-monitoring/openshiftMonitor/cron_apache_openshift_usecase

</pre>


- premiere fois :
<pre>
        gem install rhc
        rhc setup --server broker.myopenshift.fr
        rhc account logout
</pre>
- add password to .openshift/express.conf https://www.openshift.com/kb/kb-e1067-running-rhc-commands-without-re-entering-password


- adaptez <code>openshiftMonitor/usecase_metier/uc_openshift_samplephp.sh</code> à votre configuration

- sur le broker ajouter le user openshift-monitor avec le domaine "monitor" et limiter son nombre de gear :
<pre>
        oo-admin-ctl-user -l openshift-monitor --setmaxgears 3
</pre>


#!/bin/bash
############################################################
############################################################
# 					Compatibilité système		 		   #
############################################################
############################################################

# ----------------------------------------------------------
# [Pour Comparer votre version d'OS à
#  celles mentionnées ci-dessous]
# 
# ¤ distributions Ubuntu:
#		lsb_release -a
#
# ¤ distributions CentOS:
# 		cat /etc/redhat-release
# 
# 
# ----------------------------------------------------------

# ----------------------------------------------------------
# testé pour:
# 
# 
# 
# 
# ----------------------------------------------------------
# (Ubuntu)
# ----------------------------------------------------------
# 
# ¤ [TEST-OK]
#
# 	[Distribution ID: 	Ubuntu]
# 	[Description: 		Ubuntu 16.04 LTS]
# 	[Release: 			16.04]
# 	[codename:			xenial]
# 
# 
# 
# 
# 
# 
# ----------------------------------------------------------
# (CentOS)
# ----------------------------------------------------------
# 
# 
# 
# ...
# ----------------------------------------------------------


######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -#
######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -#
# - 
# - Environnement hérité
# - 
# 
# export MAISON
# export NOM_CONTENEUR_TOMCAT
# export NOM_CONTENEUR_SGBDR

# export ADRESSE_IP_SRV_JEE
# NUMERO_PORT_SRV_JEE=$SAISIE_NUMERO_PORT_SRV_JEE
# export NUMERO_PORT_SRV_JEE

# ADRESSE_IP_SGBDR=$ADRESSE_IP_SRV_JEE
# export ADRESSE_IP_SGBDR
# NUMERO_PORT_SGBDR=$SAISIE_NUMERO_PORT_SGBDR
# export NUMERO_PORT_SGBDR

# export DB_MGMT_USER_NAME
# export DB_MGMT_USER_PWD

# export DB_APP_USER_NAME
# export DB_APP_USER_PWD


# export NOM_REPO_GIT_ASSISTANT_DEPLOYEUR_MVN_PLUGIN
# export URL_REPO_GIT_ASSISTANT_DEPLOYEUR_MVN_PLUGIN

# export MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME
# export MVN_PLUGIN_OPERATEUR_LINUX_USER_PWD

# MAISON=`pwd`

# NOM_CONTENEUR_TOMCAT=ciblededeploiement-composant-srv-jee
# NOM_CONTENEUR_SGBDR=ciblededeploiement-composant-sgbdr

# ADRESSE_IP_SRV_JEE=192.168.1.63
# NUMERO_PORT_SRV_JEE=8888

# ADRESSE_IP_SGBDR=192.168.1.63
# NUMERO_PORT_SGBDR=3308

# DB_MGMT_USER_NAME=jean
# DB_MGMT_USER_PWD=jean

# DB_APP_USER_NAME=appli1-de-jean
# DB_APP_USER_PWD=mdp@ppli1-je@n


############################################################
# # l'utilisateur linux qui fera office d'opérateur
# # pour le compte du plugin maven "fullstack-maven-plugin"
# # cet utilisateur devrait être différent de celui utilisé
# # pour construire la cible de déploiement. Il devrait de 
# # plus être inexistant avant, et créé pour le
# # comissionning de la cible de déploiement.
# MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME=jean
# MVN_PLUGIN_OPERATEUR_LINUX_USER_PWD=jean
# # le repo git qui assistera le
# # plugin maven "fullstack-maven-plugin"
# NOM_REPO_GIT_ASSISTANT_DEPLOYEUR_MVN_PLUGIN=assistant-deploiements-appli1
# URL_REPO_GIT_ASSISTANT_DEPLOYEUR_MVN_PLUGIN=https://github.com/Jean-Baptiste-Lasselle/assistant-deploiements-appli1.git



############################################################
############################################################
#				déclarations des fonctions				   #
############################################################
############################################################


# ---------------------------------------------------------
# [description]
# ---------------------------------------------------------
# Cette fonction permet de donner des valeurs aux variables
# d'environnement:
#		¤ {NOM_CONTENEUR_TOMCAT} 	
#		¤ {NUMERO_PORT_SRV_JEE} 	--no-port-srv-jee
#		¤ {NUMERO_PORT_SGBDR} 		--no-port-sgbdr
# 
# Et ce, en procédant de la manière suivante:
#  - si ce script est invoqué avec l'option 
#    "--all-defaults", alors toutes les variables
#    d'environnement prennent leur valeur par défaut.
#  - si ce script est invoqué avec l'option "--ask-me",
#    et l'option "--all-defaults", alors message d'erreur
#  - si ce script est invoqué avec l'option "--ask-me",
#    alors les valeurs des variables d'environnement pour
#    lesquelles aucune option silencieuse n'a été utilisée
#    sont demandées interactivement.
#  - Pour chaque variable, sauf NOM_CONTENEUR_TOMCAT:
#		¤ une option silencieuse est utilisable, pour attribuer une valeur 
#		¤ si l'option silencieuse n'est pas utilisée, la valeur par défaut est appliquée si et ssi l'option --ask-me n'a pas été utilisée
# ---------------------------------------------------------
# [signature]
# ---------------------------------------------------------
#
# 	Cette fonction s'invoque sans aucun argument
#
# ---------------------------------------------------------


# traiter_args () {



# }



############################################################
############################################################
#					exécution des opérations			   #
############################################################
############################################################



# Injection des valeurs dans les opérations standards
sed -i "s/VALEUR_ADRESSE_IP_SRV_JEE/$ADRESSE_IP_SRV_JEE/g" $MAISON/application-1/srv-jee/tomcat/deployer-appli-web.sh
sed -i "s/VALEUR_NUMERO_PORT_SRV_JEE/$NUMERO_PORT_SRV_JEE/g" $MAISON/application-1/srv-jee/tomcat/deployer-appli-web.sh

sed -i "s/VALEUR_ADRESSE_IP_SGBDR/$ADRESSE_IP_SGBDR/g" $MAISON/application-1/srv-jee/tomcat/deployer-appli-web.sh
sed -i "s/VALEUR_NUMERO_PORT_SGBDR/$NUMERO_PORT_SGBDR/g" $MAISON/application-1/srv-jee/tomcat/deployer-appli-web.sh

# générer le fichier my.cnf avec la variable VALEUR_ADRESSE_IP_SRV_JEE et sed
sed -i "s/VALEUR_ADRESSE_IP_SRV_JEE/$ADRESSE_IP_SRV_JEE/g" $MAISON/application-1/bdd/mariadb/my.cnf



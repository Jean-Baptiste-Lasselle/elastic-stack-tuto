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

############################################################
############################################################
#					variables d'environnement			   #
############################################################
############################################################
# 
# 
# OK, je sais: il faut générer dynamiquement le script de
# déploiement, suite au choix ADRESSE IP et autres paramètres
# 
export NOM_CONTENEUR_TOMCAT=ciblededeploiement-composant-srv-jee
export NOM_FICHIER_WAR_A_DEPLOYER_SANS_EXTENSION=appli-a-deployer-pour-test
export FICHIER_WAR_A_DEPLOYER_PAR_DEFAUT=../$NOM_FICHIER_WAR_A_DEPLOYER_SANS_EXTENSION.war
export FICHIER_WAR_A_DEPLOYER=$FICHIER_WAR_A_DEPLOYER_PAR_DEFAUT
# 
# valeurs injectées automatiquement...
# 
export ADRESSE_IP_SRV_JEE=VALEUR_ADRESSE_IP_SRV_JEE
export NUMERO_PORT_SRV_JEE=VALEUR_NUMERO_PORT_SRV_JEE
# 
export ADRESSE_IP_SGBDR=VALEUR_ADRESSE_IP_SGBDR
export NUMERO_PORT_SGBDR=VALEUR_NUMERO_PORT_SGBDR
# 
############################################################
############################################################
#				déclarations des fonctions				   #
############################################################
############################################################

# ---------------------------------------------------------
# [description]
# ---------------------------------------------------------
# Cette fonction permet d'afficher un premier message explicatif.
afficher_message_presentation_initiale () {
	echo "Il se peut";
	echo "";
}

afficher_message_prerequis () {
	echo "Votre machine Virtuelle ";
	echo "laquelle vous allez expérimenter, de";
	echo "manière à rendre le déroulement de vos opérations le plus confortable possible.";
	echo "Vos expérimentations vont se faire dans une Machine Virtuelle Virtual Box.";
	echo "";
}
# ---------------------------------------------------------
# [description]
# ---------------------------------------------------------
# Cette fonction permet d'attendre que le
# conteneur soit dans l'état healthy
# Cette fonction prend un argument, nécessaire
# sinon une erreur est générée (TODO: à implémenter avec
# exit code)
checkHealth () {
	export ETATCOURANTCONTENEUR=starting
	export ETATCONTENEURPRET=healthy
	export NOM_DU_CONTENEUR_INSPECTE=$1
	
	while  $(echo "+provision+girofle+ $NOM_DU_CONTENEUR_INSPECTE - HEALTHCHECK: [$ETATCOURANTCONTENEUR]">> $NOMFICHIERLOG); do
	
	ETATCOURANTCONTENEUR=$(sudo docker inspect -f '{{json .State.Health.Status}}' $NOM_DU_CONTENEUR_INSPECTE)
	if [ $ETATCOURANTCONTENEUR == "\"healthy\"" ]
	then
		echo " +++provision+ app + elk +  $NOM_DU_CONTENEUR_INSPECTE est prêt - HEALTHCHECK: [$ETATCOURANTCONTENEUR]">> $NOMFICHIERLOG
		break;
	else
		echo " +++provision+ app + elk +  $NOM_DU_CONTENEUR_INSPECTE n'est pas prêt - HEALTHCHECK: [$ETATCOURANTCONTENEUR] - attente d'une seconde avant prochain HealthCheck - ">> $NOMFICHIERLOG
		sleep 1s
	fi
	done	
}
# ---------------------------------------------------------
# [description]
# ---------------------------------------------------------
# Cette fonction permet de configurer une ip statique 
# pour la machine.
# 
# Afin de décider quel interface réseau linux sera
# utilisé, cette fonction procède de la manière suivante:
# 
#  - si aucun argument n'est passé à cette fonction, alors 
#    ce script demande à l'utilisateur de spécifier un
#    nom d'interface réseau linux.
#  - si l'utilisateur ne fournit aucun nom d'interface
#    réseau linux (il a simplement pressé la touche Entrée),
#    le nom de l'interface par défaut sera utilisé, soit
#    "$NOM_INTERFACE_RESEAU_A_RECONFIGURER_PAR_DEFAUT".
#  - si un argument et un seul argument est passé
#    à cette fonction, alors le premier argument passé sera
#    le nom d'interface utilisé.
#  - si plus d'un argument est passé, alors seule la
#    première valeur passée en argument sera utilisée
#    comme expliqué par les 3 points précédents.
#    Les autres valeurs passées seront ignorées.
# ---------------------------------------------------------
# [signature]
# ---------------------------------------------------------
#
# 	$1 => le nom de l'interface réseau linux à 
#         re-configurer.
#
# ---------------------------------------------------------


determiner_war_a_deployer () {

# Gestion des valeurs passées en paramètre
# ----------------------------------------

NBARGS=$#
clear
if [ $NBARGS -eq 0 ]
then
	echo "Quel est le chemin du fichier de l'artefact war à déployer?"
	echo "(Par défaut l'artefact [$FICHIER_WAR_A_DEPLOYER] sera déployé"
	read SAISIE_UTILISATEUR_NOMWAR
else
	FICHIER_WAR_A_DEPLOYER=$1
fi

if [ "x$SAISIE_UTILISATEUR_NOMWAR" = "x"  ]
then
	echo "on laisse la valeur par défaut"
else
	FICHIER_WAR_A_DEPLOYER=$SAISIE_UTILISATEUR_NOMWAR
fi

# confirmation nom interface réseau linux à reconfigurer 
clear
echo "Vous confirmez vouloir déployer l'artefact : [$FICHIER_WAR_A_DEPLOYER] ?"
echo "Répondez par Oui ou Non (o/n). Répondre Non annulera le déploiement."
read VOUSCONFIRMEZ
case "$VOUSCONFIRMEZ" in
	[oO] | [oO][uU][iI]) echo "L'artefact [$FICHIER_WAR_A_DEPLOYER] va être déployé" ;;
	[nN] | [nN][oO][nN]) echo "Déploiement annulé.";exit ;;
esac

}










############################################################
############################################################
#					exécution des opérations			   #
############################################################
############################################################



# construction d'un conteneur tomcat 
clear
echo "Quand tu appuieras sur Entrée, attends quelque secondes, et ton serveur tomcat sera accessible à:"
echo "		http://adressIP-detaVM:8888/"
echo "Quand tu veux."
read
# docker run -it --name ciblededeploiement --rm -p 8888:8080 tomcat:8.0
# http://adressIP:8888/


determiner_war_a_deployer $1


# clear
# echo POIN DEBUG FIN
# echo "verif valeur [ADRESSE_IP_SRV_JEE=$ADRESSE_IP_SRV_JEE]"
# echo "verif valeur [NUMERO_PORT_SRV_JEE=$NUMERO_PORT_SRV_JEE]"
# echo "verif valeur [NUMERO_PORT_SGBDR=$NUMERO_PORT_SGBDR]"
# read
checkHealth $NOM_CONTENEUR_TOMCAT
clear
echo " --  "
echo " --  DEBUT DEPLOIEMENT --- "
echo " --  "
docker cp $FICHIER_WAR_A_DEPLOYER $NOM_CONTENEUR_TOMCAT:/usr/local/tomcat/webapps
docker restart $NOM_CONTENEUR_TOMCAT
checkHealth $NOM_CONTENEUR_TOMCAT
echo " --  "
echo " --  DEPLOIEMENT TERMINE --- "
echo " --  "
echo " 						"
echo " Votre SGBDR est accessible par votre client SQL : "
echo " 						=> à l'adresse			[$ADRESSE_IP_SGBDR]"
echo " 						=> au nméro de port		[$NUMERO_PORT_SGBDR]"
echo " --  "
echo " Votre application est disponible à l'URL: "
echo " 						http://$ADRESSE_IP_SRV_JEE:$NUMERO_PORT_SRV_JEE/$NOM_FICHIER_WAR_A_DEPLOYER_SANS_EXTENSION"
echo " --  "
# echo " Exécutez les commandes: "
# echo "   firefox http://localhost:$NUMERO_PORT_SRV_JEE/$NOM_FICHIER_WAR_A_DEPLOYER_SANS_EXTENSION"
# echo "   firefox http://$ADRESSE_IP_SRV_JEE:$NUMERO_PORT_SRV_JEE/$NOM_FICHIER_WAR_A_DEPLOYER_SANS_EXTENSION"



#!/bin/bash
# ----------------------------------------------------------------------------------------------------------------------
# 

######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -
######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -
# - 
# - Environnement hérité
# - 
# 
# export NOM_CONTENEUR_ELK1=conteneur-elk-jibl
# -----------------------------------------------------------------------------------------------------------------------



# -----------------------------------------------------------------------------------------------------------------------
# opérations
# -----------------------------------------------------------------------------------------------------------------------
#

# Attention, ceci est une exécution interactive: la commande attendra une arrivée de données sur l'entrée standard
# export NOM_CONTENEUR_ELK1=conteneur-elk-jibl
sudo docker exec $NOM_CONTENEUR_ELK1 /bin/bash -c "/opt/logstash/bin/logstash --path.data /tmp/logstash/data -e 'input { stdin { } } output { elasticsearch { hosts => [\"localhost\"] } }'"

# /opt/logstash/bin/logstash --path.data /tmp/logstash/data -e 'input { stdin { } } output { elasticsearch { hosts => ["localhost"] } }'
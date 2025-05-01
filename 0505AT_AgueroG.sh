#!/bin/bash
# Autor: Gregorio Agüero
# Fecha: 01/05/25
# Script de despliegue automático para el trabajo 0311AT - Computación en la Nube
# Nombre de archivo: 0505AT_AgueroG.sh

set -e
set -o pipefail

# ========= CONFIGURACIÓN =========
PROFILE="0311at"
STATIC_REPO="https://github.com/GrekAG/static-website"
MANIFESTS_REPO="https://github.com/GrekAG/kubernetes-manifests"
MOUNT_PATH="/mnt/web"
LOCAL_PATH="$HOME/static-website"

# ========= VALIDAR DEPENDENCIAS =========
for cmd in git minikube kubectl; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: '$cmd' no está instalado."
        exit 1
    fi
done

# ========= CLONAR REPOSITORIOS =========
echo "Clonando repositorios..."
[ ! -d "$LOCAL_PATH" ] && git clone "$STATIC_REPO" "$LOCAL_PATH"
[ ! -d "$HOME/kubernetes-manifests" ] && git clone "$MANIFESTS_REPO" "$HOME/kubernetes-manifests"

# ========= INICIAR MINIKUBE Y MONTAR =========
echo "Iniciando Minikube con perfil '$PROFILE'..."
minikube delete -p "$PROFILE" 2>/dev/null || true
minikube start -p "$PROFILE" --driver=docker

echo "Montando $LOCAL_PATH en $MOUNT_PATH (en background)..."
#Si usa windows cambiar este fragmento por el siguiente:
#nohup minikube -p "$PROFILE" mount "C:/ruta/del/static-website:$MOUNT_PATH" &> /tmp/minikube-mount.log & 
nohup minikube -p "$PROFILE" mount "$LOCAL_PATH:$MOUNT_PATH" &> /tmp/minikube-mount.log &

# ========= APLICAR MANIFIESTOS =========
echo "Aplicando manifiestos..."
cd "$HOME/kubernetes-manifests"
kubectl apply -f volumen/
kubectl apply -f despliegue/
kubectl apply -f servicio/

# ========= ESPERAR A QUE LOS PODS ESTÉN LISTOS =========
echo "Esperando a que los pods estén en estado Running..."
for i in $(seq 1 12); do
    STATUS=$(kubectl get pods -l app=web-static -o jsonpath="{.items[*].status.phase}" 2>/dev/null || echo "")
    if [[ "$STATUS" == *Running* ]]; then
        echo "Pods en Running: $STATUS"
        break
    fi
    echo "Intento $i/12: pods aún no listos ($STATUS). Esperando 5s..."
    sleep 5
    if [[ $i -eq 12 ]]; then
        echo "Error: los pods no entraron en Running después de 1 min."
        kubectl get pods
        exit 1
    fi
 done

# ========= VERIFICAR =========
echo "Verificando recursos..."
kubectl get pv
kubectl get pvc
kubectl get pods

# ========= ACCEDER A LA APP AUTOMÁTICAMENTE =========
echo "Abriendo el servicio web-static-service en Minikube..."
minikube -p "$PROFILE" service web-static-service

exit 0


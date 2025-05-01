## ⚠️ Aviso para usar el script en Windows

Devido a que estos comandos estan pensados para ejecutarse en Linux tendra que modificar la linea 38 del archivo `0505AT`:
```
nohup minikube -p "$PROFILE" mount "$LOCAL_PATH:$MOUNT_PATH" &> /tmp/minikube-mount.log &
```
--
                            Remplace el fragmento "$LOCAL_PATH"⤴️
                            Por la ruta de la carpeta⤵️  Generalmete es: C:\Users\usuario\static-website
```
nohup minikube -p "$PROFILE" mount "C:/ruta/del/static-website:$MOUNT_PATH" &> /tmp/minikube-mount.log &
```

## 🧱 Estructura del Proyecto

```
0311at/
│
├── static-website/             # Contenido HTML/CSS
└── kubernetes-manifests/
    ├── volumen/            # Manifiestos de PV y PVC
    ├── despliegue/         # Deployment de la app con nginx
    └── servicio/           # Service tipo NodePort para exponer la app
```

---

## ⚙️ Requisitos Previos

- [Minikube](https://minikube.sigs.k8s.io/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Git](https://git-scm.com/)
- Cuenta de [GitHub](https://github.com/)

---

## 🛠 Pasos para Reproducir el Entorno

### 1. Clonar los Repositorios

```bash
git clone https://github.com/GrekAG/static-website
git clone https://github.com/GrekAG/kubernetes-manifests
```

---

### 2. Iniciar Minikube

```bash
minikube start -p 0311at
minikube -p 0311at mount "C:/carpeta/donde/clonaste/el/static-website:/mnt/web"
mantener el CMD abierto
```

### 3. Aplicar los manifiestos

Desde el directorio raíz de `kubernetes-manifests`, ejecutar:

```bash
kubectl apply -f volumen/
kubectl apply -f despliegue/
kubectl apply -f servicio/
```

---

### 4. Verificar que todo funcione

```bash
kubectl get pv
kubectl get pvc
```

---

### 5. Acceder a la aplicación

```bash
minikube -p 0311at service web-static-service
```

Se abrirá en el navegador una URL local (por ejemplo, http://127.0.0.1:30080) con tu sitio web personalizado.

---

## 📦 Tecnologías Utilizadas

- HTML + CSS (contenido web)
- Kubernetes (Deployment, PV, PVC, Service)
- Minikube (clúster local)
- Git y GitHub (control de versiones)

---

## 🧠 Autor

Gregorio Agüero
[GitHub](https://github.com/GrekAG)

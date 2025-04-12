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
git clone https://github.com/GrekAG/pagina-web
git clone https://github.com/GrekAG/manifiestos-kubernetes.git
```

---

### 2. Iniciar Minikube

```bash
minikube start -p 0311at
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
kubectl get pods
kubectl get svc
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

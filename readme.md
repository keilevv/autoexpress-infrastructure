# Instrucciones
Saludos! Aquí le dejo un par de instrucciones sobre como desplegar la infraestructura planteada para la tarea hasta el punto que lo llevamos. 

Decidimos hacerlo con DigitalOcean porque es el proveedor que escogimos para desarrollar nuestro proyecto más adelante.

## Instalación


Una vez se encuentre en la carpeta raiz del documento, ingrese su API Key de DigitalOcean en el archivo terraform.tfvars


```bash
do_token = "su_api_key"
```
Y luego ejecute 

```bash
terraform init
```

Una vez instalado terraform, puede proceder a ejecutar el script con 

```bash
terraform apply -auto-approve
```
# AVISO IMPORTANTE

Si ocurre un error y rechaza la conexión por ssh, esperar un momento y volver a ejecutar terraform apply.
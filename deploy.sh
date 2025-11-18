#!/bin/bash

# =======================================================
# SCRIPT DE AUTOMATIZACIÓN DE DESPLIEGUE DE WORDPRESS EN DOCKER
# =======================================================

echo "Iniciando la automatización del despliegue de WordPress con Docker Compose..."

# -------------------------------------------------------
# 1. VERIFICACIÓN DE REQUISITOS
# -------------------------------------------------------
echo "1. Verificando la instalación de Docker y Docker Compose..."

# Función para verificar si un comando existe
check_dependency() {
    if ! command -v "$1" &> /dev/null
    then
        echo "Error: La dependencia '$1' no se encontró."
        echo "Por favor, asegúrese de que Docker Desktop o Docker Engine esté instalado y accesible en su PATH."
        exit 1
    fi
}

check_dependency docker
check_dependency docker-compose # o docker compose si usa versiones recientes

echo "Requisitos (Docker/Compose) verificados correctamente. El entorno está listo."

# -------------------------------------------------------
# 2. LIMPIEZA Y PULL DE IMÁGENES (Opcional, pero recomendado)
# -------------------------------------------------------
echo "2. Deteniendo y limpiando contenedores previos (manteniendo volúmenes de datos)..."
docker-compose down # Detiene y elimina contenedores, pero no los volúmenes (los datos persistirán)

echo "Descargando las últimas versiones de las imágenes..."
docker-compose pull

# -------------------------------------------------------
# 3. DESPLIEGUE DEL SERVICIO
# -------------------------------------------------------
echo "3. Levantando los servicios (Base de Datos y WordPress)..."
# La bandera -d ejecuta los contenedores en segundo plano
if docker-compose up -d
then
    echo "========================================================="
    echo "🎉 ¡DESPLIEGUE EXITOSO!"
    echo "El servicio WordPress se está ejecutando en http://localhost:8081"
    echo "Para ver los logs, ejecute: docker-compose logs -f"
    echo "========================================================="
else
    echo "❌ ERROR: Falló el comando docker-compose up -d."
    echo "Revise los logs de Docker para más detalles."
    exit 1
fi

# -------------------------------------------------------
# 4. VERIFICACIÓN RÁPIDA (Opcional)
# -------------------------------------------------------
echo "4. Verificación rápida de estado de los contenedores:"
docker-compose ps
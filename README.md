# AWS Banking Transaction Processor Pipeline

Este repositorio contiene la implementación de un sistema automatizado de triaje para transacciones bancarias, diseñado para detectar riesgos y organizar datos de forma eficiente en la nube de AWS.

## 1. Escenario y Lógica de Negocio
El sistema simula un motor de antifraude que procesa transacciones entrantes en formato JSON. El objetivo es automatizar la clasificación de datos sensibles basándose en reglas de seguridad bancaria:

*   **Validación Técnica:** Se asegura de que el monto sea un valor numérico positivo y que los campos obligatorios estén presentes.
*   **Análisis de Riesgo:** Clasifica la transacción como `high` (riesgo alto) si el monto es mayor a **$10,000 USD** o si el país de origen es distinto a **México (MX)**.
*   **Enrutamiento Inteligente:** Separa los archivos físicamente en S3 para que el equipo de cumplimiento pueda revisar solo lo sospechoso de manera prioritaria.

## 2. Arquitectura del Sistema
La solución es 100% **Serverless**, lo que garantiza escalabilidad, alta disponibilidad y bajo costo:

*   **AWS Lambda:** 3 funciones independientes (Validate, RiskAssess, Route) desarrolladas en Python 3.12.
*   **Amazon Step Functions:** Orquestador que maneja el flujo de decisiones y estados de la transacción.
*   **Amazon S3:** Bucket utilizado como almacenamiento final, organizado mediante prefijos dinámicos.
*   **OpenTofu:** Herramienta de Infraestructura como Código (IaC) utilizada para definir y desplegar todos los recursos.

## 3. Requisitos Previos
*   **AWS CLI** configurado con credenciales de AWS Academy (debe incluir el `AWS_SESSION_TOKEN`).
*   **OpenTofu** o **Terraform** instalado localmente (para despliegue manual).
*   Acceso al rol pre-configurado **`LabRole`** en la cuenta de AWS Academy.

## 4. Automatización CI/CD
Este proyecto integra un flujo de trabajo mediante **GitHub Actions**. Al realizar un `push` a la rama `main`, el pipeline realiza automáticamente:
1.  **Init:** Inicializa los proveedores y descarga los módulos necesarios.
2.  **Format Check:** Valida que el código HCL cumpla con los estándares de estilo.
3.  **Plan:** Genera una vista previa de los cambios a realizar en AWS.
4.  **Apply:** Despliega los recursos de forma automática.

## 5. Guía de Uso: Ejecución del Pipeline

Para probar el funcionamiento del sistema desde tu terminal, utiliza los siguientes comandos (asegúrate de tener configurado tu AWS CLI):

### Caso A: Transacción de Riesgo Alto (Se enruta a /review)
```bash
aws stepfunctions start-execution \
  --state-machine-arn "arn:aws:states:us-east-1:845165197545:stateMachine:banking-processor-pipeline" \
  --input '{"transaction_id": "tx-fraud-999", "account": "1234-5678", "amount": 25000.00, "country": "US", "merchant": "UnknownStore"}'
```

### Caso B: Transacción de Riesgo Bajo (Se enruta a /approved)
```bash
aws stepfunctions start-execution \
  --state-machine-arn "arn:aws:states:us-east-1:845165197545:stateMachine:banking-processor-pipeline" \
  --input '{"transaction_id": "tx-ok-123", "account": "4444-5555", "amount": 150.00, "country": "MX", "merchant": "Netflix"}'
```

## 6. Verificación de Resultados
Tras ejecutar los comandos anteriores, puedes verificar la persistencia de los datos en el bucket de S3:
```bash
# Listar todos los archivos procesados
aws s3 ls s3://uag-bigdata-banking-output-emi-v2 --recursive
```

## 7. Mantenimiento
Para destruir la infraestructura y evitar el consumo de créditos del laboratorio:
```bash
tofu destroy -auto-approve
```
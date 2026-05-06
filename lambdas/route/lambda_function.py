import json
import boto3
import os

s3 = boto3.client('s3')

def lambda_handler(event, context):
    # La variable BUCKET_NAME vendrá de la configuración de OpenTofu
    bucket = os.environ.get('BUCKET_NAME')
    risk = event.get('risk_level', 'review')
    tx_id = event.get('transaction_id', 'unknown')
    
    folder = "approved" if risk == "low" else "review"
    file_path = f"{folder}/{tx_id}.json"
    
    # Guardar en S3
    s3.put_object(
        Bucket=bucket,
        Key=file_path,
        Body=json.dumps(event),
        ContentType='application/json'
    )
    
    event['s3_destination'] = f"s3://{bucket}/{file_path}"
    return event
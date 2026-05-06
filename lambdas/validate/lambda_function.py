import json

def lambda_handler(event, context):
    print(f"Validating transaction ID: {event.get('transaction_id')}")
    
    amount = event.get('amount', 0)
    country = event.get('country', "")
    
    # Validación técnica
    if not isinstance(amount, (int, float)) or amount <= 0:
        raise ValueError("Invalid amount: must be positive numeric.")
    
    if len(country) != 2:
        raise ValueError("Invalid country: must be 2-letter ISO code.")

    # Agregamos campo al contrato
    event['validation_status'] = "PASS"
    return event
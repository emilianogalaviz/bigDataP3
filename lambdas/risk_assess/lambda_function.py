import json

def lambda_handler(event, context):
    amount = event.get('amount', 0)
    country = event.get('country', "MX")
    
    # Regla de negocio: Riesgo alto si > 10k o extranjero
    if amount > 10000 or country != "MX":
        risk_level = "high"
    else:
        risk_level = "low"
    
    print(f"Risk level determined: {risk_level}")
    
    # Enriquecemos el evento
    event['risk_level'] = risk_level
    return event
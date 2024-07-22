import secrets 

def generate_secret_key():
    return secrets.token_hex(24)


secrets_key=generate_secret_key()
print(f'Secret Key: {secrets_key}')
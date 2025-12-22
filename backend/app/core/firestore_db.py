import os
from google.cloud import firestore

def get_db():
    key = os.getenv("FIREBASE_ADMIN_KEY")
    if not key:
        raise RuntimeError("FIREBASE_ADMIN_KEY is not set")
    return firestore.Client.from_service_account_json(key)

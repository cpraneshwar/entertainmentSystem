import firebase_admin
from firebase_admin import credentials
from firebaseadmin import messaging


def notify_user(profile):
    if not profile.device_id:
        return

    try:
        cred = credentials.Certificate("serviceAccountKey.json")
        firebase_admin.initialize_app(cred)
        notification = messaging.Notification(title="Entertain Yo'Self", body="Looks like you are free, Earn some rewards while trying something new..) ", image=None)
        message = messaging.Message()
        message = messaging.Message(notification=notification, token=profile.device_id)
        messaging.send(message)
    except Exception:
        pass

    print("User Notified")
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

firebase.initializeApp({
apiKey: "AIzaSyBD97ZeFiIlMgYU4_1UooJcYA6KhIfatQc",
  authDomain: "custom-label-bottle-crm.firebaseapp.com",
  projectId: "custom-label-bottle-crm",
  storageBucket: "custom-label-bottle-crm.firebasestorage.app",
  messagingSenderId: "1023430264697",
  appId: "1:1023430264697:web:7a5ae54f0ebbad87d391a8",
  measurementId: "G-MQ75JJ8HJF"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log("[firebase-messaging-sw.js] Background message", payload);

  // Data-only payload (preferred to prevent duplicates)
  const title =
    payload.data?.title ||
    payload.notification?.title || // fallback for any old messages still arriving
    "Ink & Drink";

  const body =
    payload.data?.body ||
    payload.notification?.body ||
    "";

  const notificationOptions = {
    body,
    icon: "/icons/Icon-192.png",
    data: {
      // handy for click handling later
      type: payload.data?.type || "",
      id: payload.data?.id || "",
    },
  };

  self.registration.showNotification(title, notificationOptions);
});


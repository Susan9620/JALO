# JALO

Aplicación móvil en Flutter con backend Node.js/Express y MongoDB Atlas.

## Flutter

```
flutter pub get
flutter run
```

Configura la URL del backend en `lib/env.dart` modificando `baseUrl`.

## Backend

```
cd backend
npm install
npm run dev
```

Variables de entorno en `backend/.env`:

```
MONGODB_URI=mongodb+srv://...
ALLOWED_ORIGINS=http://localhost:3000
PORT=3000
```

Compilar para producción:

```
npm run build
npm start
```

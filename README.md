# PlanC — Frontend

[![Flutter](https://img.shields.io/badge/Flutter-3.41.6-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.11.4-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com/)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![SonarCloud](https://img.shields.io/badge/SonarCloud-F3702A?style=for-the-badge&logo=sonarcloud&logoColor=white)](https://sonarcloud.io/project/overview?id=pes2526q2-11-gei-upc_PlanC-Frontend)

Repositori de l'aplicació mòbil Android de **PlanC**, una plataforma social interactiva que transforma l'Agenda Cultural de Catalunya en una experiència col·lectiva. Els usuaris poden descobrir activitats culturals, organitzar quedades amb amics, comunicar-se per xat en temps real i guanyar punts per la seva participació cultural.

---

## Taula de continguts

1. [Descripció del projecte](#descripció-del-projecte)
2. [Equip](#equip)
3. [Stack tecnològic](#stack-tecnològic)
4. [Arquitectura i mòduls](#arquitectura-i-mòduls)
5. [Requisits previs](#requisits-previs)
6. [Instal·lació i configuració](#installació-i-configuració)
7. [Variables de configuració](#variables-de-configuració)
8. [Comandes disponibles](#comandes-disponibles)
9. [Tests](#tests)
10. [Desplegament i distribució](#desplegament-i-distribució)
11. [Links útils](#links-útils)

---

## Descripció del projecte

PlanC neix de la voluntat de fomentar el consum de cultura i la socialització al voltant dels esdeveniments culturals de Catalunya. L'aplicació transforma l'Agenda Cultural de Catalunya en una plataforma social interactiva, connectant usuaris amb interessos compartits perquè puguin descobrir activitats culturals i assistir-hi conjuntament.

Aquest repositori conté l'aplicació mòbil desenvolupada amb Flutter per a la plataforma Android. Es comunica amb el backend via API REST i WebSockets.

**Context acadèmic:** Projecte de l'assignatura PES — Projecte d'Enginyeria del Software, curs 2025-2026 Q2, Facultat d'Informàtica de Barcelona (FIB), Universitat Politècnica de Catalunya (UPC).

---

## Equip

**Grup FemBoys — PES Q2 2025-2026**

| Membre | Correu |
|---|---|
| Eric Ruiz | eric.ruiz.miro@estudiantat.upc.edu |
| Roger Guinovart | roger.guinovart@estudiantat.upc.edu |
| Jordi Caballeria | jordi.caballeria@estudiantat.upc.edu |
| Aleks Shahverdyan | aleks.shahverdyan@estudiantat.upc.edu |
| Naia Cuní | naia.cuni.i@estudiantat.upc.edu |
| Roger Corcoles | roger.corcoles@estudiantat.upc.edu |
| Izan Jorge | izan.jorge@estudiantat.upc.edu |

**Coordinador:** carles.farre@upc.edu
**Professor:** albert.pinto@upc.edu

---

## Stack tecnològic

| Tecnologia | Versió | Ús |
|---|---|---|
| Flutter | 3.41.6 (stable) | Framework de desenvolupament |
| Dart | 3.11.4 | Llenguatge de programació |
| flutter_riverpod | ^2.5.1 | Gestió d'estat i injecció de dependències |
| go_router | ^13.2.0 | Navegació declarativa |
| dio | ^5.4.3 | Client HTTP per a l'API REST |
| supabase_flutter | ^2.5.0 | Autenticació i Storage |
| google_maps_flutter | ^2.6.0 | Mapa interactiu d'activitats |
| socket_io_client | ^3.1.4 | WebSockets per al xat en temps real |
| firebase_core | ^3.6.0 | Inicialització de Firebase |
| firebase_messaging | ^15.1.3 | Notificacions push (FCM) |
| geolocator | ^14.0.2 | Geolocalització per validar assistència |
| flutter_secure_storage | ^10.0.0 | Emmagatzematge segur de tokens |
| table_calendar | ^3.1.2 | Vista de calendari d'activitats |
| device_calendar | ^4.3.2 | Integració amb el calendari del dispositiu |
| image_picker | ^1.2.1 | Selecció de foto de perfil i xat |
| share_plus | ^12.0.2 | Compartir activitats des de l'app |
| intl | ^0.20.2 | Internacionalització i format de dates |

---

## Arquitectura i mòduls

L'aplicació segueix una **arquitectura modular per features** combinada amb **Clean Architecture** i el patró **MVVM** a la capa de presentació. Cada feature és independent i s'organitza en tres capes: Presentació, Domini i Dades.

La gestió d'estat es fa amb **Riverpod**, on els `Notifier` actuen com a ViewModel i els widgets observen l'estat via `ref.watch()`.

### Estructura de directoris

```
lib/
├── core/          # Configuració global, clients HTTP, interceptors
├── features/      # Mòduls de l'aplicació (vegeu taula)
├── l10n/          # Fitxers de localització (ca, es, en)
├── shared/        # Widgets, models i utilitats compartides
└── main.dart      # Punt d'entrada de l'aplicació
```

### Mòduls (features)

| Mòdul | Descripció |
|---|---|
| `auth` | Registre en 3 passos, login, logout, verificació de correu i OAuth amb Google |
| `map` | Mapa interactiu amb activitats culturals geolocalitzades i filtres |
| `activitats` | Detall d'activitat, quedades associades, valoracions i validació per geolocalització |
| `groups` | Creació i gestió de quedades, participants i xat de grup |
| `chat` | Xats individuals i grupals, enviament de missatges i imatges en temps real |
| `amistats` | Sol·licituds d'amistat, llista d'amics i suggerències |
| `perfil` | Perfil d'usuari, edició de dades, foto i biografia |
| `notificacions` | Historial de notificacions push i badge de no llegides |
| `feed` | Feed social d'activitats i publicacions |
| `publicacions` | Publicacions sobre activitats, likes i comentaris |
| `interaccions` | Likes, comentaris i respostes a publicacions |
| `cercador` | Cerca d'activitats i perfils d'usuari |
| `preferits` | Activitats guardades per l'usuari |
| `calendari` | Vista de calendari amb les activitats a les quals l'usuari s'ha apuntat |
| `navigation` | Barra de navegació inferior global i routing principal |
| `settings` | Configuració de compte i preferències de l'app |
| `gustos` | Selecció de categories culturals d'interès |
| `redireccioCompraEntrades` | Redirecció a la compra d'entrades d'una activitat |

---

## Requisits previs

- **Flutter** 3.41.6 o superior (channel stable)
- **Dart** 3.11.4 o superior
- **Android SDK** amb API level 21 (Android 5.0) o superior
- **Android Studio** o **VS Code** amb les extensions de Flutter i Dart
- Fitxer `google-services.json` (Firebase) col·locat a `android/app/`
- Accés al backend desplegat o en local

> ⚠️ L'aplicació només suporta **Android**. iOS no està configurat en aquest repositori.

---

## Instal·lació i configuració

### 1. Clona el repositori

```bash
git clone https://github.com/pes2526q2-11-gei-upc/PlanC-Frontend.git
cd PlanC-Frontend
```

### 2. Instal·la les dependències

```bash
flutter pub get
```

### 3. Configura Firebase

Col·loca el fitxer `google-services.json` proporcionat per l'equip a:

```
android/app/google-services.json
```

> ⚠️ Aquest fitxer conté credencials i no està al repositori. Sol·licita'l a un membre de l'equip.

### 4. Configura les URLs del backend

Al fitxer de configuració corresponent (normalment a `lib/core/`), assegura't que la URL base de l'API apunta al backend correcte:

- **Producció:** `https://planc-backend-aff2.onrender.com`
- **Local:** `http://10.0.2.2:3000` (emulador Android) o `http://localhost:3000` (dispositiu físic)

### 5. Arrenca l'aplicació

```bash
flutter run
```

---

## Variables de configuració

A diferència del backend, Flutter no usa fitxers `.env` de manera nativa. Les configuracions sensibles es gestionen de dues maneres:

- **`google-services.json`** — fitxer de Firebase col·locat a `android/app/`. No s'inclou al repositori.
- **Secrets de GitHub Actions** — per al pipeline de CI/CD s'utilitzen els secrets `FIREBASE_TOKEN` i `GOOGLE_SERVICES_JSON` configurats al repositori de GitHub.

---

## Comandes disponibles

```bash
# Arrancar l'app en mode debug
flutter run

# Compilar APK en mode debug
flutter build apk --debug

# Compilar APK en mode release
flutter build apk --release

# Executar tots els tests
flutter test

# Anàlisi estàtica del codi
flutter analyze

# Actualitzar dependències
flutter pub get

# Netejar el build
flutter clean

# Generar fitxers de localització
flutter gen-l10n
```

---

## Tests

El projecte utilitza el paquet oficial **flutter_test** per als tests de widget i unitaris, i **mockito** per als mocks.

```bash
# Executar tots els tests
flutter test

# Executar un fitxer de test concret
flutter test test/features/cercador/
```

### Cobertura de tests per feature

| Feature | Fitxers de test |
|---|---|
| `cercador` | domain, providers ×2, widgets |
| `groups` | datasources, repository, models ×2, provider, screens, widgets |
| `redireccioCompraEntrades` | repository, usecase ×2 amb mocks, widget |
| Arrel | widget_test.dart |

**Total: 16 fitxers de test** distribuïts en 3 features i el test arrel.

---

## Desplegament i distribució

L'APK de l'aplicació es distribueix automàticament als testers via **Firebase App Distribution** quan es fusiona codi a les branques principals.

### Pipeline CI/CD

El repositori té dos workflows de GitHub Actions:

**`main.yml` — Flutter CI**
S'executa en cada push i Pull Request cap a `develop` i `main`. Executa els passos següents:
1. Checkout del codi
2. Instal·lació de Flutter (channel stable, sense versió fixada)
3. `flutter pub get`
4. `flutter analyze`
5. `flutter test`
6. Build check (`flutter build apk --debug`)

**`build-apk.yml` — Build & Distribute APK**
S'executa en cada push a `develop` i `main`. Compila l'APK de release i la distribueix automàticament:
1. Checkout del codi
2. Configuració de Java 17 (distribució Zulu)
3. Instal·lació de Flutter 3.41.8
4. `flutter pub get`
5. `flutter build apk --release`
6. Pujada a Firebase App Distribution

### Grups de testers

| Branca | Grup de testers |
|---|---|
| `develop` i `main` | `testers` (tot l'equip) |
| `main` | `profe` (professors i coordinador) |

Els testers reben una notificació automàtica per correu quan hi ha una nova versió disponible per descarregar.

> ℹ️ Els workflows estan temporalment desactivats per consum de minuts de GitHub Actions. Es poden reactivar descomentant els triggers als fitxers corresponents.

---

## Links útils

| Recurs | URL |
|---|---|
| Repositori Frontend | https://github.com/pes2526q2-11-gei-upc/PlanC-Frontend |
| Repositori Backend | https://github.com/pes2526q2-11-gei-upc/PlanC-Backend |
| Backend desplegat | https://planc-backend-aff2.onrender.com |
| API docs (Swagger) | https://planc-backend-aff2.onrender.com/api/docs |
| SonarCloud Frontend | https://sonarcloud.io/project/overview?id=pes2526q2-11-gei-upc_PlanC-Frontend |
| SonarCloud Backend | https://sonarcloud.io/project/overview?id=pes2526q2-11-gei-upc_PlanC-Backend |
| Taiga (gestió del projecte) | https://tree.taiga.io/project/izanjorge-pes-femboys/timeline |
| Firebase App Distribution | https://console.firebase.google.com/u/2/project/planc-b1964/appdistribution |
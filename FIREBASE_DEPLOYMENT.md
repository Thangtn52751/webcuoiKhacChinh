# Firebase deployment

Firebase Hosting serves the Flutter Web build. Cloud Functions for Firebase (2nd gen) serves the existing Express/Mongoose API in Singapore; Hosting rewrites `/api/**` to the function so the browser uses one origin. MongoDB stays on Atlas.

## One-time setup

1. Create or choose a Firebase project and attach a billing account (Blaze). Hosting stays within its no-cost quota at low traffic; the API's `minInstances: 1` keeps one function instance warm and has idle compute charges.
2. Install and sign in to the Firebase CLI: `npm install -g firebase-tools`, then `firebase login`.
3. In the project root, run `firebase use --add` and choose the Firebase project.
4. Set the required Function secrets through the interactive CLI prompts (do not put secret values in source control):

   ```powershell
   firebase functions:secrets:set MONGODB_URI
   firebase functions:secrets:set SMTP_USER
   firebase functions:secrets:set SMTP_PASS
   firebase functions:secrets:set RSVP_NOTIFICATION_EMAIL
   firebase functions:secrets:set ADMIN_API_KEY
   ```

5. Firebase CLI reads the non-secret parameters (`SMTP_HOST`, `SMTP_PORT`, `SMTP_SECURE`, and the optional Maps key) from `server/.env`; if a value is missing, it prompts and saves it to a project-specific `.env` file. Both are ignored by Git and excluded from the function upload.
6. Atlas only accepts connections from its IP access list. Cloud Functions does not have a fixed outbound IP by default, so use a VPC connector and Cloud NAT for a fixed address, or allow public IPs in Atlas and use a strong database password with a database-scoped user.

## Build and deploy

From the repository root in PowerShell:

```powershell
Push-Location webcuoi
flutter pub get
flutter build web --release --dart-define=API_BASE_URL=/api
Pop-Location
firebase deploy --only functions,hosting
```

The deployed site URL is shown by Firebase CLI. `/api/health` should report `{"status":"ok"}` after the function connects to MongoDB.

Hosting includes up to 10 GB storage and 10 GB/month transfer at no charge. Functions require the Blaze plan, and a minimum instance incurs charges even while idle. Minimum instances are kept warm on a best-effort basis and can restart; they are not a 100% uptime guarantee. Add a Google Cloud budget alert before enabling billing.

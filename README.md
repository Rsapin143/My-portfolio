# Rodolfo Sapin Portfolio — Realtime Supabase Version

This is the fixed pure HTML, CSS, and JavaScript portfolio with Supabase Realtime. It includes updated realistic profile information, expanded skills, video/image uploads, responsive video cards, and dark/light mode.

## What is included

- Real-time Profile, Skills, Works, and theme updates through Supabase
- Dark mode and light mode toggle
- Updated personal information for Rodolfo Sapin
- School and course fields
- Expanded skill list for video editing, graphic design, web development, front-end development, UI/UX, Laravel, React Native, Tailwind CSS, Flutter, Angular, PHP, HTML, JavaScript, Node.js, React.js, TypeScript, GitHub, Supabase, MongoDB, Firebase, and PWA
- Profile image upload through Supabase Storage
- Project video upload through Supabase Storage
- Video cards that play on hover
- Video card ratio support: 16 / 9, 9 / 16, 1 / 1, 4 / 5, 4 / 3

## Login

Email: `rodolfo@gmail.com`  
Password: `rod123`

## Setup

### 1. Create a Supabase project
Create a new project in Supabase.

### 2. Run the SQL
Open this file:

```text
database/supabase.sql
```

Copy everything and run it in:

```text
Supabase Dashboard → SQL Editor
```

This creates and updates:

- `site_settings` table
- real-time support
- storage bucket named `portfolio-media`
- public policies for a static portfolio setup
- Rodolfo Sapin default profile information

### 3. Add your Supabase keys
Open:

```text
assets/js/supabase-config.js
```

Replace:

```js
window.SUPABASE_URL = 'https://YOUR-PROJECT-REF.supabase.co';
window.SUPABASE_ANON_KEY = 'YOUR-SUPABASE-ANON-KEY';
window.SUPABASE_BUCKET = 'portfolio-media';
```

with your real values from:

```text
Supabase Dashboard → Project Settings → API
```

### 4. Run locally

```bash
cd rodolfo-portfolio-realtime
python3 -m http.server 8000
```

Open:

```text
http://localhost:8000
```

Do not open `index.html` by double-clicking. Use a local server or upload the folder to hosting.

## Important

If the site still shows old data, run `database/supabase.sql` again. This fixed SQL updates the existing `main` row with the new Rodolfo Sapin profile.

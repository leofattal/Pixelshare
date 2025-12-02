# Database Setup Instructions

## Prerequisites
- A Supabase project (https://supabase.com)
- Your Supabase project URL and anon key

## Step 1: Create .env.local file

Create a `.env.local` file in the root directory with your Supabase credentials:

```env
NEXT_PUBLIC_SUPABASE_URL=your_project_url_here
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key_here
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here
```

**How to find these values:**
1. Go to your Supabase project dashboard
2. Click on "Project Settings" (gear icon in the sidebar)
3. Click on "API" in the settings menu
4. Copy the values:
   - `URL` → NEXT_PUBLIC_SUPABASE_URL
   - `anon/public` key → NEXT_PUBLIC_SUPABASE_ANON_KEY
   - `service_role` key → SUPABASE_SERVICE_ROLE_KEY

## Step 2: Run the Database Schema

1. Open your Supabase project dashboard
2. Click on "SQL Editor" in the left sidebar
3. Click "New Query"
4. Copy the entire contents of `supabase_schema.sql`
5. Paste it into the SQL editor
6. Click "Run" (or press Cmd+Enter / Ctrl+Enter)
7. Wait for the query to complete (you should see "Success. No rows returned")

## Step 3: Set up Row Level Security (RLS)

1. In the SQL Editor, create a new query
2. Copy the entire contents of `supabase_rls_policies.sql`
3. Paste it into the SQL editor
4. Click "Run"
5. Wait for completion

## Step 4: Configure Authentication Providers

### Email/Password (Already enabled by default)
- No additional configuration needed

### Google OAuth

1. Go to "Authentication" → "Providers" in your Supabase dashboard
2. Find "Google" and click "Enable"
3. You'll need to create a Google OAuth app:
   - Go to https://console.cloud.google.com/
   - Create a new project or select existing one
   - Enable Google+ API
   - Create OAuth 2.0 credentials
   - Add authorized redirect URIs: `https://your-project-ref.supabase.co/auth/v1/callback`
   - Copy your Client ID and Client Secret
4. Paste them into Supabase:
   - Client ID → "Client ID (for OAuth)" field
   - Client Secret → "Client Secret (for OAuth)" field
5. Click "Save"

### Microsoft OAuth

1. Go to "Authentication" → "Providers" in your Supabase dashboard
2. Find "Azure (Microsoft)" and click "Enable"
3. You'll need to create a Microsoft Azure app:
   - Go to https://portal.azure.com/
   - Navigate to "Azure Active Directory" → "App registrations"
   - Click "New registration"
   - Add redirect URI: `https://your-project-ref.supabase.co/auth/v1/callback`
   - Go to "Certificates & secrets" → Create a new client secret
   - Copy your Application (client) ID and client secret value
4. Paste them into Supabase:
   - Application (client) ID → "Client ID" field
   - Client secret value → "Client Secret" field
5. Click "Save"

## Step 5: Set up Storage Buckets

1. Go to "Storage" in your Supabase dashboard
2. Click "New bucket"
3. Create the following buckets:

### Bucket 1: profile-pictures
- **Name:** `profile-pictures`
- **Public:** ✓ (checked)
- **File size limit:** 5 MB
- **Allowed MIME types:** `image/jpeg, image/png, image/webp`

### Bucket 2: photos
- **Name:** `photos`
- **Public:** ✓ (checked)
- **File size limit:** 20 MB
- **Allowed MIME types:** `image/jpeg, image/png, image/webp, image/gif`

### Bucket 3: videos
- **Name:** `videos`
- **Public:** ✓ (checked)
- **File size limit:** 5000 MB (5 GB)
- **Allowed MIME types:** `video/mp4, video/quicktime, video/x-msvideo, video/webm`

## Step 6: Set up Storage Policies

For each bucket, you'll need to add storage policies. Go to the bucket → "Policies" tab:

### For all buckets:

**SELECT (download) policy:**
```sql
CREATE POLICY "Public Access"
ON storage.objects FOR SELECT
USING (bucket_id = 'bucket-name-here');
```

**INSERT (upload) policy:**
```sql
CREATE POLICY "Authenticated users can upload"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'bucket-name-here'
  AND auth.role() = 'authenticated'
);
```

**UPDATE policy:**
```sql
CREATE POLICY "Users can update their own files"
ON storage.objects FOR UPDATE
USING (
  bucket_id = 'bucket-name-here'
  AND auth.uid()::text = (storage.foldername(name))[1]
);
```

**DELETE policy:**
```sql
CREATE POLICY "Users can delete their own files"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'bucket-name-here'
  AND auth.uid()::text = (storage.foldername(name))[1]
);
```

Replace `'bucket-name-here'` with `'profile-pictures'`, `'photos'`, or `'videos'` for each bucket.

## Step 7: Verify Setup

1. Go to "Table Editor" in Supabase dashboard
2. Verify all tables are created:
   - users
   - posts
   - videos
   - video_versions
   - follows
   - likes
   - comments
   - notifications
   - hashtags
   - post_hashtags
   - video_hashtags

3. Go to "Database" → "Functions"
4. Verify functions are created:
   - get_user_feed
   - increment_follower_count
   - increment_like_count
   - etc.

## Done!

Your database is now fully set up and ready to use. You can now run the Next.js development server:

```bash
npm run dev
```

The app will be available at http://localhost:3000

## Troubleshooting

### "relation already exists" errors
- This means you've already run the schema. You can either:
  - Drop all tables and re-run the schema
  - Or ignore the errors if tables are already created

### Authentication not working
- Make sure your OAuth redirect URIs match exactly (including https://)
- Check that your .env.local file has the correct credentials
- Restart your development server after adding/changing .env.local

### File uploads not working
- Verify storage buckets are public
- Check that storage policies are applied
- Ensure file sizes are within limits

### Need help?
- Check Supabase documentation: https://supabase.com/docs
- Check Next.js documentation: https://nextjs.org/docs

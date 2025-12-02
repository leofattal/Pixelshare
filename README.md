# Pixel Share

A modern social media platform for creators to share photos and long-form videos (up to 2-3 hours). Built with Next.js 14, Supabase, TypeScript, and Tailwind CSS.

## Features

✅ **Completed:**
- User authentication (Email/Password, Google OAuth, Microsoft OAuth)
- Responsive navigation (desktop header + mobile bottom nav)
- Database schema with all tables
- Row Level Security (RLS) policies
- Home feed for viewing content from followed users

🚧 **In Progress / To Be Built:**
- User profiles with content grids
- Photo upload and viewer
- Video upload with processing pipeline
- Video player with controls
- Search functionality
- Follow/unfollow system
- Likes and comments
- Notifications with real-time updates
- Dark mode toggle
- Direct messaging (optional)
- Creator analytics dashboard (optional)
- Explore/trending page (optional)

## Tech Stack

- **Frontend:** Next.js 14 (App Router), React 18, TypeScript
- **Styling:** Tailwind CSS
- **Backend:** Supabase (PostgreSQL, Auth, Storage, Realtime)
- **State Management:** Zustand
- **Forms:** React Hook Form + Zod
- **Icons:** Lucide React

## Prerequisites

- Node.js 18+ and npm
- A Supabase account and project
- Google Cloud Console account (for Google OAuth)
- Microsoft Azure account (for Microsoft OAuth)

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/leofattal/Pixelshare.git
cd Pixelshare
```

### 2. Install dependencies

```bash
npm install
```

### 3. Set up Supabase

Follow the instructions in [DATABASE_SETUP.md](./DATABASE_SETUP.md) to:
- Create your Supabase project
- Run the database schema
- Set up Row Level Security policies
- Configure authentication providers (Google, Microsoft)
- Create storage buckets

### 4. Configure environment variables

Create a `.env.local` file in the root directory:

```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
```

You can find these values in your Supabase project dashboard under Project Settings → API.

### 5. Run the development server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

## Project Structure

```
Pixelshare/
├── src/
│   ├── app/
│   │   ├── auth/              # Auth actions and callback
│   │   ├── feed/              # Home feed page
│   │   ├── login/             # Login page
│   │   ├── signup/            # Sign up page
│   │   ├── forgot-password/   # Password reset page
│   │   ├── layout.tsx         # Root layout
│   │   ├── page.tsx           # Root redirect
│   │   └── globals.css        # Global styles
│   ├── components/            # React components
│   │   └── Header.tsx         # Navigation header
│   ├── lib/
│   │   └── supabase/          # Supabase client configuration
│   ├── types/
│   │   └── database.ts        # TypeScript types for database
│   └── hooks/                 # Custom React hooks (to be added)
├── supabase_schema.sql        # Database schema SQL
├── supabase_rls_policies.sql  # Row Level Security policies
├── DATABASE_SETUP.md          # Database setup instructions
├── PRD.md                     # Product Requirements Document
└── README.md                  # This file
```

## Database Schema

The app uses the following main tables:

- **users** - User profiles (extends Supabase auth.users)
- **posts** - Photo posts
- **videos** - Video posts (supports up to 2-3 hours)
- **video_versions** - Multiple video resolutions (1080p, 720p, etc.)
- **follows** - User follow relationships
- **likes** - Likes on posts, videos, and comments
- **comments** - Comments and replies
- **notifications** - User notifications
- **hashtags** - Hashtag metadata
- **post_hashtags** - Post-hashtag relationships
- **video_hashtags** - Video-hashtag relationships

## Key Features Explained

### Authentication

- **Email/Password:** Users can sign up and log in with email and password
- **Google OAuth:** One-click sign in with Google account
- **Microsoft OAuth:** One-click sign in with Microsoft account
- **Password Reset:** Users can reset their password via email

### Feed

- Displays a chronological mix of photos and videos from followed users
- Uses the `get_user_feed()` database function for efficient queries
- Empty state prompts users to discover and follow creators

### Storage

Three Supabase storage buckets:
- `profile-pictures`: User avatars (max 5MB)
- `photos`: Photo posts (max 20MB)
- `videos`: Video files (max 5GB, up to 2-3 hours)

### Security

- Row Level Security (RLS) ensures users can only modify their own content
- All database operations are secured at the database level
- Authentication required for all protected routes
- Middleware refreshes user sessions automatically

## Development Roadmap

See [PRD.md](./PRD.md) for the complete product requirements and feature specifications.

### Phase 1: MVP (Current)
- ✅ Authentication system
- ✅ Database schema and RLS
- ✅ Basic navigation
- 🚧 User profiles
- 🚧 Photo upload and viewing
- 🚧 Video upload and playback
- 🚧 Follow system
- 🚧 Likes and comments

### Phase 2: Core Features
- Search functionality
- Notifications system
- Hashtags
- Share functionality

### Phase 3: Advanced Features
- Creator analytics
- Explore/trending page
- Photo filters and editing
- Direct messaging
- Dark mode

## Scripts

```bash
# Development
npm run dev          # Start dev server

# Production
npm run build        # Build for production
npm start            # Start production server

# Code Quality
npm run lint         # Run ESLint
```

## Contributing

This is a personal project, but suggestions and feedback are welcome!

## License

MIT License - see LICENSE file for details

## Support

For issues or questions:
- Check [DATABASE_SETUP.md](./DATABASE_SETUP.md) for setup help
- Review [PRD.md](./PRD.md) for feature specifications
- Open an issue on GitHub

---

Built with ❤️ by Leo Fattal

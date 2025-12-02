# Product Requirements Document (PRD)
# Pixel Share - Influencer-Focused Social Media Platform

**Document Version:** 1.0
**Last Updated:** 2025-11-29
**Status:** Draft
**Platform:** Web Only
**Backend:** Supabase

---

## 1. Overview & Goals

### 1.1 Product Vision
Pixel Share is a next-generation social media platform that combines the visual storytelling of Instagram with the long-form content capabilities of YouTube. Designed for creators and influencers, Pixel Share enables users to build their audience through both quick photo updates and engaging video content in a single, unified platform.

### 1.2 Product Goals
- **Unified Content Experience**: Allow creators to share both photos and long-form videos without switching platforms
- **Creator-First Design**: Prioritize content creation and audience building with intuitive tools and analytics
- **Seamless Discovery**: Enable users to discover new creators through an intelligent feed and search system
- **Engagement-Driven**: Foster community interaction through likes, comments, shares, and follows
- **Web-First Experience**: Deliver a smooth, responsive experience optimized for modern web browsers

### 1.3 Target Audience
- Content creators and influencers seeking a unified platform for photo and video content
- Viewers who want to follow their favorite creators in one place
- Users looking for an alternative to managing multiple social media accounts
- Age range: 16-45 years old
- Tech-savvy users comfortable with modern social media interfaces

---

## 2. User Roles

### 2.1 User (Single Role)
Pixel Share implements a single, egalitarian user role. Every user has the same capabilities and permissions.

**User Capabilities:**
- Create and manage their own profile
- Upload photos and videos (up to 2-3 hours in length)
- Follow/subscribe to other users
- Like, comment on, and share content
- View home feed with personalized content
- Search for users, content, and hashtags
- Receive and view notifications
- Access analytics for their own content
- Edit and delete their own posts
- Customize profile information and settings

**Note:** There is no separate admin or moderator role. Content moderation will be handled through automated systems and user reporting mechanisms.

---

## 3. Core Features

### 3.1 Authentication System

#### 3.1.1 Login/Sign-Up Page
- **First Screen**: All users see the login/sign-up page when opening the app
- **Email/Password Authentication** (via Supabase Auth):
  - Sign up with email, username, and password
  - Password requirements: minimum 8 characters, must include letters and numbers
  - Email verification flow (send verification email after registration)
  - Login with email/username and password
  - "Forgot Password" flow with email reset link
- **Form Validation**: Real-time validation for email format, username availability, password strength
- **Error Handling**: Clear error messages for invalid credentials, existing accounts, etc.

**Note:** Google Authentication will be implemented separately by the developer using Supabase's built-in OAuth providers.

#### 3.1.2 Session Management
- Persistent login (remember me option via Supabase session)
- Supabase JWT-based authentication
- Automatic logout after extended inactivity
- Secure session storage in browser

### 3.2 Home Feed

#### 3.2.1 Feed Composition
- **Mixed Content**: Display both photos and videos in a single, chronological or algorithm-driven feed
- **Content Sources**: Posts from followed users
- **Feed Algorithm**:
  - Option 1: Chronological (most recent first) - recommended for MVP
  - Option 2: Algorithmic (based on engagement, user interests, and trending content)
  - Hybrid approach: mostly chronological with occasional trending/recommended content

#### 3.2.2 Feed Item Display
**Photo Posts:**
- Full-width or centered image display
- User profile picture and username (clickable)
- Caption (truncated with "see more" expansion)
- Like count and comment count
- Timestamp (e.g., "2 hours ago")
- Quick action buttons: like (heart icon), comment (bubble icon), share (share icon)

**Video Posts:**
- Video player with thumbnail preview
- Video duration display overlay
- User profile picture and username (clickable)
- Title/caption
- View count, like count, comment count
- Timestamp
- Autoplay option (muted) when video enters viewport (optional)

#### 3.2.3 Feed Interactions
- Click photo to open full-screen photo viewer modal
- Click video to expand video player or navigate to dedicated video page
- Click profile picture/username to navigate to user profile
- Infinite scroll with lazy loading (load 10-20 posts at a time)
- Pull-to-refresh or refresh button to load new content

### 3.3 Video Player

#### 3.3.1 Player Controls
- **Play/Pause**: Large center button overlay and spacebar toggle
- **Timeline/Progress Bar**:
  - Draggable scrubber
  - Buffering indicator
  - Timestamp display (current time / total duration)
- **Volume Control**: Volume slider and mute/unmute button
- **Fullscreen Mode**: Expand to fullscreen browser mode
- **Playback Speed**: 0.5x, 0.75x, 1x, 1.25x, 1.5x, 2x options
- **Quality Settings**: Auto, 1080p, 720p, 480p, 360p (based on available encodings)

#### 3.3.2 Player Features
- Auto-pause when navigating away or switching tabs
- Resume playback from last position (stored in localStorage or database)
- Picture-in-picture mode (browser native PiP API)
- Keyboard shortcuts:
  - Space/K: play/pause
  - Left/Right arrows: skip 5 seconds backward/forward
  - Up/Down arrows: volume up/down
  - F: fullscreen
  - M: mute/unmute
- Loading states and buffering indicators
- Error handling for failed video loads

#### 3.3.3 Video Player Interface
- Video player embedded in page or modal
- Below player:
  - Video title
  - Creator info (avatar, username, follower count, follow button)
  - View count and upload date
  - Like, comment, share buttons
  - Expandable description
- Comments section below video player
- Recommended/related videos sidebar or below comments (optional)

### 3.4 Photo Viewer

#### 3.4.1 Viewer Interface
- Modal overlay with darkened background
- Centered high-resolution image
- Close button (X) in top-right corner
- Click outside image or press ESC to close
- Left/right arrow navigation for multi-photo posts (if album feature implemented)

#### 3.4.2 Photo Viewer Features
- Progressive image loading (blur-up technique: load thumbnail, then high-res)
- Zoom controls:
  - Mouse wheel to zoom in/out
  - Click-and-drag to pan when zoomed
  - Double-click to zoom to fit
  - Zoom in/out buttons
- Caption display below or overlaid on image
- Creator info visible (profile picture, username)
- Like, comment, share buttons accessible in modal
- Timestamp and like count displayed
- Smooth fade-in/fade-out transitions

### 3.5 Profile Pages

#### 3.5.1 Profile Header
- Large profile picture (circular avatar, click to view full-size)
- Username (large, bold) and display name (smaller)
- Bio/description (max 150 characters, supports line breaks)
- Website link (clickable, opens in new tab)
- Join date (e.g., "Joined November 2025")
- Statistics row:
  - **X Posts** (total count of photos + videos)
  - **X Followers** (clickable to view followers list)
  - **X Following** (clickable to view following list)
- Action buttons:
  - **Follow/Following button** (changes based on relationship status)
  - **Edit Profile button** (visible only on own profile)
  - **Share Profile button** (copy link to clipboard)
  - **Message button** (if DM system implemented)

#### 3.5.2 Content Grid
- Tab navigation below header:
  - **"Posts" tab** (default): All content (photos + videos mixed)
  - **"Videos" tab**: Videos only
  - **"Photos" tab**: Photos only (optional)
- Grid layout:
  - 3 columns on desktop (4 columns on large screens)
  - 2 columns on tablet
  - 1-2 columns on mobile
- Grid items:
  - Photos: Square thumbnails (cropped to fit)
  - Videos: Square thumbnails with duration overlay and play icon
- Hover effects: Overlay showing like and comment counts
- Click any item to open in photo viewer or video player
- Lazy loading as user scrolls
- Empty state: "No posts yet" message with upload prompt

#### 3.5.3 Profile Stats (Visible on Own Profile)
- Analytics section (collapsible or separate tab):
  - Total views across all content
  - Total likes received
  - Total comments received
  - Average engagement rate
  - Follower growth chart (optional)

#### 3.5.4 Edit Profile
- Modal or dedicated page with form fields:
  - Change profile picture (upload new photo from device)
  - Edit username (with real-time availability check)
  - Edit display name
  - Edit bio (character counter showing 150 max)
  - Add/edit website link (URL validation)
  - Email (display only, cannot change)
- Save button (disabled until changes made)
- Cancel button to discard changes
- Success toast message on save

### 3.6 Follow/Subscribe System

#### 3.6.1 Following Mechanics
- Click "Follow" button on any profile to follow that user
- Button changes to "Following" with checkmark icon
- Hover over "Following" shows "Unfollow" (click to unfollow)
- Confirmation prompt on unfollow
- Followed users' content appears in home feed
- Following list accessible by clicking "X Following" on profile
- Followers list accessible by clicking "X Followers" on profile

#### 3.6.2 Follow Lists
- Searchable list of users
- Each list item shows:
  - Profile picture
  - Username and display name
  - Follow/Following button
  - Bio preview
- Click user to navigate to their profile
- Infinite scroll for long lists

#### 3.6.3 Follow Features
- Follow/unfollow notifications sent to the creator
- Mutual follow indicator (optional badge: "Follows you")
- Follow suggestions on profile pages
- Quick follow from feed without navigating to full profile

### 3.7 Engagement System

#### 3.7.1 Likes
- Heart icon button below all posts and videos
- Click heart to like (icon fills with color, animates)
- Click again to unlike
- Like count displayed publicly
- Real-time like count updates
- Liked items saved to user's liked collection
- Click like count to view list of users who liked

#### 3.7.2 Comments
- Comment section below all posts and videos
- Comment input field with post button
- Comment display:
  - Commenter's profile picture
  - Username (clickable)
  - Comment text
  - Timestamp
  - Like button
  - Reply button
  - Delete button (own comments only)
  - Report button
- Sort options: "Top Comments" or "Newest First"
- Nested replies (1 level deep)
- @ mentions with autocomplete
- Character limit: 500 characters per comment

#### 3.7.3 Shares
- Share button below all posts/videos
- Share menu options:
  - Copy link
  - Share to Twitter
  - Share to Facebook
  - Share via email
  - Send via DM (if implemented)
- Share count displayed (optional)
- Track share events in analytics

### 3.8 Upload System

#### 3.8.1 Upload Entry Points
- "Create" or "+" button in top navigation bar
- "Upload" button on user's own profile page
- Upload prompt in empty feed state

#### 3.8.2 Photo Upload Flow
1. Click upload button → Opens upload modal/page
2. Choose "Upload Photo" or drag-and-drop
3. File picker → Select photo
4. Preview with editing tools:
   - Crop/resize (aspect ratios: Original, 1:1, 4:5, 16:9)
   - Apply filters (optional)
5. Add metadata:
   - Caption (required, max 2,200 characters)
   - Hashtags (auto-detected with #)
   - Location tag (optional)
   - Alt text (optional, max 500 characters)
6. Click "Share" to upload
7. Progress bar shows upload progress
8. Success message with link to view post
9. Redirect to profile or feed

#### 3.8.3 Video Upload Flow
1. Click upload button → Choose "Upload Video"
2. File picker → Select video
3. Upload begins (chunked upload for large files)
4. While uploading, add metadata:
   - Title (required, max 100 characters)
   - Description (optional, max 5,000 characters)
   - Hashtags
   - Thumbnail selection (auto-generated or custom upload)
   - Visibility (Public, Unlisted, Private)
5. Progress indicator with percentage
6. After upload: "Processing video..." status
7. Processing generates multiple resolutions
8. Notification when processing complete
9. Redirect to video page

#### 3.8.4 Upload Requirements
- **Photo Formats**: JPG, PNG, HEIC, WebP, GIF
- **Photo Size**: Max 20MB per photo
- **Photo Resolution**: Max 4096x4096 pixels
- **Video Formats**: MP4, MOV, AVI, WebM, MKV
- **Video Size**: Max 5GB per video
- **Video Length**: Max 2-3 hours (180 minutes)
- **Video Resolution**: Support up to 4K (3840x2160)

#### 3.8.5 Upload Experience
- Progress indicator with percentage
- Background upload (user can navigate away)
- Upload queue in notification area
- Retry mechanism on failure (up to 3 attempts)
- Draft system to save posts without publishing
- Error handling with clear messages

### 3.9 Search Page

#### 3.9.1 Search Interface
- Dedicated search page/route
- Large search bar at top center
- Below search bar when empty:
  - Recent searches (last 5-10 searches)
  - Trending hashtags (top 10-20)
  - Popular creators

#### 3.9.2 Search Functionality
- Real-time search (results update as user types, debounced 300ms)
- Search types (tabbed results):
  - **All**: Mixed results
  - **Users**: Search by username/display name
  - **Videos**: Search titles and descriptions
  - **Photos**: Search captions
  - **Hashtags**: Search hashtag names

#### 3.9.3 Search Results Display
**Users tab:**
- List of user cards
- Each card shows: profile picture, username, display name, bio, follower count, follow button
- Click card to navigate to profile

**Videos tab:**
- Grid of video thumbnails (3-4 columns)
- Each shows: thumbnail, duration, title, creator, view count, upload date
- Click to open video player

**Photos tab:**
- Grid of photo thumbnails (3-4 columns)
- Like count overlay on hover
- Click to open photo viewer

**Hashtags tab:**
- List of hashtags with post count
- Click hashtag to view all posts with that tag

#### 3.9.4 Search Features
- Autocomplete dropdown with suggestions
- Search history in localStorage
- Filters (optional): upload date, popularity, content type
- Pagination: infinite scroll or "Load more" button
- Empty state with suggestions

#### 3.9.5 Search Algorithm
- Full-text search using PostgreSQL (Supabase)
- Relevance ranking: exact matches highest
- Personalization (optional): boost followed users
- GIN indexes on searchable columns

### 3.10 Notifications

#### 3.10.1 Notification Types
- New follower
- Like on post/video
- Comment on post/video
- Reply to comment
- Mention in comment
- Milestone notifications (follower count, views)

#### 3.10.2 Notification Center
- Bell icon in top navigation with unread badge
- Click to open notifications dropdown/panel
- List sorted by recency
- Each notification shows:
  - Actor's profile picture
  - Notification message
  - Thumbnail of related content
  - Timestamp
  - Blue dot for unread
- Click notification to navigate to content
- "Mark all as read" button
- "Clear all" button
- Infinite scroll for long lists

#### 3.10.3 Notification Settings
- Settings page with preferences:
  - Push notifications (browser push)
  - Email notifications
  - Granular controls per notification type
  - Quiet hours (optional)
  - Notification frequency (real-time or digest)

#### 3.10.4 Real-Time Notifications
- Use Supabase Realtime subscriptions
- Subscribe to notifications table filtered by user_id
- Instant UI updates when new notification inserted
- Browser push notifications (optional, requires permission)

---

## 4. Optional/Advanced Features

### 4.1 Creator Analytics Dashboard

#### 4.1.1 Analytics Overview
- Follower growth chart (7/30/90 days, all time)
- Total content views (photos + videos)
- Total likes and comments received
- Engagement rate percentage
- Top-performing posts/videos

#### 4.1.2 Detailed Metrics Per Post/Video
- Individual views
- Unique viewers
- Watch time (videos): average and total
- Audience retention graph (videos)
- Traffic sources (feed, profile, search, external)
- Demographics (optional): age range, location
- Click-through rate on profile

#### 4.1.3 Analytics Access
- "Analytics" tab on own profile
- Export data as CSV (optional)
- Date range selectors

### 4.2 Explore/Trending Page

#### 4.2.1 Explore Interface
- Dedicated tab in main navigation
- Curated sections:
  - Trending videos
  - Trending photos
  - Trending hashtags
  - Recommended creators
  - Categories (Fashion, Tech, Travel, Fitness, etc.)

#### 4.2.2 Trending Algorithm
- Engagement velocity (likes/views per hour)
- Recency factor
- Diversity (avoid same creator repeatedly)
- Personalization based on user interests

### 4.3 Filters & Basic Editing Tools

#### 4.3.1 Photo Filters
- Presets: Vintage, B&W, Vivid, Cool, Warm, Sepia, etc.
- Adjustable intensity slider
- Basic adjustments: brightness, contrast, saturation, sharpness
- Crop and rotate tools
- Aspect ratio adjustment

#### 4.3.2 Video Editing (Basic)
- Trim video (select start/end points)
- Add text overlays (optional)
- Add music from royalty-free library (optional)
- Adjust volume levels
- Apply filters (optional)

### 4.4 Direct Messaging (DMs) System

#### 4.4.1 Messaging Interface
- Inbox icon in top navigation with unread count
- Messages page with:
  - Left sidebar: conversations list
  - Right: active conversation thread
- Search conversations

#### 4.4.2 Message Features
- Send text messages
- Send photos and videos
- Share posts/videos from feed
- Like messages (heart reaction)
- Message read receipts (optional)
- Typing indicators
- Group messages up to 15 people (optional)

#### 4.4.3 Privacy Controls
- Accept messages from: Everyone, People I Follow, No One
- Block users
- Report inappropriate messages

---

## 5. Technical Requirements

### 5.1 Frontend Stack (Web Only)

#### 5.1.1 Framework & Libraries
**Recommended Stack:**
- **Framework**: React (v18+) with Next.js 14+ (App Router)
  - Benefits: SSR for SEO, file-based routing, image optimization
  - Alternative: Vite + React (faster dev, no SSR)
- **State Management**: Zustand or Redux Toolkit
- **UI Library**: Tailwind CSS with shadcn/ui components
  - Alternative: Material-UI or Chakra UI
- **Routing**: Next.js App Router or React Router v6
- **Forms**: React Hook Form with Zod validation
- **Media**:
  - react-player (video playback)
  - react-image-crop (cropping)
  - react-dropzone (file uploads)
- **HTTP Client**: Supabase JavaScript Client
- **Real-Time**: Supabase Realtime
- **Notifications**: react-toastify or sonner

#### 5.1.2 Build Tools
- **Package Manager**: npm, yarn, or pnpm
- **Bundler**: Next.js (Webpack/Turbopack) or Vite
- **TypeScript**: Strongly recommended
- **Linting**: ESLint + Prettier
- **Pre-commit**: Husky + lint-staged

#### 5.1.3 Testing
- **Unit Testing**: Vitest or Jest
- **Component Testing**: React Testing Library
- **E2E Testing**: Playwright or Cypress

#### 5.1.4 Performance
- Code splitting with React.lazy() and Suspense
- Image optimization (Next.js Image component, WebP format)
- Lazy loading with Intersection Observer
- Virtual scrolling (react-window) for long lists
- Memoization (React.memo, useMemo, useCallback)

### 5.2 Backend: Supabase

#### 5.2.1 Supabase Services
- **Supabase Auth**: Email/password, Google OAuth, JWT tokens, RLS
- **Supabase Database**: PostgreSQL with full-text search
- **Supabase Storage**: Object storage for media files, CDN integration
- **Supabase Realtime**: Real-time subscriptions, presence, broadcast
- **Supabase Edge Functions**: Serverless functions for background jobs

#### 5.2.2 Database Schema

**users table:**
```sql
id (uuid, primary key) -- Supabase Auth managed
email (varchar, unique)
username (varchar, unique, indexed, NOT NULL)
display_name (varchar)
bio (text, max 150 chars)
profile_picture_url (varchar)
website_url (varchar)
follower_count (integer, default 0)
following_count (integer, default 0)
post_count (integer, default 0)
created_at (timestamp, default NOW())
updated_at (timestamp, default NOW())
```

**posts table (photos):**
```sql
id (uuid, primary key)
user_id (uuid, FK → users.id, NOT NULL)
image_url (varchar, NOT NULL)
caption (text)
alt_text (text)
location (varchar)
like_count (integer, default 0)
comment_count (integer, default 0)
view_count (integer, default 0)
is_deleted (boolean, default false)
created_at (timestamp, default NOW())
updated_at (timestamp, default NOW())
```

**videos table:**
```sql
id (uuid, primary key)
user_id (uuid, FK → users.id, NOT NULL)
title (varchar, NOT NULL)
description (text)
video_url (varchar, NOT NULL)
thumbnail_url (varchar, NOT NULL)
duration (integer) -- seconds
resolution (varchar)
file_size (bigint) -- bytes
visibility (enum: 'public', 'unlisted', 'private', default 'public')
view_count (integer, default 0)
like_count (integer, default 0)
comment_count (integer, default 0)
share_count (integer, default 0)
processing_status (enum: 'uploading', 'processing', 'ready', 'failed')
is_deleted (boolean, default false)
created_at (timestamp, default NOW())
updated_at (timestamp, default NOW())
```

**video_versions table (multiple resolutions):**
```sql
id (uuid, primary key)
video_id (uuid, FK → videos.id, NOT NULL)
resolution (varchar) -- '1080p', '720p', '480p', '360p'
video_url (varchar, NOT NULL)
file_size (bigint)
created_at (timestamp, default NOW())
UNIQUE(video_id, resolution)
```

**follows table:**
```sql
id (uuid, primary key)
follower_id (uuid, FK → users.id, NOT NULL)
following_id (uuid, FK → users.id, NOT NULL)
created_at (timestamp, default NOW())
UNIQUE(follower_id, following_id)
CHECK (follower_id != following_id)
```

**likes table:**
```sql
id (uuid, primary key)
user_id (uuid, FK → users.id, NOT NULL)
likeable_type (enum: 'post', 'video', 'comment', NOT NULL)
likeable_id (uuid, NOT NULL)
created_at (timestamp, default NOW())
UNIQUE(user_id, likeable_type, likeable_id)
```

**comments table:**
```sql
id (uuid, primary key)
user_id (uuid, FK → users.id, NOT NULL)
commentable_type (enum: 'post', 'video', NOT NULL)
commentable_id (uuid, NOT NULL)
parent_comment_id (uuid, nullable, FK → comments.id)
content (text, NOT NULL)
like_count (integer, default 0)
is_deleted (boolean, default false)
created_at (timestamp, default NOW())
updated_at (timestamp, default NOW())
```

**hashtags table:**
```sql
id (uuid, primary key)
tag (varchar, unique, NOT NULL) -- lowercase, no #
post_count (integer, default 0)
video_count (integer, default 0)
created_at (timestamp, default NOW())
```

**post_hashtags & video_hashtags tables:**
```sql
post_id/video_id (uuid, FK, ON DELETE CASCADE)
hashtag_id (uuid, FK → hashtags.id, ON DELETE CASCADE)
created_at (timestamp, default NOW())
PRIMARY KEY (post_id/video_id, hashtag_id)
```

**notifications table:**
```sql
id (uuid, primary key)
user_id (uuid, FK → users.id, NOT NULL) -- recipient
actor_id (uuid, FK → users.id, NOT NULL)
type (enum: 'follow', 'like_post', 'like_video', 'comment', 'reply', 'mention', 'milestone')
entity_type (enum: 'post', 'video', 'comment', nullable)
entity_id (uuid, nullable)
message (text, NOT NULL)
is_read (boolean, default false)
created_at (timestamp, default NOW())
```

**analytics_events table (optional):**
```sql
id (uuid, primary key)
user_id (uuid, FK → users.id) -- creator
viewer_id (uuid, FK → users.id, nullable)
content_type (enum: 'post', 'video')
content_id (uuid, NOT NULL)
event_type (enum: 'view', 'watch_time', 'like', 'comment', 'share', 'profile_visit')
metadata (jsonb) -- source, watch_duration, device, etc.
created_at (timestamp, default NOW())
```

**messages tables (if DMs implemented):**
```sql
-- conversations table
id (uuid, primary key)
is_group (boolean, default false)
group_name (varchar, nullable)
created_at (timestamp, default NOW())
updated_at (timestamp, default NOW())

-- conversation_participants table
conversation_id (uuid, FK → conversations.id, ON DELETE CASCADE)
user_id (uuid, FK → users.id, ON DELETE CASCADE)
joined_at (timestamp, default NOW())
last_read_at (timestamp)
is_muted (boolean, default false)
PRIMARY KEY (conversation_id, user_id)

-- messages table
id (uuid, primary key)
conversation_id (uuid, FK → conversations.id, ON DELETE CASCADE, NOT NULL)
sender_id (uuid, FK → users.id, NOT NULL)
message_type (enum: 'text', 'photo', 'video', 'post_share', 'video_share')
content (text)
media_url (varchar, nullable)
shared_content_id (uuid, nullable)
is_deleted (boolean, default false)
deleted_for_everyone (boolean, default false)
created_at (timestamp, default NOW())
```

#### 5.2.3 Row Level Security (RLS) Policies

**Example policies:**

```sql
-- posts: Anyone can read public posts
CREATE POLICY "Public posts viewable by all"
ON posts FOR SELECT
USING (is_deleted = false);

-- posts: Users can insert their own posts
CREATE POLICY "Users insert own posts"
ON posts FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- posts: Users can update/delete own posts
CREATE POLICY "Users update own posts"
ON posts FOR UPDATE
USING (auth.uid() = user_id);

-- videos: Visibility-based access
CREATE POLICY "Videos viewable based on visibility"
ON videos FOR SELECT
USING (
  (visibility = 'public' AND is_deleted = false) OR
  (visibility = 'unlisted' AND is_deleted = false) OR
  (visibility = 'private' AND auth.uid() = user_id)
);

-- follows: Anyone can read, users can follow/unfollow
CREATE POLICY "Follows viewable by all"
ON follows FOR SELECT
USING (true);

CREATE POLICY "Users can follow others"
ON follows FOR INSERT
WITH CHECK (auth.uid() = follower_id);

-- messages: Users can only read their own conversations
CREATE POLICY "Users read own messages"
ON messages FOR SELECT
USING (
  conversation_id IN (
    SELECT conversation_id FROM conversation_participants
    WHERE user_id = auth.uid()
  )
);
```

#### 5.2.4 Database Functions (Triggers)

**Increment follower count:**
```sql
CREATE OR REPLACE FUNCTION increment_follower_count()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE users SET following_count = following_count + 1
  WHERE id = NEW.follower_id;

  UPDATE users SET follower_count = follower_count + 1
  WHERE id = NEW.following_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_follow_insert
AFTER INSERT ON follows
FOR EACH ROW
EXECUTE FUNCTION increment_follower_count();
```

**Similar triggers for:**
- Decrement on unfollow
- Increment/decrement like counts
- Increment/decrement comment counts

**Feed query function:**
```sql
CREATE OR REPLACE FUNCTION get_user_feed(
  p_user_id uuid,
  p_limit integer DEFAULT 20,
  p_offset integer DEFAULT 0
)
RETURNS TABLE (...) AS $$
BEGIN
  RETURN QUERY
  (
    SELECT 'post'::text, p.id, p.user_id, p.created_at, ...
    FROM posts p
    INNER JOIN follows f ON p.user_id = f.following_id
    WHERE f.follower_id = p_user_id AND p.is_deleted = false

    UNION ALL

    SELECT 'video'::text, v.id, v.user_id, v.created_at, ...
    FROM videos v
    INNER JOIN follows f ON v.user_id = f.following_id
    WHERE f.follower_id = p_user_id
      AND v.is_deleted = false
      AND v.processing_status = 'ready'
  )
  ORDER BY created_at DESC
  LIMIT p_limit OFFSET p_offset;
END;
$$ LANGUAGE plpgsql;
```

### 5.3 Media Storage & CDN (Supabase Storage)

#### 5.3.1 Storage Buckets
**profile-pictures** (public):
- Path: `{userId}/avatar.jpg`
- Max: 5MB, formats: JPG, PNG, WebP

**photos** (public):
- Path: `{userId}/{postId}/original.jpg`
- Thumbnails: `{userId}/{postId}/thumbnail.jpg`
- Max: 20MB

**videos** (public):
- Original: `{userId}/{videoId}/original.mp4` (private)
- Processed: `{userId}/{videoId}/1080p.mp4`, `/720p.mp4`, etc. (public)
- Thumbnails: `{userId}/{videoId}/thumbnail.jpg`
- Max: 5GB

#### 5.3.2 Upload Flow
1. Client validates file (type, size)
2. Generate UUID for post/video
3. Upload to Supabase Storage (resumable uploads via TUS)
4. Display progress bar
5. **Photos**: Generate thumbnail client-side or server-side
6. **Videos**: Trigger Edge Function to process
7. Edge Function:
   - Download video
   - Use FFmpeg to transcode (1080p, 720p, 480p, 360p)
   - Extract thumbnails
   - Upload processed files
   - Update video record: `processing_status = 'ready'`
8. Send notification to user

#### 5.3.3 CDN Configuration
- Supabase Storage includes built-in CDN
- Caching headers:
  - Videos/photos: 1 year cache
  - Thumbnails: 30 days cache
  - Profile pictures: 1 day cache
- Serve WebP with JPG fallback

#### 5.3.4 Video Streaming
- Progressive download for MVP
- Adaptive bitrate (HLS/DASH) optional for better UX
- Use video.js or hls.js for playback

### 5.4 Security Requirements

#### 5.4.1 Authentication & Authorization
- Passwords hashed with bcrypt (Supabase handles)
- JWT tokens (1 hour access, 30 day refresh)
- RLS policies enforce data access
- Rate limiting on login (5 attempts/hour)

#### 5.4.2 Data Protection
- All traffic over HTTPS
- Database encryption at rest (Supabase default)
- Input validation (client and server):
  - XSS prevention (React escapes by default)
  - SQL injection prevention (parameterized queries)
  - File upload validation (type, size, magic bytes)
- CSRF protection (JWT in header, not cookies)
- GDPR/CCPA compliance: data export, account deletion
- Age requirement: 16+ (simplify compliance)

#### 5.4.3 Content Security
- Validate file extensions and MIME types
- Scan uploads for malware (ClamAV or cloud service)
- Signed URLs for uploads
- **User reporting**: Report button on all content
- **Automated moderation** (optional):
  - Image: Google Cloud Vision, AWS Rekognition
  - Text: Perspective API for toxicity
  - Hash-based: PhotoDNA for CSAM
- **Rate limiting**:
  - 50 posts/day
  - 100 comments/day
  - 200 follows/day
- **New user restrictions**: Lower limits for accounts <7 days

#### 5.4.4 API Security
- Rate limiting: 100 requests/minute per user
- CORS: Allow only production domain
- Logging: Auth events, failed attempts
- Monitoring: Error rates, suspicious activity

### 5.5 Scalability

#### 5.5.1 Database Scaling
- Start with Supabase Free tier for MVP, upgrade to Pro for launch
- Use read replicas (Supabase Pro/Team)
- Connection pooling (PgBouncer built-in)
- Indexing on all foreign keys and queried columns
- Caching with Redis/Upstash
- Pagination (cursor-based or offset)

#### 5.5.2 Storage Scaling
- Compress images (WebP, 80% quality)
- Compress videos (H.265 codec)
- Delete old low-view content (with consent)
- Storage quotas: 10GB for free users
- Monitor bandwidth usage

#### 5.5.3 Frontend Performance
- Code splitting (Next.js automatic)
- Image optimization (Next.js Image component)
- Lazy loading (Intersection Observer)
- Caching with SWR or React Query
- Bundle size analysis

#### 5.5.4 Real-Time Scalability
- Supabase Realtime scales to thousands of connections
- Subscribe only to relevant channels
- Unsubscribe on unmount
- Throttle frequent events

#### 5.5.5 Monitoring
- Sentry for error tracking
- Core Web Vitals monitoring
- Supabase dashboard for metrics
- Billing alerts for storage/bandwidth

---

## 6. UX Requirements

### 6.1 Design Principles

#### 6.1.1 Visual Design
- **Clean & Modern UI**: Minimalist, content-focused
- **Color Scheme**: Primary brand color, secondary accent, neutral grays, semantic colors
- **Light & Dark Mode**: Toggle in settings, persist preference
- **Typography**: Sans-serif (Inter, Roboto), 14-16px body text, high contrast
- **Iconography**: Consistent style (Heroicons, Lucide, Font Awesome)

#### 6.1.2 Responsive Design
- **Mobile** (320-768px): Single column, bottom nav, full-width cards
- **Tablet** (768-1024px): Two-column grids, wider content
- **Desktop** (1024px+): Three-column layouts, max-width 1200px
- **Touch-Friendly**: 44x44px tap targets, adequate spacing

#### 6.1.3 Smooth Transitions & Animations
- Page transitions: 200-300ms fade/slide
- Loading states: Skeleton screens with shimmer
- Micro-interactions: Like animation, button feedback
- Smooth scrolling and pull-to-refresh

#### 6.1.4 Accessibility (WCAG 2.1 AA)
- Semantic HTML, ARIA labels
- Keyboard navigation, visible focus indicators
- 4.5:1 color contrast for text
- Support text scaling up to 200%
- Respect `prefers-reduced-motion`

### 6.2 Navigation Structure

#### 6.2.1 Main Navigation
**Top Header Bar (fixed):**
- Left: Pixel Share logo
- Center: Search bar (desktop)
- Right: Create button, Notifications bell, Profile avatar, DM icon

**Navigation Tabs:**
- Desktop: Top header
- Mobile: Bottom nav bar (Home, Search, Upload, Notifications, Profile)

**Profile Dropdown:**
- My Profile
- Analytics
- Settings
- Help & Support
- Log Out

#### 6.2.2 Mobile Bottom Navigation
- 5 tabs (icon-only)
- Active tab highlighted
- Upload in center (larger)

### 6.3 Error Handling & Feedback

#### 6.3.1 Error Messages
- User-friendly language (no tech jargon)
- Explain what happened and how to fix
- Inline validation on forms
- Toast notifications (3-5 seconds)

#### 6.3.2 Loading States
- Spinners for button actions
- Progress bars for uploads
- Skeleton screens for content
- Empty states with helpful messages

#### 6.3.3 Offline Support (PWA - Optional)
- Offline detection banner
- Cached content display
- Queue actions for sync

---

## 7. User Flow

### 7.1 Onboarding Flow
1. User visits pixelshare.com
2. Login/Sign-Up Screen
   - **Sign Up**: Email, username, password → Verify email → Home Feed
   - **Login**: Email/username, password → Home Feed
   - **Forgot Password**: Email → Reset link → New password → Login
3. Optional onboarding: Follow creators, set up profile

### 7.2 Main App Flow
**Home Feed:**
- Scroll mixed content (photos/videos)
- Click photo → Photo Viewer
- Click video → Video Player
- Click username → User Profile
- Like, comment, share

**Upload:**
- Click Upload (+) button
- **Photo**: Select → Edit/filter → Caption/hashtags → Share
- **Video**: Select → Upload → Add metadata/thumbnail → Processing → Ready

**Search:**
- Click Search → Enter query
- View results: Users, Videos, Photos, Hashtags
- Click result to view

**Notifications:**
- Click Bell icon → View notifications
- Click notification → Navigate to content

**Profile:**
- View own/other profiles
- Edit profile (own only)
- View content grid
- Follow/unfollow

**Engagement:**
- Like → Heart animation
- Comment → Type and post
- Reply to comment → Nested reply
- Share → Copy link or share externally

**Explore (optional):**
- View trending content
- Browse categories
- Follow recommended creators

**Messages (optional):**
- Click DM icon → Conversations list
- Select conversation → Chat
- Send text/media/share posts

### 7.3 Edge Cases
- Email verification
- Password reset
- Report content
- Block user
- Account deletion
- Video processing failure
- Offline viewing (PWA)

---

## 8. Success Metrics

### 8.1 Primary KPIs

#### 8.1.1 User Acquisition & Growth
- Total registered users
- DAU (Daily Active Users)
- MAU (Monthly Active Users)
- DAU/MAU ratio (target: >20%)
- Retention: Day 1 (>40%), Day 7 (>25%), Day 30 (>15%)

#### 8.1.2 Content Creation
- Upload frequency (posts/videos per user per week)
- Creator activation rate (>30% upload within 7 days)
- Upload success rate (>95%)

#### 8.1.3 Engagement
- Watch time (total and average)
- Engagement rate: (Likes + Comments + Shares) / Views (>5%)
- Session duration (>8 minutes)
- Sessions per user per day (>3)

#### 8.1.4 Social Graph
- Follower growth rate
- Follow ratio
- Network density

#### 8.1.5 Discovery
- Search usage (>40% weekly)
- Hashtag adoption (>60%)
- Explore page CTR (>15%)

### 8.2 Secondary Metrics
- Page load time (<2s)
- Video buffering rate (<5%)
- API response time (<500ms)
- Error rate (<1%)
- NPS (>30)
- User satisfaction (>4/5)

### 8.3 Success Milestones

**MVP (Months 1-2):**
- 1,000 users
- 25% Day 1 retention
- 5,000 uploads
- 50,000 video views

**Beta (Months 3-4):**
- 10,000 users
- 30% Day 1, 15% Day 30 retention
- 50,000 uploads
- 1M video views

**Public Launch (Months 5-6):**
- 50,000 users
- 35% Day 1, 20% Day 30 retention
- 250,000 uploads
- 10M video views

**Growth (Months 7-12):**
- 100,000 users
- 40% Day 1, 25% Day 30 retention
- 1M uploads
- 50M video views

**Scale (Year 2+):**
- 1M users
- 500M video views
- 50,000 daily active creators

---

## 9. Risks & Challenges

### 9.1 Technical Challenges

#### 9.1.1 Large Video Files (2-3 hours)
**Risks**: Slow uploads, processing costs, storage costs, failures

**Mitigations**:
- Resumable uploads (TUS protocol)
- Client-side compression (optional)
- Direct-to-storage uploads
- File size limits (5GB max)
- Asynchronous processing
- Selective transcoding
- Bandwidth optimization (adaptive streaming)

#### 9.1.2 Storage & Bandwidth Costs
**Risks**: Expensive at scale

**Mitigations**:
- Aggressive compression (H.265, WebP)
- Tiered storage (hot/cold)
- CDN optimization
- Storage quotas for free users
- Delete old content (with consent)
- Monitor and alert on costs

#### 9.1.3 Video Processing Delays
**Risks**: 30-120 min processing time frustrates creators

**Mitigations**:
- Clear expectations and progress updates
- Allow navigation away
- Queue system
- Distributed processing (or external service)
- Partial availability (lower resolution first)

#### 9.1.4 Database Scalability
**Risks**: Slow queries at scale

**Mitigations**:
- Indexing
- Read replicas
- Caching (Redis)
- Pagination
- Denormalization

### 9.2 Content Moderation Without Admins

#### 9.2.1 Inappropriate Content
**Risks**: Spam, harassment, explicit material

**Mitigations**:
- User reporting (auto-hide after threshold)
- Automated moderation (ML for images/text)
- Hash-based detection (PhotoDNA)
- Rate limiting
- New user restrictions
- Community guidelines

#### 9.2.2 Copyright Infringement
**Risks**: Users upload copyrighted content

**Mitigations**:
- Content ID system (long-term)
- DMCA takedown process
- User education
- Watermarking (optional)

#### 9.2.3 Spam & Bots
**Risks**: Fake accounts, spam comments

**Mitigations**:
- CAPTCHA on sign-up
- Email verification
- Behavioral analysis
- Phone verification (optional)
- Verified badge system

### 9.3 User Retention & Engagement

#### 9.3.1 Cold Start Problem
**Risks**: New users see empty feed, abandon platform

**Mitigations**:
- Onboarding follow suggestions
- Default trending feed
- Personalized recommendations
- Invite friends feature

#### 9.3.2 Feed Curation Quality
**Risks**: Irrelevant content, disengagement

**Mitigations**:
- Start with chronological feed
- Gradual algorithm introduction
- User feedback mechanisms
- A/B testing

#### 9.3.3 Creator Burnout
**Risks**: Low engagement discourages creators

**Mitigations**:
- Analytics dashboard
- Quality over quantity messaging
- Creator resources
- Milestone celebrations

### 9.4 Business & Operational Risks

#### 9.4.1 Monetization
**Risks**: No revenue, unsustainable costs

**Mitigations**:
- Phase 1: Free (growth focus)
- Phase 2: Non-intrusive ads
- Phase 3: Premium subscriptions
- Phase 4: Creator revenue sharing

#### 9.4.2 Competition
**Risks**: Instagram, YouTube, TikTok dominance

**Mitigations**:
- Differentiate (hybrid photo/video)
- Target niche communities
- Unique features (better analytics, easier monetization)
- Build strong community

#### 9.4.3 Compliance
**Risks**: GDPR, CCPA, COPPA requirements

**Mitigations**:
- Data export/deletion
- Clear privacy policy
- Age verification (16+)
- Legal counsel review

#### 9.4.4 Platform Abuse
**Risks**: Harassment, illegal activity

**Mitigations**:
- Reporting and blocking
- Quick response to reports
- Proactive detection
- Safety partnerships
- Transparency reports

---

## 10. Launch Plan & Roadmap

### 10.1 MVP - Phase 1 (3-4 months)
**Core Features:**
- Email/password auth
- Basic home feed (chronological)
- Photo upload and viewer
- Video upload, processing, player
- User profiles with follower counts
- Follow/unfollow
- Likes and comments
- Basic search (users)
- Notifications

**Success Criteria:**
- Stable on web
- 95%+ upload success
- <2s feed load
- Complete user flow works

### 10.2 Beta Launch - Phase 2 (1-2 months)
**Additional Features:**
- Hashtag support
- Video player enhancements
- Profile editing
- Basic analytics
- Improved search
- Share functionality

**Success Criteria:**
- 1,000 beta users
- 25%+ Day 7 retention
- 50+ daily active creators
- Positive feedback

### 10.3 Public Launch - Phase 3 (2-3 months)
**Additional Features:**
- Explore/trending page
- Creator analytics dashboard
- Photo filters and editing
- Comment replies and likes
- Improved notifications
- Performance optimizations

**Success Criteria:**
- 10,000 users in month 1
- 4.0+ rating (if applicable)
- Press coverage

### 10.4 Growth Phase - Phase 4 (Months 7-12)
**Potential Features:**
- Direct messaging
- Advanced video editing
- Live streaming (optional)
- Monetization features
- Third-party integrations
- Web version enhancements

**Success Criteria:**
- 100,000 users
- Sustained DAU growth
- Revenue generation
- Strong creator community

---

## 11. Appendix

### 11.1 Glossary
- **DAU**: Daily Active Users
- **MAU**: Monthly Active Users
- **Engagement Rate**: % of viewers who interact
- **CDN**: Content Delivery Network
- **Transcoding**: Converting video formats/resolutions
- **RLS**: Row Level Security (Supabase)
- **JWT**: JSON Web Token

### 11.2 References
- Instagram, YouTube, TikTok (design inspiration)
- React/Next.js documentation
- Supabase documentation
- GDPR, CCPA, COPPA guidelines

### 11.3 Open Questions
1. Google Auth implementation approach (Firebase vs direct OAuth)
2. Video length: Confirm 2-3 hours is appropriate
3. Monetization timeline
4. Content moderation: Automated only or hire team?
5. DMs: MVP or Phase 4?
6. Mobile app: Future consideration?

---

**End of PRD**

*This document serves as the comprehensive blueprint for building Pixel Share. All features, technical decisions, and success metrics should align with this vision.*

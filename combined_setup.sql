-- ================================================
-- PIXEL SHARE DATABASE SCHEMA
-- ================================================
-- This SQL file creates all tables, indexes, triggers, and functions
-- for the Pixel Share social media platform
-- Run this in your Supabase SQL editor

-- ================================================
-- EXTENSIONS
-- ================================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ================================================
-- CUSTOM TYPES (ENUMS)
-- ================================================
CREATE TYPE visibility_type AS ENUM ('public', 'unlisted', 'private');
CREATE TYPE processing_status AS ENUM ('uploading', 'processing', 'ready', 'failed');
CREATE TYPE likeable_type AS ENUM ('post', 'video', 'comment');
CREATE TYPE commentable_type AS ENUM ('post', 'video');
CREATE TYPE notification_type AS ENUM ('follow', 'like_post', 'like_video', 'comment', 'reply', 'mention', 'milestone');
CREATE TYPE entity_type AS ENUM ('post', 'video', 'comment');

-- ================================================
-- USERS TABLE (extends auth.users)
-- ================================================
CREATE TABLE public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email VARCHAR(255) NOT NULL UNIQUE,
  username VARCHAR(50) NOT NULL UNIQUE,
  display_name VARCHAR(100),
  bio TEXT CHECK (char_length(bio) <= 150),
  profile_picture_url VARCHAR(500),
  website_url VARCHAR(500),
  follower_count INTEGER DEFAULT 0 CHECK (follower_count >= 0),
  following_count INTEGER DEFAULT 0 CHECK (following_count >= 0),
  post_count INTEGER DEFAULT 0 CHECK (post_count >= 0),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for users
CREATE INDEX idx_users_username ON public.users(username);
CREATE INDEX idx_users_email ON public.users(email);
CREATE INDEX idx_users_created_at ON public.users(created_at DESC);

-- ================================================
-- POSTS TABLE (for photos)
-- ================================================
CREATE TABLE public.posts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  image_url VARCHAR(500) NOT NULL,
  caption TEXT CHECK (char_length(caption) <= 2200),
  alt_text TEXT CHECK (char_length(alt_text) <= 500),
  location VARCHAR(200),
  like_count INTEGER DEFAULT 0 CHECK (like_count >= 0),
  comment_count INTEGER DEFAULT 0 CHECK (comment_count >= 0),
  view_count INTEGER DEFAULT 0 CHECK (view_count >= 0),
  is_deleted BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for posts
CREATE INDEX idx_posts_user_id ON public.posts(user_id);
CREATE INDEX idx_posts_created_at ON public.posts(created_at DESC);
CREATE INDEX idx_posts_user_created ON public.posts(user_id, created_at DESC);
CREATE INDEX idx_posts_is_deleted ON public.posts(is_deleted) WHERE is_deleted = FALSE;

-- ================================================
-- VIDEOS TABLE
-- ================================================
CREATE TABLE public.videos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  title VARCHAR(100) NOT NULL,
  description TEXT CHECK (char_length(description) <= 5000),
  video_url VARCHAR(500) NOT NULL,
  thumbnail_url VARCHAR(500) NOT NULL,
  duration INTEGER DEFAULT 0 CHECK (duration >= 0), -- in seconds
  resolution VARCHAR(20),
  file_size BIGINT CHECK (file_size >= 0),
  visibility visibility_type DEFAULT 'public',
  view_count INTEGER DEFAULT 0 CHECK (view_count >= 0),
  like_count INTEGER DEFAULT 0 CHECK (like_count >= 0),
  comment_count INTEGER DEFAULT 0 CHECK (comment_count >= 0),
  share_count INTEGER DEFAULT 0 CHECK (share_count >= 0),
  processing_status processing_status DEFAULT 'uploading',
  is_deleted BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for videos
CREATE INDEX idx_videos_user_id ON public.videos(user_id);
CREATE INDEX idx_videos_created_at ON public.videos(created_at DESC);
CREATE INDEX idx_videos_user_created ON public.videos(user_id, created_at DESC);
CREATE INDEX idx_videos_processing_status ON public.videos(processing_status);
CREATE INDEX idx_videos_visibility ON public.videos(visibility);
CREATE INDEX idx_videos_is_deleted ON public.videos(is_deleted) WHERE is_deleted = FALSE;

-- ================================================
-- VIDEO VERSIONS TABLE (for multiple resolutions)
-- ================================================
CREATE TABLE public.video_versions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  video_id UUID NOT NULL REFERENCES public.videos(id) ON DELETE CASCADE,
  resolution VARCHAR(20) NOT NULL, -- '1080p', '720p', '480p', '360p'
  video_url VARCHAR(500) NOT NULL,
  file_size BIGINT CHECK (file_size >= 0),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(video_id, resolution)
);

-- Index for video versions
CREATE INDEX idx_video_versions_video_id ON public.video_versions(video_id);

-- ================================================
-- FOLLOWS TABLE
-- ================================================
CREATE TABLE public.follows (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  follower_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  following_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(follower_id, following_id),
  CHECK (follower_id != following_id) -- Prevent self-follows
);

-- Indexes for follows
CREATE INDEX idx_follows_follower_id ON public.follows(follower_id);
CREATE INDEX idx_follows_following_id ON public.follows(following_id);
CREATE INDEX idx_follows_created_at ON public.follows(created_at DESC);

-- ================================================
-- LIKES TABLE
-- ================================================
CREATE TABLE public.likes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  likeable_type likeable_type NOT NULL,
  likeable_id UUID NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, likeable_type, likeable_id)
);

-- Indexes for likes
CREATE INDEX idx_likes_user_id ON public.likes(user_id);
CREATE INDEX idx_likes_likeable ON public.likes(likeable_type, likeable_id);
CREATE INDEX idx_likes_created_at ON public.likes(created_at DESC);

-- ================================================
-- COMMENTS TABLE
-- ================================================
CREATE TABLE public.comments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  commentable_type commentable_type NOT NULL,
  commentable_id UUID NOT NULL,
  parent_comment_id UUID REFERENCES public.comments(id) ON DELETE CASCADE,
  content TEXT NOT NULL CHECK (char_length(content) <= 500 AND char_length(content) > 0),
  like_count INTEGER DEFAULT 0 CHECK (like_count >= 0),
  is_deleted BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for comments
CREATE INDEX idx_comments_user_id ON public.comments(user_id);
CREATE INDEX idx_comments_commentable ON public.comments(commentable_type, commentable_id);
CREATE INDEX idx_comments_parent ON public.comments(parent_comment_id);
CREATE INDEX idx_comments_created_at ON public.comments(created_at DESC);

-- ================================================
-- NOTIFICATIONS TABLE
-- ================================================
CREATE TABLE public.notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  actor_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  type notification_type NOT NULL,
  entity_type entity_type,
  entity_id UUID,
  message TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for notifications
CREATE INDEX idx_notifications_user_id ON public.notifications(user_id, created_at DESC);
CREATE INDEX idx_notifications_is_read ON public.notifications(user_id, is_read);
CREATE INDEX idx_notifications_created_at ON public.notifications(created_at DESC);

-- ================================================
-- HASHTAGS TABLE
-- ================================================
CREATE TABLE public.hashtags (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tag VARCHAR(100) NOT NULL UNIQUE, -- lowercase, no # symbol
  post_count INTEGER DEFAULT 0 CHECK (post_count >= 0),
  video_count INTEGER DEFAULT 0 CHECK (video_count >= 0),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index for hashtags
CREATE INDEX idx_hashtags_tag ON public.hashtags(tag);
CREATE INDEX idx_hashtags_post_count ON public.hashtags(post_count DESC);

-- ================================================
-- POST_HASHTAGS TABLE (junction table)
-- ================================================
CREATE TABLE public.post_hashtags (
  post_id UUID NOT NULL REFERENCES public.posts(id) ON DELETE CASCADE,
  hashtag_id UUID NOT NULL REFERENCES public.hashtags(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  PRIMARY KEY (post_id, hashtag_id)
);

-- Index for post_hashtags
CREATE INDEX idx_post_hashtags_hashtag_id ON public.post_hashtags(hashtag_id);

-- ================================================
-- VIDEO_HASHTAGS TABLE (junction table)
-- ================================================
CREATE TABLE public.video_hashtags (
  video_id UUID NOT NULL REFERENCES public.videos(id) ON DELETE CASCADE,
  hashtag_id UUID NOT NULL REFERENCES public.hashtags(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  PRIMARY KEY (video_id, hashtag_id)
);

-- Index for video_hashtags
CREATE INDEX idx_video_hashtags_hashtag_id ON public.video_hashtags(hashtag_id);

-- ================================================
-- TRIGGERS & FUNCTIONS
-- ================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply updated_at trigger to relevant tables
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_posts_updated_at BEFORE UPDATE ON public.posts
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_videos_updated_at BEFORE UPDATE ON public.videos
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_comments_updated_at BEFORE UPDATE ON public.comments
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_hashtags_updated_at BEFORE UPDATE ON public.hashtags
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ================================================
-- FOLLOWER COUNT TRIGGERS
-- ================================================

-- Increment follower counts when follow is created
CREATE OR REPLACE FUNCTION increment_follower_count()
RETURNS TRIGGER AS $$
BEGIN
  -- Increment following_count for follower
  UPDATE public.users
  SET following_count = following_count + 1
  WHERE id = NEW.follower_id;

  -- Increment follower_count for user being followed
  UPDATE public.users
  SET follower_count = follower_count + 1
  WHERE id = NEW.following_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_follow_insert
AFTER INSERT ON public.follows
FOR EACH ROW EXECUTE FUNCTION increment_follower_count();

-- Decrement follower counts when follow is deleted
CREATE OR REPLACE FUNCTION decrement_follower_count()
RETURNS TRIGGER AS $$
BEGIN
  -- Decrement following_count for follower
  UPDATE public.users
  SET following_count = GREATEST(following_count - 1, 0)
  WHERE id = OLD.follower_id;

  -- Decrement follower_count for user being unfollowed
  UPDATE public.users
  SET follower_count = GREATEST(follower_count - 1, 0)
  WHERE id = OLD.following_id;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_follow_delete
AFTER DELETE ON public.follows
FOR EACH ROW EXECUTE FUNCTION decrement_follower_count();

-- ================================================
-- LIKE COUNT TRIGGERS
-- ================================================

-- Increment like count when like is created
CREATE OR REPLACE FUNCTION increment_like_count()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.likeable_type = 'post' THEN
    UPDATE public.posts
    SET like_count = like_count + 1
    WHERE id = NEW.likeable_id;
  ELSIF NEW.likeable_type = 'video' THEN
    UPDATE public.videos
    SET like_count = like_count + 1
    WHERE id = NEW.likeable_id;
  ELSIF NEW.likeable_type = 'comment' THEN
    UPDATE public.comments
    SET like_count = like_count + 1
    WHERE id = NEW.likeable_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_like_insert
AFTER INSERT ON public.likes
FOR EACH ROW EXECUTE FUNCTION increment_like_count();

-- Decrement like count when like is deleted
CREATE OR REPLACE FUNCTION decrement_like_count()
RETURNS TRIGGER AS $$
BEGIN
  IF OLD.likeable_type = 'post' THEN
    UPDATE public.posts
    SET like_count = GREATEST(like_count - 1, 0)
    WHERE id = OLD.likeable_id;
  ELSIF OLD.likeable_type = 'video' THEN
    UPDATE public.videos
    SET like_count = GREATEST(like_count - 1, 0)
    WHERE id = OLD.likeable_id;
  ELSIF OLD.likeable_type = 'comment' THEN
    UPDATE public.comments
    SET like_count = GREATEST(like_count - 1, 0)
    WHERE id = OLD.likeable_id;
  END IF;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_like_delete
AFTER DELETE ON public.likes
FOR EACH ROW EXECUTE FUNCTION decrement_like_count();

-- ================================================
-- COMMENT COUNT TRIGGERS
-- ================================================

-- Increment comment count when comment is created
CREATE OR REPLACE FUNCTION increment_comment_count()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.commentable_type = 'post' THEN
    UPDATE public.posts
    SET comment_count = comment_count + 1
    WHERE id = NEW.commentable_id;
  ELSIF NEW.commentable_type = 'video' THEN
    UPDATE public.videos
    SET comment_count = comment_count + 1
    WHERE id = NEW.commentable_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_comment_insert
AFTER INSERT ON public.comments
FOR EACH ROW EXECUTE FUNCTION increment_comment_count();

-- Decrement comment count when comment is deleted
CREATE OR REPLACE FUNCTION decrement_comment_count()
RETURNS TRIGGER AS $$
BEGIN
  IF OLD.commentable_type = 'post' THEN
    UPDATE public.posts
    SET comment_count = GREATEST(comment_count - 1, 0)
    WHERE id = OLD.commentable_id;
  ELSIF OLD.commentable_type = 'video' THEN
    UPDATE public.videos
    SET comment_count = GREATEST(comment_count - 1, 0)
    WHERE id = OLD.commentable_id;
  END IF;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_comment_delete
AFTER DELETE ON public.comments
FOR EACH ROW EXECUTE FUNCTION decrement_comment_count();

-- ================================================
-- HASHTAG COUNT TRIGGERS
-- ================================================

-- Increment hashtag counts
CREATE OR REPLACE FUNCTION increment_hashtag_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_TABLE_NAME = 'post_hashtags' THEN
    UPDATE public.hashtags
    SET post_count = post_count + 1
    WHERE id = NEW.hashtag_id;
  ELSIF TG_TABLE_NAME = 'video_hashtags' THEN
    UPDATE public.hashtags
    SET video_count = video_count + 1
    WHERE id = NEW.hashtag_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_post_hashtag_insert
AFTER INSERT ON public.post_hashtags
FOR EACH ROW EXECUTE FUNCTION increment_hashtag_count();

CREATE TRIGGER after_video_hashtag_insert
AFTER INSERT ON public.video_hashtags
FOR EACH ROW EXECUTE FUNCTION increment_hashtag_count();

-- Decrement hashtag counts
CREATE OR REPLACE FUNCTION decrement_hashtag_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_TABLE_NAME = 'post_hashtags' THEN
    UPDATE public.hashtags
    SET post_count = GREATEST(post_count - 1, 0)
    WHERE id = OLD.hashtag_id;
  ELSIF TG_TABLE_NAME = 'video_hashtags' THEN
    UPDATE public.hashtags
    SET video_count = GREATEST(video_count - 1, 0)
    WHERE id = OLD.hashtag_id;
  END IF;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_post_hashtag_delete
AFTER DELETE ON public.post_hashtags
FOR EACH ROW EXECUTE FUNCTION decrement_hashtag_count();

CREATE TRIGGER after_video_hashtag_delete
AFTER DELETE ON public.video_hashtags
FOR EACH ROW EXECUTE FUNCTION decrement_hashtag_count();

-- ================================================
-- POST COUNT TRIGGER
-- ================================================

-- Increment user post count
CREATE OR REPLACE FUNCTION increment_post_count()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.users
  SET post_count = post_count + 1
  WHERE id = NEW.user_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_post_insert
AFTER INSERT ON public.posts
FOR EACH ROW EXECUTE FUNCTION increment_post_count();

CREATE TRIGGER after_video_insert
AFTER INSERT ON public.videos
FOR EACH ROW EXECUTE FUNCTION increment_post_count();

-- ================================================
-- HELPER FUNCTIONS
-- ================================================

-- Function to get user feed (posts and videos from followed users)
CREATE OR REPLACE FUNCTION get_user_feed(
  p_user_id UUID,
  p_limit INTEGER DEFAULT 20,
  p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (
  content_type TEXT,
  content_id UUID,
  user_id UUID,
  username VARCHAR,
  display_name VARCHAR,
  profile_picture_url VARCHAR,
  created_at TIMESTAMP WITH TIME ZONE,
  like_count INTEGER,
  comment_count INTEGER,
  -- Post-specific fields
  image_url VARCHAR,
  caption TEXT,
  -- Video-specific fields
  title VARCHAR,
  description TEXT,
  video_url VARCHAR,
  thumbnail_url VARCHAR,
  duration INTEGER,
  view_count INTEGER
) AS $$
BEGIN
  RETURN QUERY
  (
    SELECT
      'post'::TEXT as content_type,
      p.id as content_id,
      p.user_id,
      u.username,
      u.display_name,
      u.profile_picture_url,
      p.created_at,
      p.like_count,
      p.comment_count,
      p.image_url,
      p.caption,
      NULL::VARCHAR as title,
      NULL::TEXT as description,
      NULL::VARCHAR as video_url,
      NULL::VARCHAR as thumbnail_url,
      NULL::INTEGER as duration,
      NULL::INTEGER as view_count
    FROM public.posts p
    INNER JOIN public.follows f ON p.user_id = f.following_id
    INNER JOIN public.users u ON p.user_id = u.id
    WHERE f.follower_id = p_user_id AND p.is_deleted = FALSE

    UNION ALL

    SELECT
      'video'::TEXT as content_type,
      v.id as content_id,
      v.user_id,
      u.username,
      u.display_name,
      u.profile_picture_url,
      v.created_at,
      v.like_count,
      v.comment_count,
      NULL::VARCHAR as image_url,
      NULL::TEXT as caption,
      v.title,
      v.description,
      v.video_url,
      v.thumbnail_url,
      v.duration,
      v.view_count
    FROM public.videos v
    INNER JOIN public.follows f ON v.user_id = f.following_id
    INNER JOIN public.users u ON v.user_id = u.id
    WHERE f.follower_id = p_user_id
      AND v.is_deleted = FALSE
      AND v.processing_status = 'ready'
      AND v.visibility = 'public'
  )
  ORDER BY created_at DESC
  LIMIT p_limit OFFSET p_offset;
END;
$$ LANGUAGE plpgsql;

-- ================================================
-- FULL-TEXT SEARCH SETUP
-- ================================================

-- Add full-text search columns
ALTER TABLE public.users ADD COLUMN search_vector tsvector;
ALTER TABLE public.posts ADD COLUMN search_vector tsvector;
ALTER TABLE public.videos ADD COLUMN search_vector tsvector;

-- Create indexes for full-text search
CREATE INDEX idx_users_search ON public.users USING gin(search_vector);
CREATE INDEX idx_posts_search ON public.posts USING gin(search_vector);
CREATE INDEX idx_videos_search ON public.videos USING gin(search_vector);

-- Functions to update search vectors
CREATE OR REPLACE FUNCTION update_users_search_vector()
RETURNS TRIGGER AS $$
BEGIN
  NEW.search_vector =
    setweight(to_tsvector('english', COALESCE(NEW.username, '')), 'A') ||
    setweight(to_tsvector('english', COALESCE(NEW.display_name, '')), 'B') ||
    setweight(to_tsvector('english', COALESCE(NEW.bio, '')), 'C');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_posts_search_vector()
RETURNS TRIGGER AS $$
BEGIN
  NEW.search_vector =
    setweight(to_tsvector('english', COALESCE(NEW.caption, '')), 'A');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_videos_search_vector()
RETURNS TRIGGER AS $$
BEGIN
  NEW.search_vector =
    setweight(to_tsvector('english', COALESCE(NEW.title, '')), 'A') ||
    setweight(to_tsvector('english', COALESCE(NEW.description, '')), 'B');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for search vectors
CREATE TRIGGER users_search_vector_update
BEFORE INSERT OR UPDATE ON public.users
FOR EACH ROW EXECUTE FUNCTION update_users_search_vector();

CREATE TRIGGER posts_search_vector_update
BEFORE INSERT OR UPDATE ON public.posts
FOR EACH ROW EXECUTE FUNCTION update_posts_search_vector();

CREATE TRIGGER videos_search_vector_update
BEFORE INSERT OR UPDATE ON public.videos
FOR EACH ROW EXECUTE FUNCTION update_videos_search_vector();

-- ================================================
-- DONE!
-- ================================================
-- Database schema created successfully
-- Next steps:
-- 1. Set up Row Level Security (RLS) policies
-- 2. Configure Storage buckets
-- 3. Set up Auth providers
-- ================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ================================================
-- This file sets up all Row Level Security policies for Pixel Share
-- Run this AFTER running supabase_schema.sql

-- ================================================
-- ENABLE RLS ON ALL TABLES
-- ================================================
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.videos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.video_versions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.follows ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.hashtags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.post_hashtags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.video_hashtags ENABLE ROW LEVEL SECURITY;

-- ================================================
-- USERS TABLE POLICIES
-- ================================================

-- Anyone can view user profiles
CREATE POLICY "Users are viewable by everyone"
ON public.users FOR SELECT
USING (true);

-- Users can insert their own profile (on sign up)
CREATE POLICY "Users can insert their own profile"
ON public.users FOR INSERT
WITH CHECK (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update their own profile"
ON public.users FOR UPDATE
USING (auth.uid() = id);

-- ================================================
-- POSTS TABLE POLICIES
-- ================================================

-- Anyone can view non-deleted posts
CREATE POLICY "Posts are viewable by everyone"
ON public.posts FOR SELECT
USING (is_deleted = FALSE);

-- Users can insert their own posts
CREATE POLICY "Users can insert their own posts"
ON public.posts FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Users can update their own posts
CREATE POLICY "Users can update their own posts"
ON public.posts FOR UPDATE
USING (auth.uid() = user_id);

-- Users can delete their own posts
CREATE POLICY "Users can delete their own posts"
ON public.posts FOR DELETE
USING (auth.uid() = user_id);

-- ================================================
-- VIDEOS TABLE POLICIES
-- ================================================

-- Videos are viewable based on visibility and owner
CREATE POLICY "Videos are viewable based on visibility"
ON public.videos FOR SELECT
USING (
  (visibility = 'public' AND is_deleted = FALSE AND processing_status = 'ready') OR
  (visibility = 'unlisted' AND is_deleted = FALSE AND processing_status = 'ready') OR
  (auth.uid() = user_id) -- Owners can see all their own videos
);

-- Users can insert their own videos
CREATE POLICY "Users can insert their own videos"
ON public.videos FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Users can update their own videos
CREATE POLICY "Users can update their own videos"
ON public.videos FOR UPDATE
USING (auth.uid() = user_id);

-- Users can delete their own videos
CREATE POLICY "Users can delete their own videos"
ON public.videos FOR DELETE
USING (auth.uid() = user_id);

-- ================================================
-- VIDEO VERSIONS TABLE POLICIES
-- ================================================

-- Video versions are viewable if the parent video is viewable
CREATE POLICY "Video versions are viewable with parent video"
ON public.video_versions FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM public.videos v
    WHERE v.id = video_id
    AND (
      (v.visibility = 'public' AND v.is_deleted = FALSE AND v.processing_status = 'ready') OR
      (v.visibility = 'unlisted' AND v.is_deleted = FALSE AND v.processing_status = 'ready') OR
      (auth.uid() = v.user_id)
    )
  )
);

-- Users can insert video versions for their own videos
CREATE POLICY "Users can insert video versions for their videos"
ON public.video_versions FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.videos v
    WHERE v.id = video_id AND v.user_id = auth.uid()
  )
);

-- ================================================
-- FOLLOWS TABLE POLICIES
-- ================================================

-- Anyone can view follows (to see follower/following lists)
CREATE POLICY "Follows are viewable by everyone"
ON public.follows FOR SELECT
USING (true);

-- Users can follow others (insert)
CREATE POLICY "Users can follow others"
ON public.follows FOR INSERT
WITH CHECK (auth.uid() = follower_id);

-- Users can unfollow (delete their own follows)
CREATE POLICY "Users can unfollow"
ON public.follows FOR DELETE
USING (auth.uid() = follower_id);

-- ================================================
-- LIKES TABLE POLICIES
-- ================================================

-- Anyone can view likes (to show like counts and who liked)
CREATE POLICY "Likes are viewable by everyone"
ON public.likes FOR SELECT
USING (true);

-- Users can like content (insert)
CREATE POLICY "Users can like content"
ON public.likes FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Users can unlike content (delete their own likes)
CREATE POLICY "Users can unlike content"
ON public.likes FOR DELETE
USING (auth.uid() = user_id);

-- ================================================
-- COMMENTS TABLE POLICIES
-- ================================================

-- Anyone can view non-deleted comments
CREATE POLICY "Comments are viewable by everyone"
ON public.comments FOR SELECT
USING (is_deleted = FALSE);

-- Users can insert comments
CREATE POLICY "Users can insert comments"
ON public.comments FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Users can update their own comments
CREATE POLICY "Users can update their own comments"
ON public.comments FOR UPDATE
USING (auth.uid() = user_id);

-- Users can delete their own comments
CREATE POLICY "Users can delete their own comments"
ON public.comments FOR DELETE
USING (auth.uid() = user_id);

-- ================================================
-- NOTIFICATIONS TABLE POLICIES
-- ================================================

-- Users can only view their own notifications
CREATE POLICY "Users can view their own notifications"
ON public.notifications FOR SELECT
USING (auth.uid() = user_id);

-- Anyone can create notifications (system-generated)
CREATE POLICY "Notifications can be created"
ON public.notifications FOR INSERT
WITH CHECK (true);

-- Users can update their own notifications (mark as read)
CREATE POLICY "Users can update their own notifications"
ON public.notifications FOR UPDATE
USING (auth.uid() = user_id);

-- Users can delete their own notifications
CREATE POLICY "Users can delete their own notifications"
ON public.notifications FOR DELETE
USING (auth.uid() = user_id);

-- ================================================
-- HASHTAGS TABLE POLICIES
-- ================================================

-- Anyone can view hashtags
CREATE POLICY "Hashtags are viewable by everyone"
ON public.hashtags FOR SELECT
USING (true);

-- Anyone can create hashtags (auto-created when used)
CREATE POLICY "Hashtags can be created"
ON public.hashtags FOR INSERT
WITH CHECK (true);

-- ================================================
-- POST_HASHTAGS TABLE POLICIES
-- ================================================

-- Anyone can view post-hashtag relationships
CREATE POLICY "Post hashtags are viewable by everyone"
ON public.post_hashtags FOR SELECT
USING (true);

-- Users can tag their own posts
CREATE POLICY "Users can tag their own posts"
ON public.post_hashtags FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.posts p
    WHERE p.id = post_id AND p.user_id = auth.uid()
  )
);

-- Users can remove tags from their own posts
CREATE POLICY "Users can remove tags from their posts"
ON public.post_hashtags FOR DELETE
USING (
  EXISTS (
    SELECT 1 FROM public.posts p
    WHERE p.id = post_id AND p.user_id = auth.uid()
  )
);

-- ================================================
-- VIDEO_HASHTAGS TABLE POLICIES
-- ================================================

-- Anyone can view video-hashtag relationships
CREATE POLICY "Video hashtags are viewable by everyone"
ON public.video_hashtags FOR SELECT
USING (true);

-- Users can tag their own videos
CREATE POLICY "Users can tag their own videos"
ON public.video_hashtags FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.videos v
    WHERE v.id = video_id AND v.user_id = auth.uid()
  )
);

-- Users can remove tags from their own videos
CREATE POLICY "Users can remove tags from their videos"
ON public.video_hashtags FOR DELETE
USING (
  EXISTS (
    SELECT 1 FROM public.videos v
    WHERE v.id = video_id AND v.user_id = auth.uid()
  )
);

-- ================================================
-- DONE!
-- ================================================
-- All RLS policies have been created
-- Your database is now secure!

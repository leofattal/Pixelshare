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

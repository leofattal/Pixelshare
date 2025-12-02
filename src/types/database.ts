export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      users: {
        Row: {
          id: string
          email: string
          username: string
          display_name: string | null
          bio: string | null
          profile_picture_url: string | null
          website_url: string | null
          follower_count: number
          following_count: number
          post_count: number
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          email: string
          username: string
          display_name?: string | null
          bio?: string | null
          profile_picture_url?: string | null
          website_url?: string | null
          follower_count?: number
          following_count?: number
          post_count?: number
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          email?: string
          username?: string
          display_name?: string | null
          bio?: string | null
          profile_picture_url?: string | null
          website_url?: string | null
          follower_count?: number
          following_count?: number
          post_count?: number
          created_at?: string
          updated_at?: string
        }
      }
      posts: {
        Row: {
          id: string
          user_id: string
          image_url: string
          caption: string | null
          alt_text: string | null
          location: string | null
          like_count: number
          comment_count: number
          view_count: number
          is_deleted: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          image_url: string
          caption?: string | null
          alt_text?: string | null
          location?: string | null
          like_count?: number
          comment_count?: number
          view_count?: number
          is_deleted?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          image_url?: string
          caption?: string | null
          alt_text?: string | null
          location?: string | null
          like_count?: number
          comment_count?: number
          view_count?: number
          is_deleted?: boolean
          created_at?: string
          updated_at?: string
        }
      }
      videos: {
        Row: {
          id: string
          user_id: string
          title: string
          description: string | null
          video_url: string
          thumbnail_url: string
          duration: number
          resolution: string | null
          file_size: number | null
          visibility: 'public' | 'unlisted' | 'private'
          view_count: number
          like_count: number
          comment_count: number
          share_count: number
          processing_status: 'uploading' | 'processing' | 'ready' | 'failed'
          is_deleted: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          title: string
          description?: string | null
          video_url: string
          thumbnail_url: string
          duration?: number
          resolution?: string | null
          file_size?: number | null
          visibility?: 'public' | 'unlisted' | 'private'
          view_count?: number
          like_count?: number
          comment_count?: number
          share_count?: number
          processing_status?: 'uploading' | 'processing' | 'ready' | 'failed'
          is_deleted?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          title?: string
          description?: string | null
          video_url?: string
          thumbnail_url?: string
          duration?: number
          resolution?: string | null
          file_size?: number | null
          visibility?: 'public' | 'unlisted' | 'private'
          view_count?: number
          like_count?: number
          comment_count?: number
          share_count?: number
          processing_status?: 'uploading' | 'processing' | 'ready' | 'failed'
          is_deleted?: boolean
          created_at?: string
          updated_at?: string
        }
      }
      follows: {
        Row: {
          id: string
          follower_id: string
          following_id: string
          created_at: string
        }
        Insert: {
          id?: string
          follower_id: string
          following_id: string
          created_at?: string
        }
        Update: {
          id?: string
          follower_id?: string
          following_id?: string
          created_at?: string
        }
      }
      likes: {
        Row: {
          id: string
          user_id: string
          likeable_type: 'post' | 'video' | 'comment'
          likeable_id: string
          created_at: string
        }
        Insert: {
          id?: string
          user_id: string
          likeable_type: 'post' | 'video' | 'comment'
          likeable_id: string
          created_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          likeable_type?: 'post' | 'video' | 'comment'
          likeable_id?: string
          created_at?: string
        }
      }
      comments: {
        Row: {
          id: string
          user_id: string
          commentable_type: 'post' | 'video'
          commentable_id: string
          parent_comment_id: string | null
          content: string
          like_count: number
          is_deleted: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          commentable_type: 'post' | 'video'
          commentable_id: string
          parent_comment_id?: string | null
          content: string
          like_count?: number
          is_deleted?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          commentable_type?: 'post' | 'video'
          commentable_id?: string
          parent_comment_id?: string | null
          content?: string
          like_count?: number
          is_deleted?: boolean
          created_at?: string
          updated_at?: string
        }
      }
      notifications: {
        Row: {
          id: string
          user_id: string
          actor_id: string
          type: 'follow' | 'like_post' | 'like_video' | 'comment' | 'reply' | 'mention' | 'milestone'
          entity_type: 'post' | 'video' | 'comment' | null
          entity_id: string | null
          message: string
          is_read: boolean
          created_at: string
        }
        Insert: {
          id?: string
          user_id: string
          actor_id: string
          type: 'follow' | 'like_post' | 'like_video' | 'comment' | 'reply' | 'mention' | 'milestone'
          entity_type?: 'post' | 'video' | 'comment' | null
          entity_id?: string | null
          message: string
          is_read?: boolean
          created_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          actor_id?: string
          type?: 'follow' | 'like_post' | 'like_video' | 'comment' | 'reply' | 'mention' | 'milestone'
          entity_type?: 'post' | 'video' | 'comment' | null
          entity_id?: string | null
          message?: string
          is_read?: boolean
          created_at?: string
        }
      }
      hashtags: {
        Row: {
          id: string
          tag: string
          post_count: number
          video_count: number
          created_at: string
        }
        Insert: {
          id?: string
          tag: string
          post_count?: number
          video_count?: number
          created_at?: string
        }
        Update: {
          id?: string
          tag?: string
          post_count?: number
          video_count?: number
          created_at?: string
        }
      }
      post_hashtags: {
        Row: {
          post_id: string
          hashtag_id: string
          created_at: string
        }
        Insert: {
          post_id: string
          hashtag_id: string
          created_at?: string
        }
        Update: {
          post_id?: string
          hashtag_id?: string
          created_at?: string
        }
      }
      video_hashtags: {
        Row: {
          video_id: string
          hashtag_id: string
          created_at: string
        }
        Insert: {
          video_id: string
          hashtag_id: string
          created_at?: string
        }
        Update: {
          video_id?: string
          hashtag_id?: string
          created_at?: string
        }
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
  }
}

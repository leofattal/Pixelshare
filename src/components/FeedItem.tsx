import Link from 'next/link'
import { createClient } from '@/lib/supabase/server'
import LikeButton from './LikeButton'
import CommentsSection from './CommentsSection'
import { Eye } from 'lucide-react'

interface FeedItemProps {
  item: {
    content_type: 'post' | 'video'
    content_id: string
    user_id: string
    username: string
    display_name: string | null
    profile_picture_url: string | null
    image_url?: string
    caption?: string | null
    video_url?: string
    thumbnail_url?: string
    title?: string
    description?: string | null
    like_count: number
    comment_count: number
    view_count?: number
    created_at: string
  }
  currentUserId: string
}

export default async function FeedItem({ item, currentUserId }: FeedItemProps) {
  const supabase = await createClient()

  // Check if user has liked this item
  const { data: userLike } = await supabase
    .from('likes')
    .select('id')
    .eq('user_id', currentUserId)
    .eq('likeable_type', item.content_type)
    .eq('likeable_id', item.content_id)
    .single()

  const isLiked = !!userLike

  // Get comments for this item
  const { data: comments } = await supabase
    .from('comments')
    .select(
      `
      id,
      user_id,
      content,
      created_at,
      is_deleted,
      users:user_id (
        username,
        display_name,
        profile_picture_url
      )
    `
    )
    .eq('commentable_type', item.content_type)
    .eq('commentable_id', item.content_id)
    .is('parent_comment_id', null)
    .order('created_at', { ascending: false })
    .limit(5)

  const formattedComments =
    comments?.map((comment: any) => ({
      id: comment.id,
      user_id: comment.user_id,
      username: comment.users.username,
      display_name: comment.users.display_name,
      profile_picture_url: comment.users.profile_picture_url,
      content: comment.content,
      created_at: comment.created_at,
      is_deleted: comment.is_deleted,
    })) || []

  return (
    <div className="bg-white dark:bg-gray-800 rounded-lg shadow-md overflow-hidden">
      {/* Post Header */}
      <div className="p-4 flex items-center space-x-3">
        <Link href={`/profile/${item.username}`}>
          <div className="w-10 h-10 rounded-full bg-gray-300 dark:bg-gray-700 overflow-hidden">
            {item.profile_picture_url && (
              <img
                src={item.profile_picture_url}
                alt={item.username}
                className="w-full h-full object-cover"
              />
            )}
          </div>
        </Link>
        <div>
          <Link href={`/profile/${item.username}`}>
            <p className="font-semibold text-gray-900 dark:text-white hover:opacity-70 transition-opacity">
              {item.display_name || item.username}
            </p>
          </Link>
          <Link href={`/profile/${item.username}`}>
            <p className="text-sm text-gray-500 dark:text-gray-400 hover:opacity-70 transition-opacity">
              @{item.username}
            </p>
          </Link>
        </div>
      </div>

      {/* Content */}
      {item.content_type === 'post' ? (
        <>
          <img
            src={item.image_url}
            alt={item.caption || 'Post image'}
            className="w-full"
          />
          {item.caption && (
            <div className="p-4">
              <p className="text-gray-900 dark:text-white">{item.caption}</p>
            </div>
          )}
        </>
      ) : (
        <>
          <video
            src={item.video_url}
            poster={item.thumbnail_url}
            controls
            className="w-full"
          />
          <div className="p-4">
            <h3 className="font-semibold text-gray-900 dark:text-white mb-1">
              {item.title}
            </h3>
            {item.description && (
              <p className="text-gray-600 dark:text-gray-400 text-sm">
                {item.description}
              </p>
            )}
          </div>
        </>
      )}

      {/* Engagement */}
      <div className="px-4 pb-4 flex items-center space-x-6">
        <LikeButton
          likeableType={item.content_type}
          likeableId={item.content_id}
          initialLikeCount={item.like_count}
          initialIsLiked={isLiked}
        />
        <CommentsSection
          commentableType={item.content_type}
          commentableId={item.content_id}
          initialComments={formattedComments}
          initialCommentCount={item.comment_count}
        />
        {item.content_type === 'video' && item.view_count !== undefined && (
          <div className="flex items-center space-x-2 text-gray-600 dark:text-gray-400">
            <Eye className="h-6 w-6" />
            <span className="text-sm text-gray-900 dark:text-white font-medium">
              {item.view_count}
            </span>
          </div>
        )}
      </div>
    </div>
  )
}

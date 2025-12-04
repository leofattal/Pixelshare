import { createClient } from '@/lib/supabase/server'
import { notFound } from 'next/navigation'
import Link from 'next/link'
import { Database } from '@/types/database'
import FollowButton from '@/components/FollowButton'

type User = Database['public']['Tables']['users']['Row']
type Post = Database['public']['Tables']['posts']['Row']
type Video = Database['public']['Tables']['videos']['Row']

interface ContentItem {
  id: string
  type: 'post' | 'video'
  url: string
  created_at: string
}

export default async function ProfilePage({
  params,
}: {
  params: { username: string }
}) {
  const supabase = await createClient()

  // Get current user
  const {
    data: { user: currentUser },
  } = await supabase.auth.getUser()

  // Get profile user by username
  const { data: profileUser, error: userError } = await supabase
    .from('users')
    .select('*')
    .eq('username', params.username)
    .single()

  if (userError || !profileUser) {
    notFound()
  }

  // Check if viewing own profile
  const isOwnProfile = currentUser?.id === profileUser.id

  // Get user's posts
  const { data: posts } = await supabase
    .from('posts')
    .select('*')
    .eq('user_id', profileUser.id)
    .eq('is_deleted', false)
    .order('created_at', { ascending: false })

  // Get user's videos
  const { data: videos } = await supabase
    .from('videos')
    .select('*')
    .eq('user_id', profileUser.id)
    .eq('is_deleted', false)
    .eq('visibility', 'public')
    .order('created_at', { ascending: false })

  // Combine and sort by created_at
  const content: ContentItem[] = [
    ...(posts || []).map((post) => ({
      id: post.id,
      type: 'post' as const,
      url: post.image_url,
      created_at: post.created_at,
    })),
    ...(videos || []).map((video) => ({
      id: video.id,
      type: 'video' as const,
      url: video.thumbnail_url,
      created_at: video.created_at,
    })),
  ].sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime())

  // Check if current user is following profile user
  let isFollowing = false
  if (currentUser && !isOwnProfile) {
    const { data: followData } = await supabase
      .from('follows')
      .select('id')
      .eq('follower_id', currentUser.id)
      .eq('following_id', profileUser.id)
      .single()

    isFollowing = !!followData
  }

  return (
    <div className="min-h-screen bg-white dark:bg-gray-950">
      <div className="max-w-5xl mx-auto px-4 py-8">
        {/* Profile Header */}
        <div className="flex flex-col md:flex-row gap-8 md:gap-12 mb-12">
          {/* Profile Picture */}
          <div className="flex justify-center md:justify-start">
            <div className="w-32 h-32 md:w-40 md:h-40 rounded-full bg-gray-200 dark:bg-gray-800 overflow-hidden flex-shrink-0">
              {profileUser.profile_picture_url ? (
                <img
                  src={profileUser.profile_picture_url}
                  alt={profileUser.username}
                  className="w-full h-full object-cover"
                />
              ) : (
                <div className="w-full h-full flex items-center justify-center text-4xl md:text-5xl text-gray-400 dark:text-gray-600">
                  {profileUser.username[0].toUpperCase()}
                </div>
              )}
            </div>
          </div>

          {/* Profile Info */}
          <div className="flex-1">
            {/* Username and Action Button */}
            <div className="flex flex-col sm:flex-row sm:items-center gap-4 mb-6">
              <h1 className="text-2xl font-normal text-gray-900 dark:text-white">
                {profileUser.username}
              </h1>
              {isOwnProfile ? (
                <Link
                  href="/settings/profile"
                  className="px-6 py-2 bg-gray-100 dark:bg-gray-800 text-gray-900 dark:text-white rounded-md hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors text-center font-medium text-sm"
                >
                  Edit Profile
                </Link>
              ) : currentUser ? (
                <FollowButton userId={profileUser.id} initialIsFollowing={isFollowing} />
              ) : (
                <Link
                  href="/login"
                  className="px-6 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600 transition-colors text-center font-medium text-sm"
                >
                  Follow
                </Link>
              )}
            </div>

            {/* Stats */}
            <div className="flex gap-8 mb-6 text-base">
              <div>
                <span className="font-semibold text-gray-900 dark:text-white">
                  {profileUser.post_count}
                </span>{' '}
                <span className="text-gray-600 dark:text-gray-400">posts</span>
              </div>
              <button className="hover:opacity-70 transition-opacity">
                <span className="font-semibold text-gray-900 dark:text-white">
                  {profileUser.follower_count}
                </span>{' '}
                <span className="text-gray-600 dark:text-gray-400">followers</span>
              </button>
              <button className="hover:opacity-70 transition-opacity">
                <span className="font-semibold text-gray-900 dark:text-white">
                  {profileUser.following_count}
                </span>{' '}
                <span className="text-gray-600 dark:text-gray-400">following</span>
              </button>
            </div>

            {/* Display Name and Bio */}
            <div>
              {profileUser.display_name && (
                <p className="font-semibold text-gray-900 dark:text-white mb-1">
                  {profileUser.display_name}
                </p>
              )}
              {profileUser.bio && (
                <p className="text-gray-900 dark:text-white whitespace-pre-wrap mb-2">
                  {profileUser.bio}
                </p>
              )}
              {profileUser.website_url && (
                <a
                  href={profileUser.website_url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-blue-600 dark:text-blue-400 hover:underline"
                >
                  {profileUser.website_url.replace(/^https?:\/\//, '')}
                </a>
              )}
            </div>
          </div>
        </div>

        {/* Content Grid */}
        <div className="border-t border-gray-200 dark:border-gray-800 pt-8">
          {content.length === 0 ? (
            <div className="text-center py-12">
              <div className="inline-flex items-center justify-center w-16 h-16 rounded-full border-2 border-gray-900 dark:border-white mb-4">
                <svg
                  className="w-8 h-8 text-gray-900 dark:text-white"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z"
                  />
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M15 13a3 3 0 11-6 0 3 3 0 016 0z"
                  />
                </svg>
              </div>
              <p className="text-2xl font-light text-gray-900 dark:text-white mb-1">
                No Posts Yet
              </p>
              {isOwnProfile && (
                <p className="text-gray-600 dark:text-gray-400">
                  When you share photos or videos, they&apos;ll appear on your profile.
                </p>
              )}
            </div>
          ) : (
            <div className="grid grid-cols-3 gap-1 md:gap-4">
              {content.map((item) => (
                <Link
                  key={item.id}
                  href={item.type === 'post' ? `/p/${item.id}` : `/v/${item.id}`}
                  className="relative aspect-square bg-gray-100 dark:bg-gray-900 group overflow-hidden"
                >
                  <img
                    src={item.url}
                    alt=""
                    className="w-full h-full object-cover"
                  />
                  {item.type === 'video' && (
                    <div className="absolute top-2 right-2">
                      <svg
                        className="w-6 h-6 text-white drop-shadow-lg"
                        fill="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path d="M8 5v14l11-7z" />
                      </svg>
                    </div>
                  )}
                  {/* Hover overlay */}
                  <div className="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-30 transition-all duration-200" />
                </Link>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  )
}

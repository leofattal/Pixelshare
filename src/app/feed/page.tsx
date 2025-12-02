import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import Header from '@/components/Header'

export default async function FeedPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) {
    redirect('/login')
  }

  // Get user profile
  const { data: profile } = await supabase
    .from('users')
    .select('id, username, profile_picture_url')
    .eq('id', user.id)
    .single()

  // Get feed content using the database function
  const { data: feedItems } = await supabase.rpc('get_user_feed', {
    p_user_id: user.id,
    p_limit: 20,
    p_offset: 0,
  })

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <Header user={profile || undefined} />

      <main className="max-w-2xl mx-auto px-4 py-8 pb-20 md:pb-8">
        <h1 className="text-2xl font-bold text-gray-900 dark:text-white mb-6">
          Your Feed
        </h1>

        {!feedItems || feedItems.length === 0 ? (
          <div className="bg-white dark:bg-gray-800 rounded-lg p-8 text-center">
            <p className="text-gray-600 dark:text-gray-400 mb-4">
              Your feed is empty! Follow some creators to see their content here.
            </p>
            <a
              href="/search"
              className="inline-block px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
            >
              Discover Creators
            </a>
          </div>
        ) : (
          <div className="space-y-6">
            {feedItems.map((item: any) => (
              <div
                key={`${item.content_type}-${item.content_id}`}
                className="bg-white dark:bg-gray-800 rounded-lg shadow-md overflow-hidden"
              >
                {/* Post Header */}
                <div className="p-4 flex items-center space-x-3">
                  <div className="w-10 h-10 rounded-full bg-gray-300 dark:bg-gray-700 overflow-hidden">
                    {item.profile_picture_url && (
                      <img
                        src={item.profile_picture_url}
                        alt={item.username}
                        className="w-full h-full object-cover"
                      />
                    )}
                  </div>
                  <div>
                    <p className="font-semibold text-gray-900 dark:text-white">
                      {item.display_name || item.username}
                    </p>
                    <p className="text-sm text-gray-500 dark:text-gray-400">
                      @{item.username}
                    </p>
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
                <div className="px-4 pb-4 flex items-center space-x-6 text-sm text-gray-600 dark:text-gray-400">
                  <button className="flex items-center space-x-1 hover:text-red-500">
                    <span>❤️</span>
                    <span>{item.like_count}</span>
                  </button>
                  <button className="flex items-center space-x-1 hover:text-blue-500">
                    <span>💬</span>
                    <span>{item.comment_count}</span>
                  </button>
                  {item.content_type === 'video' && (
                    <span className="flex items-center space-x-1">
                      <span>👁️</span>
                      <span>{item.view_count}</span>
                    </span>
                  )}
                </div>
              </div>
            ))}
          </div>
        )}
      </main>
    </div>
  )
}

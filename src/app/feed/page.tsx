import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import Header from '@/components/Header'
import FeedItem from '@/components/FeedItem'

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
              <FeedItem
                key={`${item.content_type}-${item.content_id}`}
                item={item}
                currentUserId={user.id}
              />
            ))}
          </div>
        )}
      </main>
    </div>
  )
}

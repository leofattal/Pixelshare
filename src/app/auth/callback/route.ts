import { createClient } from '@/lib/supabase/server'
import { NextResponse } from 'next/server'

export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url)
  const code = searchParams.get('code')
  const next = searchParams.get('next') ?? '/feed'

  if (code) {
    const supabase = await createClient()
    const { data, error } = await supabase.auth.exchangeCodeForSession(code)

    if (!error && data.user) {
      // Check if user profile exists
      const { data: profile } = await supabase
        .from('users')
        .select('id')
        .eq('id', data.user.id)
        .single()

      // If profile doesn't exist, create it
      if (!profile) {
        const username = data.user.user_metadata.username ||
                        data.user.email?.split('@')[0] ||
                        `user_${data.user.id.slice(0, 8)}`

        await supabase.from('users').insert({
          id: data.user.id,
          email: data.user.email!,
          username,
          display_name: data.user.user_metadata.full_name || data.user.user_metadata.name || username,
          profile_picture_url: data.user.user_metadata.avatar_url || data.user.user_metadata.picture,
        })
      }

      return NextResponse.redirect(`${origin}${next}`)
    }
  }

  // Return the user to an error page with some instructions
  return NextResponse.redirect(`${origin}/login?error=auth_callback_error`)
}

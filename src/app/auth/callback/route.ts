import { createClient } from '@/lib/supabase/server'
import { NextResponse } from 'next/server'

export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url)
  const code = searchParams.get('code')
  const next = searchParams.get('next') ?? '/feed'

  if (code) {
    const supabase = await createClient()
    const { error } = await supabase.auth.exchangeCodeForSession(code)

    if (!error) {
      // User profile is automatically created by database trigger
      // Just redirect to the feed
      return NextResponse.redirect(`${origin}${next}`)
    }
  }

  // Return the user to an error page with some instructions
  return NextResponse.redirect(`${origin}/login?error=auth_callback_error`)
}

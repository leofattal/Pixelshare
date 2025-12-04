'use server'

import { createClient } from '@/lib/supabase/server'
import { revalidatePath } from 'next/cache'

export async function followUser(userId: string) {
  const supabase = await createClient()

  const {
    data: { user: currentUser },
  } = await supabase.auth.getUser()

  if (!currentUser) {
    return { error: 'Not authenticated' }
  }

  if (currentUser.id === userId) {
    return { error: 'Cannot follow yourself' }
  }

  // Check if already following
  const { data: existingFollow } = await supabase
    .from('follows')
    .select('id')
    .eq('follower_id', currentUser.id)
    .eq('following_id', userId)
    .single()

  if (existingFollow) {
    return { error: 'Already following this user' }
  }

  // Create follow relationship
  const { error } = await supabase.from('follows').insert({
    follower_id: currentUser.id,
    following_id: userId,
  })

  if (error) {
    return { error: error.message }
  }

  // Get the followed user's profile to revalidate
  const { data: followedUser } = await supabase
    .from('users')
    .select('username')
    .eq('id', userId)
    .single()

  if (followedUser) {
    revalidatePath(`/profile/${followedUser.username}`)
  }

  return { success: true }
}

export async function unfollowUser(userId: string) {
  const supabase = await createClient()

  const {
    data: { user: currentUser },
  } = await supabase.auth.getUser()

  if (!currentUser) {
    return { error: 'Not authenticated' }
  }

  // Delete follow relationship
  const { error } = await supabase
    .from('follows')
    .delete()
    .eq('follower_id', currentUser.id)
    .eq('following_id', userId)

  if (error) {
    return { error: error.message }
  }

  // Get the unfollowed user's profile to revalidate
  const { data: unfollowedUser } = await supabase
    .from('users')
    .select('username')
    .eq('id', userId)
    .single()

  if (unfollowedUser) {
    revalidatePath(`/profile/${unfollowedUser.username}`)
  }

  return { success: true }
}

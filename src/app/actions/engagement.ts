'use server'

import { createClient } from '@/lib/supabase/server'
import { revalidatePath } from 'next/cache'

export async function toggleLike(likeableType: 'post' | 'video', likeableId: string) {
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    return { error: 'Not authenticated' }
  }

  // Check if already liked
  const { data: existingLike } = await supabase
    .from('likes')
    .select('id')
    .eq('user_id', user.id)
    .eq('likeable_type', likeableType)
    .eq('likeable_id', likeableId)
    .single()

  if (existingLike) {
    // Unlike
    const { error } = await supabase
      .from('likes')
      .delete()
      .eq('id', existingLike.id)

    if (error) {
      return { error: error.message }
    }

    revalidatePath('/feed')
    return { success: true, liked: false }
  } else {
    // Like
    const { error } = await supabase.from('likes').insert({
      user_id: user.id,
      likeable_type: likeableType,
      likeable_id: likeableId,
    })

    if (error) {
      return { error: error.message }
    }

    revalidatePath('/feed')
    return { success: true, liked: true }
  }
}

export async function addComment(
  commentableType: 'post' | 'video',
  commentableId: string,
  content: string,
  parentCommentId?: string
) {
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    return { error: 'Not authenticated' }
  }

  if (!content.trim()) {
    return { error: 'Comment cannot be empty' }
  }

  const { error } = await supabase.from('comments').insert({
    user_id: user.id,
    commentable_type: commentableType,
    commentable_id: commentableId,
    content: content.trim(),
    parent_comment_id: parentCommentId || null,
  })

  if (error) {
    return { error: error.message }
  }

  revalidatePath('/feed')
  return { success: true }
}

export async function deleteComment(commentId: string) {
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    return { error: 'Not authenticated' }
  }

  // Verify ownership
  const { data: comment } = await supabase
    .from('comments')
    .select('user_id')
    .eq('id', commentId)
    .single()

  if (!comment || comment.user_id !== user.id) {
    return { error: 'Not authorized' }
  }

  // Soft delete
  const { error } = await supabase
    .from('comments')
    .update({ is_deleted: true, content: '[deleted]' })
    .eq('id', commentId)

  if (error) {
    return { error: error.message }
  }

  revalidatePath('/feed')
  return { success: true }
}

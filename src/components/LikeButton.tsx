'use client'

import { useState } from 'react'
import { Heart } from 'lucide-react'
import { toggleLike } from '@/app/actions/engagement'

interface LikeButtonProps {
  likeableType: 'post' | 'video'
  likeableId: string
  initialLikeCount: number
  initialIsLiked: boolean
}

export default function LikeButton({
  likeableType,
  likeableId,
  initialLikeCount,
  initialIsLiked,
}: LikeButtonProps) {
  const [isLiked, setIsLiked] = useState(initialIsLiked)
  const [likeCount, setLikeCount] = useState(initialLikeCount)
  const [loading, setLoading] = useState(false)

  async function handleClick() {
    if (loading) return

    setLoading(true)
    const optimisticIsLiked = !isLiked
    const optimisticCount = isLiked ? likeCount - 1 : likeCount + 1

    // Optimistic update
    setIsLiked(optimisticIsLiked)
    setLikeCount(optimisticCount)

    const result = await toggleLike(likeableType, likeableId)

    if (result.error) {
      // Revert on error
      setIsLiked(isLiked)
      setLikeCount(likeCount)
      console.error(result.error)
    }

    setLoading(false)
  }

  return (
    <button
      onClick={handleClick}
      disabled={loading}
      className="flex items-center space-x-2 transition-colors disabled:opacity-50"
    >
      <Heart
        className={`h-6 w-6 transition-colors ${
          isLiked
            ? 'fill-red-500 text-red-500'
            : 'text-gray-600 dark:text-gray-400 hover:text-red-500'
        }`}
      />
      <span className="text-sm text-gray-900 dark:text-white font-medium">
        {likeCount}
      </span>
    </button>
  )
}

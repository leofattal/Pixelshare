'use client'

import { useState } from 'react'
import { followUser, unfollowUser } from '@/app/profile/actions'

interface FollowButtonProps {
  userId: string
  initialIsFollowing: boolean
}

export default function FollowButton({ userId, initialIsFollowing }: FollowButtonProps) {
  const [isFollowing, setIsFollowing] = useState(initialIsFollowing)
  const [loading, setLoading] = useState(false)

  async function handleClick() {
    setLoading(true)

    if (isFollowing) {
      const result = await unfollowUser(userId)
      if (result.success) {
        setIsFollowing(false)
      } else if (result.error) {
        console.error(result.error)
      }
    } else {
      const result = await followUser(userId)
      if (result.success) {
        setIsFollowing(true)
      } else if (result.error) {
        console.error(result.error)
      }
    }

    setLoading(false)
  }

  return (
    <button
      onClick={handleClick}
      disabled={loading}
      className={`px-6 py-2 rounded-md font-medium text-sm transition-colors disabled:opacity-50 disabled:cursor-not-allowed ${
        isFollowing
          ? 'bg-gray-100 dark:bg-gray-800 text-gray-900 dark:text-white hover:bg-gray-200 dark:hover:bg-gray-700'
          : 'bg-blue-500 text-white hover:bg-blue-600'
      }`}
    >
      {loading ? '...' : isFollowing ? 'Following' : 'Follow'}
    </button>
  )
}

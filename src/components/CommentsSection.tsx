'use client'

import { useState } from 'react'
import { MessageCircle, Send } from 'lucide-react'
import { addComment } from '@/app/actions/engagement'

interface Comment {
  id: string
  user_id: string
  username: string
  display_name: string | null
  profile_picture_url: string | null
  content: string
  created_at: string
  is_deleted: boolean
}

interface CommentsSectionProps {
  commentableType: 'post' | 'video'
  commentableId: string
  initialComments: Comment[]
  initialCommentCount: number
}

export default function CommentsSection({
  commentableType,
  commentableId,
  initialComments,
  initialCommentCount,
}: CommentsSectionProps) {
  const [isOpen, setIsOpen] = useState(false)
  const [commentText, setCommentText] = useState('')
  const [loading, setLoading] = useState(false)
  const [commentCount, setCommentCount] = useState(initialCommentCount)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (!commentText.trim() || loading) return

    setLoading(true)
    const result = await addComment(commentableType, commentableId, commentText)

    if (result.success) {
      setCommentText('')
      setCommentCount(commentCount + 1)
      // In a real app, we'd add the new comment to the list
      // For now, we'll just increment the count
    } else if (result.error) {
      console.error(result.error)
    }

    setLoading(false)
  }

  return (
    <div>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center space-x-2 transition-colors text-gray-600 dark:text-gray-400 hover:text-blue-500"
      >
        <MessageCircle className="h-6 w-6" />
        <span className="text-sm text-gray-900 dark:text-white font-medium">
          {commentCount}
        </span>
      </button>

      {isOpen && (
        <div className="mt-4 pt-4 border-t border-gray-200 dark:border-gray-700">
          {/* Comment Input */}
          <form onSubmit={handleSubmit} className="mb-4">
            <div className="flex items-center space-x-2">
              <input
                type="text"
                value={commentText}
                onChange={(e) => setCommentText(e.target.value)}
                placeholder="Add a comment..."
                className="flex-1 px-4 py-2 bg-gray-50 dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 text-gray-900 dark:text-white text-base"
                disabled={loading}
              />
              <button
                type="submit"
                disabled={!commentText.trim() || loading}
                className="p-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
              >
                <Send className="h-5 w-5" />
              </button>
            </div>
          </form>

          {/* Comments List */}
          {initialComments.length === 0 ? (
            <p className="text-gray-500 dark:text-gray-400 text-sm text-center py-4">
              No comments yet. Be the first to comment!
            </p>
          ) : (
            <div className="space-y-3">
              {initialComments.map((comment) => (
                <div key={comment.id} className="flex space-x-3">
                  <div className="w-8 h-8 rounded-full bg-gray-300 dark:bg-gray-700 overflow-hidden flex-shrink-0">
                    {comment.profile_picture_url && (
                      <img
                        src={comment.profile_picture_url}
                        alt={comment.username}
                        className="w-full h-full object-cover"
                      />
                    )}
                  </div>
                  <div className="flex-1">
                    <div className="bg-gray-50 dark:bg-gray-800 rounded-lg px-3 py-2">
                      <p className="font-semibold text-sm text-gray-900 dark:text-white">
                        {comment.display_name || comment.username}
                      </p>
                      <p className="text-sm text-gray-900 dark:text-white mt-1">
                        {comment.content}
                      </p>
                    </div>
                    <div className="flex items-center space-x-4 mt-1 px-3">
                      <span className="text-xs text-gray-500 dark:text-gray-400">
                        {new Date(comment.created_at).toLocaleDateString()}
                      </span>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  )
}

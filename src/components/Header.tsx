'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { Home, Search, PlusSquare, Bell, User } from 'lucide-react'

interface HeaderProps {
  user?: {
    id: string
    username: string
    profile_picture_url?: string | null
  }
}

export default function Header({ user }: HeaderProps) {
  const pathname = usePathname()

  const navItems = [
    { href: '/feed', icon: Home, label: 'Home', active: pathname === '/feed' },
    { href: '/search', icon: Search, label: 'Search', active: pathname === '/search' },
    { href: '/upload', icon: PlusSquare, label: 'Upload', active: pathname === '/upload' },
    { href: '/notifications', icon: Bell, label: 'Notifications', active: pathname === '/notifications' },
    { href: `/profile/${user?.username}`, icon: User, label: 'Profile', active: pathname?.startsWith('/profile') },
  ]

  return (
    <>
      {/* Desktop Header */}
      <header className="hidden md:block sticky top-0 z-50 bg-white dark:bg-gray-900 border-b border-gray-200 dark:border-gray-800">
        <div className="max-w-6xl mx-auto px-4">
          <div className="flex items-center justify-between h-16">
            {/* Logo */}
            <Link href="/feed" className="text-2xl font-bold text-gray-900 dark:text-white">
              Pixel Share
            </Link>

            {/* Search Bar (Desktop) */}
            <div className="hidden lg:block flex-1 max-w-md mx-8">
              <div className="relative">
                <input
                  type="text"
                  placeholder="Search..."
                  className="w-full px-4 py-2 pl-10 bg-gray-100 dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
                <Search className="absolute left-3 top-2.5 h-5 w-5 text-gray-400" />
              </div>
            </div>

            {/* Navigation Icons */}
            <nav className="flex items-center space-x-6">
              {navItems.map((item) => {
                const Icon = item.icon
                return (
                  <Link
                    key={item.href}
                    href={item.href}
                    className={`transition-colors ${
                      item.active
                        ? 'text-blue-600 dark:text-blue-400'
                        : 'text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white'
                    }`}
                    title={item.label}
                  >
                    <Icon className="h-6 w-6" />
                  </Link>
                )
              })}
            </nav>
          </div>
        </div>
      </header>

      {/* Mobile Bottom Navigation */}
      <nav className="md:hidden fixed bottom-0 left-0 right-0 z-50 bg-white dark:bg-gray-900 border-t border-gray-200 dark:border-gray-800">
        <div className="flex items-center justify-around h-16">
          {navItems.map((item) => {
            const Icon = item.icon
            return (
              <Link
                key={item.href}
                href={item.href}
                className={`flex flex-col items-center justify-center flex-1 h-full transition-colors ${
                  item.active
                    ? 'text-blue-600 dark:text-blue-400'
                    : 'text-gray-600 dark:text-gray-400'
                }`}
              >
                <Icon className="h-6 w-6" />
                <span className="text-xs mt-1">{item.label}</span>
              </Link>
            )
          })}
        </div>
      </nav>
    </>
  )
}

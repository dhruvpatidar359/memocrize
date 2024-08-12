"use client"

import { signOut } from "next-auth/react"
import { DEFAULT_SIGNOUT_REDIRECT } from "@/config/defaults"
import { Button } from "@/components/ui/button"
import { Icons } from "@/components/icons"
import { deleteCookie } from "cookies-next"

export function SignOutButton(): JSX.Element {
  const handleSignOut = async () => {
    // Remove the access token and refresh token cookies
    deleteCookie('googleAccessToken')
    deleteCookie('googleRefreshToken') // If you're storing a refresh token

    // Perform the sign out
    await signOut({
      callbackUrl: DEFAULT_SIGNOUT_REDIRECT,
      redirect: true,
    })
  }

  return (
    <Button
      aria-label="Sign Out"
      variant="ghost"
      className="w-full justify-start text-sm"
      onClick={() => void handleSignOut()}
    >
      <Icons.logout className="mr-2 size-4" aria-hidden="true" />
      Sign out
    </Button>
  )
}
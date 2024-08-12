"use client"


import { signIn, useSession } from "next-auth/react"
import { DEFAULT_SIGNIN_REDIRECT } from "@/config/defaults"
import { useToast } from "@/hooks/use-toast"
import { Button } from "@/components/ui/button"
import { Icons } from "@/components/icons"
import { setCookie } from "cookies-next"
import { useRouter } from "next/navigation"
import { useEffect, useState } from "react"

export function OAuthButtons(): JSX.Element {
  const { data: session, status } = useSession()
  const { toast } = useToast()
  const router = useRouter()
  const [signingIn, setSigningIn] = useState(false)

  const setAccessTokenCookie = (accessToken: string) => {
    setCookie('googleAccessToken', accessToken, {
      maxAge: 30 * 24 * 60 * 60, // 30 days
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'strict'
    })
  }

  useEffect(() => {
    if (status === 'authenticated' && session?.accessToken) {
    
      setAccessTokenCookie(session.accessToken)
      toast({
        title: "Success!",
        description: "You are now signed in",
      })
      router.push(DEFAULT_SIGNIN_REDIRECT)
    }
  }, [session])

  async function handleOAuthSignIn(provider: "google"): Promise<void> {
    setSigningIn(true)
    try {
      const result = await signIn(provider, {
        redirect: false,
      })

      if (result?.error) {
        throw new Error(result.error)
      }
    } catch (error) {
      toast({
        title: "Something went wrong",
        description: "Please try again",
        variant: "destructive",
      })
      console.error(error)
      setSigningIn(false)
    }
  }

  return (
    <div className="">
      <Button
        aria-label="Sign in with Google"
        variant="outline"
        onClick={() => void handleOAuthSignIn("google")}
        className="w-full"
      >
        <Icons.google className="mr-2 size-4" />
        Google
      </Button>
    </div>
  )
}

import NextAuth from "next-auth"
import { env } from "@/env.mjs"
import authConfig from "@/config/auth"

export const {
  handlers: { GET, POST },
  auth,
  signIn,
  signOut,
} = NextAuth({
  debug: env.NODE_ENV === "development",
  pages: {
    signIn: "/signin",
    signOut: "/signout",
  },

  session: {
    strategy: "jwt",
    maxAge: 30 * 24 * 60 * 60,
    updateAge: 24 * 60 * 60, 
  },
  callbacks: {
     jwt({ token, account, user }) {
      if (account) {
        token.accessToken = account.access_token
      }
      if (user) {
        token.role = user.role
      }
      return token
    },
     session({ session, token }) {
      session.accessToken = token.accessToken as string
      return session
    }
  },
 
 
  ...authConfig,
})

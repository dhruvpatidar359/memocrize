import type { NextAuthConfig } from "next-auth"
import GoogleProvider from "next-auth/providers/google"

  

export default {
  providers: [
    GoogleProvider({
      clientId: "42915966123-a75bgam8d9gos4rf2if20pfvaevjvb8n.apps.googleusercontent.com",
      clientSecret: "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",
      allowDangerousEmailAccountLinking: true,
    }),
   
  ],
  secret: process.env.NEXTAUTH_SECRET,
} satisfies NextAuthConfig

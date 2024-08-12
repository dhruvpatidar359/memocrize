import type { DefaultSession } from "next-auth"

export type Role = "USER" | "ADMIN"

declare module "next-auth" {
  interface User {
    role: Role
  }

  interface Session extends DefaultSession {
    user: User & {
      role: Role
    } & DefaultSession["user"]
    accessToken?: string
  }
}

declare module "next-auth/jwt" {
  interface JWT {
    role?: Role
    accessToken?: string
  }
}

declare module "@auth/core/adapters" {
  interface AdapterUser {
    role: Role
  }
}
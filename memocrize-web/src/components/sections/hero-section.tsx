import Link from "next/link"
import Balancer from "react-wrap-balancer"

import { siteConfig } from "@/config/site"

import { cn, getGitHubStars } from "@/lib/utils"

import { Badge } from "@/components/ui/badge"
import { buttonVariants } from "@/components/ui/button"
import { Icons } from "@/components/icons"

export async function HeroSection() {
  const gitHubStars = await getGitHubStars()

  return (
    <section
      id="hero-section"
      aria-label="hero section"
      className="mt-16 w-full md:mt-16"
    >
      <div className="container flex flex-col items-center gap-6 text-center">
        {gitHubStars ? (
          <Link
            href={siteConfig.links.github}
            target="_blank"
            rel="noreferrer"
            className="z-10"
          >
            <Badge
              variant="outline"
              aria-hidden="true"
              className="rounded-md px-3.5 py-1.5 text-sm transition-all duration-1000 ease-out hover:opacity-80 md:text-base md:hover:-translate-y-2"
            >
              <Icons.gitHub className="mr-2 size-3.5" aria-hidden="true" />
              {gitHubStars} Stars on GitHub
            </Badge>
            <span className="sr-only">GitHub</span>
          </Link>
        ) : null}
        <h1 className="animate-fade-up font-urbanist text-5xl font-extrabold tracking-tight sm:text-6xl md:text-7xl lg:text-8xl">
          <Balancer>
          Memorize everything{" "}
            <span className="bg-gradient-to-r from-pink-600 to-purple-400 bg-clip-text font-extrabold text-transparent">
              with Memocrize
            </span>
          </Balancer>
        </h1>

        <h3 className="max-w-2xl animate-fade-up text-muted-foreground sm:text-xl sm:leading-8">
          <Balancer>
          Tailored Food Safety and Delicious Recipes for Your Condition. Why ask friends or family when you can ask us?
          </Balancer>
        </h3>

        <div className="z-10 flex animate-fade-up flex-col justify-center gap-4 sm:flex-row">
          <Link
            href="/signin"
            className={cn(
              buttonVariants({ size: "lg" }),
              "transition-all duration-1000 ease-out md:hover:-translate-y-2"
            )}
          >
            Get Started
          </Link>

          <Link
            href={siteConfig.links.github}
            className={cn(
              buttonVariants({ variant: "outline", size: "lg" }),
              "transition-all duration-1000 ease-out md:hover:-translate-y-2"
            )}
          >
            See on GitHub
          </Link>
        </div>
      </div>
    </section>
  )
}

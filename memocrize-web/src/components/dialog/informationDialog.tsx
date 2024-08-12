import React from 'react'

import Image from 'next/image'
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
  } from "@/components/ui/dialog"
const InformationDialog = () => {
  return (
    <div>
        <Dialog>
  <DialogTrigger><div className="flex flex-row justify-end gap-0.5 items-center">
                <p className="text-xs">Example</p>
                <Image src={"/circle-help.svg"} className="" alt="help" height={20} width={20} />
              </div></DialogTrigger>
  <DialogContent>
    <DialogHeader>
      <DialogTitle>Are you absolutely sure?</DialogTitle>
      <DialogDescription>
        This action cannot be undone. This will permanently delete your account
        and remove your data from our servers.
      </DialogDescription>
    </DialogHeader>
  </DialogContent>
</Dialog>

    </div>
  )
}

export default InformationDialog
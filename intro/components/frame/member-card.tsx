import { BellRing, Check } from "lucide-react"
 
import { cn } from "@/lib/utils"
import { Button } from "@/components/ui/button"
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"

import {
    Avatar,
    AvatarFallback,
    AvatarImage,
  } from "@/components/ui/avatar"

type CardProps = React.ComponentProps<typeof Card>

interface MemberCardProps extends CardProps {
    name: string; 
    description: string;
    tasks: Array<{ title: string; description: string }>;
  }
 
export function MemberCard({ className, name, description, tasks, ...props }: MemberCardProps) {
  return (
    <Card className={cn("w-[240px]", className)} {...props}>
        <div className="grid gap-4 place-items-center mt-8">
            <Avatar className="place-items-center">
                <AvatarImage src="https://github.com/shadcn.png"></AvatarImage>
            </Avatar>
        </div>
      <CardHeader className="place-items-center">
        <CardTitle>{name}</CardTitle>
        <CardDescription>{description}</CardDescription>
      </CardHeader>
      <CardContent className="grid gap-4 place-items-center">
        <div>
          {tasks.map((task, index) => (
            <div
              key={index}
              className="mb-4 grid grid-cols-[25px_1fr] items-start pb-4 last:mb-0 last:pb-0"
            >
              <span className="flex h-2 w-2 translate-y-1 rounded-full bg-sky-500" />
              <div className="space-y-1">
                <p className="text-sm font-medium leading-none">
                  {task.title}
                </p>
                <p className="text-sm text-muted-foreground">
                  {task.description}
                </p>
              </div>
            </div>
          ))}
        </div>
      </CardContent>
      <CardFooter>
      </CardFooter>
    </Card>
  )
}
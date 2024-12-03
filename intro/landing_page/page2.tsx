import { MemberCard } from "@/components/frame/member-card"

const tasks = [
  {
    title: "Your call has been confirmed.",
    description: "1 hour ago",
  },
  {
    title: "You have a new message!",
    description: "1 hour ago",
  },
  {
    title: "Your subscription is expiring soon!",
    description: "2 hours ago",
  },
]


export function Page2() {
  return (
  <div className="h-screen flex items-center justify-center snap-start">
    <div className="flex justify-evenly">
      <div className="px-4">
        <MemberCard name="성민" description="설명" tasks={tasks} style={{  }}/>
      </div>
      <div className="px-4">
        <MemberCard name="성민" description="설명" tasks={tasks} style={{  }}/>
      </div>
      <div className="px-4">
        <MemberCard name="성민" description="설명" tasks={tasks} style={{  }}/>
      </div>
      <div className="px-4">
        <MemberCard name="성민" description="설명" tasks={tasks} style={{  }}/>
      </div>
    </div>
  </div>
  )
}
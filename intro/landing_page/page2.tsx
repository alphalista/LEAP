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
    <div className="flex">
      <div>
        <MemberCard name="성민" description="설명" tasks={tasks} style={{ margin: '3.6rem' }}/>
      </div>
      <div>
        <MemberCard name="성민" description="설명" tasks={tasks} style={{ margin: '3.6rem' }}/>
      </div>
      <div>
        <MemberCard name="성민" description="설명" tasks={tasks} style={{ margin: '3.6rem' }}/>
      </div>
      <div>
        <MemberCard name="성민" description="설명" tasks={tasks} style={{ margin: '3.6rem' }}/>
      </div>
    </div>
  </div>
  )
}
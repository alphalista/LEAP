import { MemberCard } from "@/components/frame/member-card"

const tasks1 = [
  {
    title: "프로젝트 기획",
    description: "1 hour ago",
  },
  {
    title: "Celery 및 RESTAPI 개발",
    description: "1 hour ago",
  },
  {
    title: "인프라 관리",
    description: "2 hours ago",
  },
]
const tasks2 = [
  {
    title: "프로젝트 기획",
    description: "1 hour ago",
  },
  {
    title: "CMS 솔루션 개발",
    description: "1 hour ago",
  },
  {
    title: "UI",
    description: "2 hours ago",
  },
]
const tasks3 = [
  {
    title: "백엔드 개발",
    description: "1 hour ago",
  },
  {
    title: "일",
    description: "1 hour ago",
  },
  {
    title: "일",
    description: "2 hours ago",
  },
]
const tasks4 = [
  {
    title: "Flutter 개발",
    description: "1 hour ago",
  },
  {
    title: "일",
    description: "1 hour ago",
  },
  {
    title: "일",
    description: "2 hours ago",
  },
]


export function Page2() {
  return (
  <div className="h-screen flex items-center justify-center snap-start">
    <div className="flex justify-evenly">
      <div className="px-4">
        <MemberCard name="나성민" description="팀장 / 백엔드" tasks={tasks1} style={{  }}/>
      </div>
      <div className="px-4">
        <MemberCard name="송보경" description="기획 / 백엔드" tasks={tasks2} style={{  }}/>
      </div>
      <div className="px-4">
        <MemberCard name="이동언" description="프론트" tasks={tasks3} style={{  }}/>
      </div>
      <div className="px-4">
        <MemberCard name="임태근" description="프론트 / 백엔드" tasks={tasks4} style={{  }}/>
      </div>
    </div>
  </div>
  )
}
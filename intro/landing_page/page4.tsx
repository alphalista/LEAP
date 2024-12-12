import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"

import { Button } from "@/components/ui/button"



  export function Page4() {
    return (
      <div className="h-screen snap-start">
        <div className='h-12'></div>
        <div className='flex'>
          <div style={{ width: '10%' }}></div>
          <div style={{ width:'50%' }}>
            <Card>
            <CardHeader>
              <CardTitle>다운로드</CardTitle>
              <CardDescription>version</CardDescription>
            </CardHeader>
            <CardContent className="flex justify-center">
            <Button className="m-4" variant="outline" onClick={() => window.open("https://naver.com")}>앱 다운로드</Button>
            <div className="w-4"></div>
            <Button className="m-4" variant="outline" onClick={() => window.open("https://naver.com")}>웹으로 사용해 보기</Button>
            </CardContent>

            </Card>
          </div>
          <div>
            <p 
              className="font-black text-center"
              style={{
                fontSize: "clamp(1.2rem, 1.0vw, 5rem)",
                color: "#f9fafb",
                marginTop: '5rem', 
                padding:'2rem'
              }}
            >
              설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명설명
          </p>
          </div>

        </div>
      </div>
    );
  }
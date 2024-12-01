import Image from 'next/image';
import leap_icon from '../public/leap_white.svg'


export function Page1() {
  return (
    <div className="h-screen snap-start">
      <div className="flex justify-start">
        <div style={{ width: '3.2%' }}></div>
        <Image
          src={leap_icon}
          alt="v13 image"
          className="flex"
          width="500"
          height="100"
          style={{
            width: '40%', 
            height:'90%', 
            objectFit: 'cover', 
            objectPosition: 'center'
          }}
        />
      </div>
      <div className="flex">
        <div style={{ width: '3.2%' }}></div>
        <p 
          className="font-black"
          style={{
            fontSize: "clamp(1.2rem, 2.8vw, 5rem)",
            color: "#f9fafb",
            fontWeight: "900"
          }}
        >
          우리들의 채권 투자 스타일
        </p>
      </div>
    </div>
  )
}
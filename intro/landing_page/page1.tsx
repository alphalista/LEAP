import Image from 'next/image';
import leap_icon from '../public/leap_white.svg'
import main_page from '../public/main_page.svg'


export function Page1() {
  return (
    <div className="h-screen snap-start">
      <div className='h-12'></div>
      <div className="flex justify-start">
        <div style={{ width: '3.2%' }}></div>

        {/* Left Section with Leap Icon and Text Below it */}
        <div className="flex flex-col items-center">
          <Image
            src={leap_icon}
            alt="Leap Icon representing our bond investment style"
            width="500"
            height="100"
            style={{
              width: '40vw', 
              height: '80%', 
              objectFit: 'contain', 
              objectPosition: 'center'
            }}
          />
          <p 
            className="font-black"
            style={{
              fontSize: "clamp(1.2rem, 2.8vw, 5rem)",
              color: "#f9fafb",
              fontWeight: "900",
              marginTop: '1rem'
            }}
          >
            우리들의 채권 투자 스타일
          </p>
        </div>
        
        <div style={{ width: '6.4%' }}></div>
        {/* Right Section with Main Image */}
        <div
          className="flex"
          style={{
            width: '45vw', 
            display: 'flex',
            flexWrap: 'wrap', // 줄 바꿈 허용
            justifyContent: 'space-between', // 열 간격 균등 분배
            alignItems: 'center', // 세로 정렬
            gap: '1rem', // 요소 간 간격
            transform: 'rotate(0deg)' // 원하는 회전 각도
          }}
          >
          {[...Array(1)].map((_, index) => (
            <Image
              key={index}
              src={main_page}
              alt="Main image representing our investment philosophy"
              width="500"
              height="100"
              style={{
                width: '30vw', // 한 줄에 3개씩 배치되도록 
                height: '80vh', 
                objectFit: 'contain',
                objectPosition: 'center'
              }}
            />
          ))}
        </div>
      </div>
    </div>
  );
}
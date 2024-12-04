import Image from 'next/image';
import leap_icon from '../public/leap_white.svg'
import main_page from '../public/main_page.svg'


export function Page3() {
  return (
    <div className="h-screen snap-start">
      <div className='h-12'></div>
      <div className="flex justify-start">
        <div style={{ width: '10%' }}></div>
        <div className="flex flex-col items-center">
          <Image
            src={main_page}
            alt="Leap Icon representing our bond investment style"
            width="500"
            height="100"
            style={{
              width: '30vw', 
              height: '80vw', 
              objectFit: 'contain', 
              objectPosition: 'center'
            }}
          />
        </div>
        <div style={{width: '60%'}}>
        <p 
            className="font-black text-center"
            style={{
              fontSize: "clamp(1.2rem, 2.8vw, 5rem)",
              color: "#f9fafb",
              fontWeight: "900",
              marginTop: '5rem'
            }}
          >
            페이지 한줄 소개 
        </p>
        <p 
            className="font-black text-center"
            style={{
              fontSize: "clamp(1.2rem, 2.0vw, 5rem)",
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
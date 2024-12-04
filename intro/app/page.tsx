'use client'
import { Page1 } from '@/landing_page/page1'
import { Page2 } from '@/landing_page/page2'
import { Page3 } from '@/landing_page/page3'
import { Page4 } from '@/landing_page/page4'


import { useRef, useState, useEffect, useLayoutEffect } from 'react';
import debounce from 'lodash.debounce';
 
export default function Home() {
  const [isScrolling, setIsScrolling] = useState(false); // 스크롤 중인지 확인하는 상태

  const sectionRefs = [
    useRef<HTMLDivElement | null>(null),
    useRef<HTMLDivElement | null>(null),
    useRef<HTMLDivElement | null>(null),
    useRef<HTMLDivElement | null>(null),
  ];

  const handleScroll = debounce((e: WheelEvent) => {

    if (isScrolling) return;

    setIsScrolling(true);

    const current = e.deltaY > 0 ? 1 : -1;
    const currentIndex = sectionRefs.findIndex(ref => {
      const top = ref.current?.getBoundingClientRect().top || 0;
      return Math.abs(top) < 300; // Allow a margin of error( 가로가 작은 스크린 호환 )
    });    const nextIndex = Math.min(Math.max(currentIndex + current, 0), sectionRefs.length - 1);
    const nextSection = sectionRefs[nextIndex]?.current;

    if (nextSection) {
      nextSection.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }

    setTimeout(() => {
      setIsScrolling(false);
    }, 300);

  }, 10);



  return (
    <div onWheel={handleScroll} className="overflow-hidden scroll-smooth">
      <div ref={sectionRefs[0]}>
        <Page1 />
      </div>
      <div ref={sectionRefs[1]}>
        <Page2 />
      </div>
      <div ref={sectionRefs[2]}>
        <Page3 />
      </div>
      <div ref={sectionRefs[3]}>
        <Page4 />
      </div>
    </div>
  );
}
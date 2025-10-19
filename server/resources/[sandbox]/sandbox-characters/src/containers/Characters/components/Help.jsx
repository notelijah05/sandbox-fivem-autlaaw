import React from 'react';

export default () => {
  return (
    <div className="absolute bottom-0 left-0 right-0 m-auto h-10 w-fit pointer-events-none z-10 flex bg-[#0f0f0fcc] border-l-4 border-info">
      <small className="text-xs block leading-10 px-1.5">HELP</small>
      <div className="text-white text-[18px] leading-10 shadow-[0_0_5px_#000] pl-[5px] pr-[15px] flex border-l border-[rgba(255,255,255,0.12)]">
        <span className="text-primary font-bold mr-1">Double Click</span>
        To Play As Character.
        <span className="text-primary font-bold mx-1">Right Click</span>
        To Delete Character
      </div>
    </div>
  );
};

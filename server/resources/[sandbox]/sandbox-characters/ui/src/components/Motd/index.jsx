import React from 'react';

export default ({ message }) => {
  return (
    <div className="absolute top-[5%] pointer-events-none z-10 flex bg-[#0f0f0fcc] border-l-4 border-primary">
      <small className="text-xs block leading-10 px-1.5">MOTD</small>
      <div className="text-white text-[18px] leading-10 shadow-[0_0_5px_#000] px-4 border-l border-[rgba(255,255,255,0.12)] flex">
        {message}
      </div>
    </div>
  );
};

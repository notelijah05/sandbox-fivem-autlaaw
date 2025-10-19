import React from 'react';
import { useSelector } from 'react-redux';
import logo from '../../assets/imgs/logo_banner.png';

export default () => {
  const loading = useSelector((state) => state.loader.loading);
  const message = useSelector((state) => state.loader.message);

  if (!loading) return null;
  return (
    <div className="absolute bottom-0 top-0 left-0 right-0 m-auto w-[800px] h-[500px] bg-[#141414] border-l-4 border-primary">
      <div className="w-full p-[25px] text-center">
        <img className="max-w-[450px] w-full border-b border-[rgba(255,255,255,0.12)] mb-[15px] mx-auto" src={logo} />
        <div className="text-white text-[28px] text-center p-[15px] shadow-[0_0_5px_#000]">{message}</div>
      </div>
      <div className="h-1 bg-[#141414]">
        <div className="h-1 bg-primary w-full animate-pulse"></div>
      </div>
    </div>
  );
};


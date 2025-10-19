import React, { useEffect, useState } from 'react';
import { useDispatch } from 'react-redux';

import Nui from '../../util/Nui';
import { GetData } from '../../util/NuiEvents';

import logo from '../../assets/imgs/logo_banner.png';

export default () => {
  const dispatch = useDispatch();
  const [show, setShow] = useState(true);

  const onAnimEnd = () => {
    Nui.send(GetData);
    dispatch({ type: 'LOADING_SHOW', payload: { message: 'Loading Server Data' } });
  };

  const Bleh = (e) => {
    if (e.which == 1 || e.which == 13 || e.which == 32) {
      setShow(false);
    }
  };

  useEffect(() => {
    ['click', 'keydown', 'keyup'].forEach(function (e) {
      window.addEventListener(e, Bleh);
    });
    return () => {
      ['click', 'keydown', 'keyup'].forEach(function (e) {
        window.removeEventListener(e, Bleh);
      });
    };
  }, []);

  useEffect(() => {
    if (!show) onAnimEnd();
  }, [show]);

  if (!show) return null;
  return (
    <div className="absolute z-[1000] w-[800px] h-[500px] p-9 left-0 right-0 top-0 bottom-0 m-auto text-center text-[30px] text-white bg-[#141414] border-l-6 border-l-primary">
      <img className="max-w-[450px] w-full border-b border-[rgba(255,255,255,0.12)] mx-auto" src={logo} />
      <div className="pt-[50px]">
        <span className="text-[1.5vw] block">
          Welcome To <span className="text-primary">SandboxRP</span>
        </span>
        <span className="text-[0.75vw] animate-pulse">
          <span className="font-medium text-primary">ENTER</span>
          {' / '}
          <span className="font-medium text-primary">SPACE</span>
          {' / '}
          <span className="font-medium text-primary">LEFT MOUSE</span>{' '}
        </span>
      </div>
    </div>
  );
};


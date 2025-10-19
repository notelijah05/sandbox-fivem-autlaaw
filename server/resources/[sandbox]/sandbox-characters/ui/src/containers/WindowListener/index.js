import React, { useEffect } from 'react';
import { useDispatch } from 'react-redux';

const mapType = (t) => {
  if (!t) return t;
  switch (t) {
    case 'AppShow':
      return 'APP_SHOW';
    case 'AppHide':
      return 'APP_HIDE';
    case 'AppReset':
      return 'APP_RESET';
    case 'SetData':
      return 'SET_DATA';
    case 'SetCharacters':
      return 'SET_CHARACTERS';
    case 'SetSpawns':
      return 'SET_SPAWNS';
    case 'LoadingShow':
      return 'LOADING_SHOW';
    case 'LoadingHide':
      return 'LOADING_HIDE';
    default:
      return t;
  }
};

export default ({ children }) => {
  const dispatch = useDispatch();

  const handleEvent = (event) => {
    // FiveM SendNuiMessage typically passes a JSON string; support both string and object
    let payload = event?.data;
    if (typeof payload === 'string') {
      try {
        payload = JSON.parse(payload);
      } catch (e) {
        // ignore non-JSON strings
        return;
      }
    }
    const type = mapType(payload?.type);
    const data = payload?.data ?? payload?.payload ?? {};
    if (type) {
      dispatch({ type, payload: { ...data } });
    }
  };

  useEffect(() => {
    window.addEventListener('message', handleEvent);
    return () => {
      window.removeEventListener('message', handleEvent);
    };
  }, []);

  return React.Children.only(children);
};

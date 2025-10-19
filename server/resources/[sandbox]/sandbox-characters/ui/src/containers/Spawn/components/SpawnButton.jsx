/* eslint-disable react/prop-types */
import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { SelectSpawn } from '../../../util/NuiEvents';
import Nui from '../../../util/Nui';

export default ({ spawn, onPlay }) => {
  const dispatch = useDispatch();
  const selected = useSelector((state) => state.spawn.selected);

	const onClick = () => {
		Nui.send(SelectSpawn, { spawn });
		dispatch({
			type: 'SELECT_SPAWN',
			payload: spawn,
		});
	};

	return (
    <div
      className={`w-[300px] h-[50px] p-[5px] leading-[25px] flex bg-[#0f0f0fcc] border-l-2 border-[#1c1c1c] select-none transition-colors ${
        selected?.id == spawn?.id ? 'border-primary' : ''
      } hover:border-primary cursor-pointer mb-1`}
      onDoubleClick={onPlay}
      onClick={onClick}
    >
      <div className="w-[48px] block text-[18px] p-[5px] pl-0 text-center border-r border-[rgba(255,255,255,0.12)] leading-[35px]">
        <FontAwesomeIcon icon={Boolean(spawn.icon) ? spawn.icon : 'location-dot'} />
      </div>
      <div className="p-[5px]">
        <div className="leading-[35px] text-[18px] text-white">{spawn.label}</div>
      </div>
    </div>
  );
};

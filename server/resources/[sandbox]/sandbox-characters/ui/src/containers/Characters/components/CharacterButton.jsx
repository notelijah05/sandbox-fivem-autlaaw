/* eslint-disable react/prop-types */
import React, { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import dayjs from 'dayjs';

import Nui from '../../../util/Nui';
import { SelectCharacter, DeleteCharacter } from '../../../util/NuiEvents';

export default ({ character }) => {
  const dispatch = useDispatch();
  const selected = useSelector((state) => state.characters.selected);

	const [open, setOpen] = useState(false);

	const onClick = () => {
		dispatch({
			type: 'LOADING_SHOW',
			payload: { message: 'Getting Spawn Points' },
		});
		dispatch({
			type: 'SELECT_CHARACTER',
			payload: {
				character: character,
			},
		});
		Nui.send(SelectCharacter, { id: character.ID });
	};

	const onRightClick = (e) => {
		e.preventDefault();
		setOpen(true);
	};

	const onDelete = () => {
		dispatch({
			type: 'LOADING_SHOW',
			payload: { message: 'Deleting Character' },
		});
		Nui.send(DeleteCharacter, { id: character.ID });
	};

	return (
    <div>
      <div
        className={`w-[300px] h-[100px] p-[5px] leading-[25px] inline-flex bg-[#0f0f0fcc] border-l-2 border-[#1c1c1c] select-none transition-colors ${
          selected?.ID == character?.ID ? 'border-primary' : ''
        } hover:border-primary cursor-pointer mr-1`}
        onDoubleClick={onClick}
        onContextMenu={onRightClick}
      >
        <div className="w-[48px] block text-[18px] p-[5px] pl-0 text-center border-r border-[rgba(255,255,255,0.12)] leading-[85px]">
          {character.SID}
        </div>
        <div className="p-[5px] text-white">
          <div className="leading-6 text-[18px]">{character.First} {character.Last}</div>
          <div className="leading-6 text-[14px]">
            {!Boolean(character?.Jobs) || character?.Jobs?.length == 0 ? (
              <span>Unemployed</span>
            ) : character?.Jobs?.length == 1 ? (
              <span>
                {character?.Jobs[0].Workplace
                  ? `${character?.Jobs[0].Workplace.Name} - ${character?.Jobs[0].Grade.Name}`
                  : `${character?.Jobs[0].Name} - ${character?.Jobs[0].Grade.Name}`}
              </span>
            ) : (
              <span>{character?.Jobs?.length} Jobs</span>
            )}
          </div>
          <div className="leading-6 text-[14px]">
            Last Played:{' '}
            {+character.LastPlayed === -1 ? (
              <span>Never</span>
            ) : (
              <span className="opacity-100">
                <small>{dayjs(+character.LastPlayed).format('M/D/YYYY h:mm:ss A')}</small>
              </span>
            )}
          </div>
        </div>
      </div>
      {open && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50" onClick={() => setOpen(false)}>
          <div className="bg-[#0f0f0f] text-white p-4 w-[420px] border-l-4 border-primary" onClick={(e) => e.stopPropagation()}>
            <div className="text-lg font-semibold mb-2">{`Delete ${character.First} ${character.Last}?`}</div>
            <div className="text-sm opacity-90 mb-4">
              Are you sure you want to delete {character.First} {character.Last}? This action is completely & entirely
              irreversible by <i><b>anyone</b></i> including staff. Proceed?
            </div>
            <div className="flex justify-end gap-2">
              <button className="px-3 py-1 bg-[#1c1c1c] text-white" onClick={() => setOpen(false)}>No</button>
              <button className="px-3 py-1 bg-primary text-black" onClick={onDelete} autoFocus>Yes</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

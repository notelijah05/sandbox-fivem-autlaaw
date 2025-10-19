import React from 'react';
import { useDispatch, useSelector } from 'react-redux';

import Nui from '../../util/Nui';
import { Motd } from '../../components';
import logo from '../../assets/imgs/logo_banner.png';

import SpawnButton from './components/SpawnButton';
import { STATE_CHARACTERS } from '../../util/States';
import { PlayCharacter } from '../../util/NuiEvents';

export default (props) => {
  const dispatch = useDispatch();

	const motd = useSelector((state) => state.characters.motd);
	const spawns = useSelector((state) => state.spawn.spawns);
	const selected = useSelector((state) => state.spawn.selected);
	const selectedChar = useSelector((state) => state.characters.selected);

	const onSpawn = () => {
		Nui.send(PlayCharacter, {
			spawn: selected,
			character: selectedChar,
		});
		dispatch({
			type: 'LOADING_SHOW',
			payload: { message: 'Spawning' },
		});
		dispatch({
			type: 'UPDATE_PLAYED',
		});
		dispatch({ type: 'DESELECT_CHARACTER' });
		dispatch({ type: 'DESELECT_SPAWN' });
	};

	const goBack = () => {
		dispatch({ type: 'DESELECT_CHARACTER' });
		dispatch({ type: 'DESELECT_SPAWN' });
		dispatch({
			type: 'SET_STATE',
			payload: { state: STATE_CHARACTERS },
		});
	};

	return (
		<div className="relative h-[100vh] w-[100vw] text-white">
			{Boolean(motd) && <Motd message={motd} />}
			<img className="w-[300px] h-[169px] absolute right-0 top-0" src={logo} />
			<div className="absolute top-0 bottom-0 left-0 m-auto w-fit h-fit gap-1 max-w-[310px] max-h-[600px] h-full overflow-auto">
				{spawns.map((spawn, i) => (
					<SpawnButton key={i} spawn={spawn} onPlay={onSpawn} />
				))}
			</div>
			<div className="h-fit w-[300px] absolute right-0 left-0 bottom-10 m-auto border-l-4 border-primary">
				<div className="bg-[#0f0f0fcc] p-[10px]">
					<div className="text-[18px] text-white">Spawning As</div>
					<div className="text-[22px] text-primary-dark font-bold">
						{selectedChar.First} {selectedChar.Last}
					</div>
					<div className="text-[18px] text-white">At</div>
					{Boolean(selected) ? (
						<div className="text-[22px] text-primary-dark font-bold">{selected.label}</div>
					) : (
						<div className="text-[22px] text-primary-dark font-bold">(No Spawn Selected)</div>
					)}
				</div>
				<div className="flex">
					<button className="flex-1 px-3 py-2 bg-error text-white rounded-none" onClick={goBack}>Cancel</button>
					{Boolean(selected) && (
						<button className="flex-1 px-3 py-2 bg-success text-black rounded-none" onClick={onSpawn}>Play</button>
					)}
				</div>
			</div>
		</div>
	);
};


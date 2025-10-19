import React from 'react';
import { useSelector } from 'react-redux';

import { Motd } from '../../components';
import logo from '../../assets/imgs/logo_banner.png';

import CharacterButton from './components/CharacterButton';
import Help from './components/Help';
import CreateCharacter from './components/CreateCharacter';

export default (props) => {
  const characters = useSelector((state) => state.characters.characters);
	const characterLimit = useSelector(
		(state) => state.characters.characterLimit,
	);
	const motd = useSelector((state) => state.characters.motd);

	return (
		<div className="relative h-[100vh] w-[100vw] text-white">
			{Boolean(motd) && <Motd message={motd} />}
			<Help />
			<img className="w-[300px] h-[169px] absolute right-0 top-0" src={logo} />
			<div className="absolute bottom-[100px] left-0 right-0 m-auto w-fit h-fit gap-1 max-w-[95.3vw] h-[101px] overflow-auto">
				{characters.length < characterLimit && <CreateCharacter />}
				{characters.length > 0 && characters.map((char, i) => (
					<CharacterButton key={i} id={i} character={char} />
				))}
			</div>
		</div>
	);
};


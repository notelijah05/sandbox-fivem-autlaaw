import React from 'react';
import { useSelector } from 'react-redux';
import { MantineProvider } from '@mantine/core';
import { library } from '@fortawesome/fontawesome-svg-core';
import { fas } from '@fortawesome/free-solid-svg-icons';
import { fab } from '@fortawesome/free-brands-svg-icons';

import Loader from '../Loader';
import Splash from '../Splash';
import Characters from '../Characters';
import Create from '../Create';
import Spawn from '../Spawn';

import { STATE_CHARACTERS, STATE_CREATE, STATE_SPAWN } from '../../util/States';

library.add(fab, fas);

export default () => {
	const hidden = useSelector((state) => state.app.hidden);
	const appState = useSelector((state) => state.app.state);
	const loading = useSelector((state) => state.loader.loading);

	const mantineTheme = {
		fontFamily: 'Source Sans Pro, sans-serif',
		primaryColor: 'yellow',
		defaultRadius: 'sm',
		colors: {
			yellow: ['#fff7cc','#ffef99','#ffe566','#ffdb33','#ffd100','#e5a502','#cc9502','#b28502','#996f02','#805b02'],
			dark: ['#C1C2C5','#A6A7AB','#909296','#5c5f66','#373a40','#2c2e33','#25262b','#141414','#0f0f0f','#010101'],
		},
	};

	let display;

	switch (appState) {
		case STATE_CHARACTERS:
			display = <Characters />;
			break;
		case STATE_CREATE:
			display = <Create />;
			break;
		case STATE_SPAWN:
			display = <Spawn />;
			break;
		default:
			display = <Splash />;
			break;
	}

	return (
		<MantineProvider withGlobalStyles withNormalizeCSS theme={mantineTheme}>
			{!hidden && (
				<div className="App">{loading ? <Loader /> : display}</div>
			)}
		</MantineProvider>
	);
};

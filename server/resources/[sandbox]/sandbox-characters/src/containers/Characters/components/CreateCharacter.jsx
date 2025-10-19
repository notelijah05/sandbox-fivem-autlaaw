/* eslint-disable react/prop-types */
import React from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useDispatch } from 'react-redux';

import { STATE_CREATE } from '../../../util/States';

export default () => {
	const dispatch = useDispatch();

	const onClick = () => {
		dispatch({
			type: 'SET_STATE',
			payload: { state: STATE_CREATE },
		});
	};

	return (
		<div
			className="h-[100px] p-[5px] leading-[25px] inline-block bg-[#0f0f0fcc] border-l-2 border-success text-center mr-[15px] hover:border-success-dark cursor-pointer"
			onClick={onClick}
		>
			<div className="px-[10px] py-[5px] text-[22px] leading-[85px]">
				<FontAwesomeIcon className="mr-2 text-success" icon="plus-circle" />
			</div>
		</div>
	);
};

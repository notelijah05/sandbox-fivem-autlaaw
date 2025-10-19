/* eslint-disable react/prop-types */
import React, { useState } from 'react';
import { useDispatch } from 'react-redux';
import { TextInput, Select, Autocomplete, Textarea, NativeSelect, Input } from '@mantine/core';
import { DatePickerInput } from '@mantine/dates';
import { getCodeList } from 'country-list';
import moment from 'moment';

import Nui from '../../util/Nui';

import { STATE_CHARACTERS } from '../../util/States';
import { CreateCharacter } from '../../util/NuiEvents';

const genders = [
  { value: 0, label: 'Male' },
  { value: 1, label: 'Female' },
];

const countriesOrigin = getCodeList();
const date = new Date();
date.setFullYear(date.getFullYear() - 18);
const date2 = new Date();
date2.setFullYear(date2.getFullYear() - 100);

export default () => {
  const dispatch = useDispatch();

  const countries = Object.keys(countriesOrigin).map((code) => {
    const raw = countriesOrigin[code];
    const label = raw.replace(/\s*\((the|of.*)\)$/i, '').trim(); // drop ISO suffixes
    return { value: code, label };
  });

  const [state, setState] = useState({
    first: '',
    last: '',
    dob: moment().subtract(18, 'years').toDate(),
    gender: 0,
    bio: '',
    origin: null,
    originInput: '',
  });

  const onChange = (evt) => {
    const { name, value } = evt.target;
    if (name === 'first' || name === 'last') {
      setState((s) => ({ ...s, [name]: String(value).replace(/\s/g, '') }));
    } else {
      setState((s) => ({ ...s, [name]: value }));
    }
  };

  const onSubmit = (evt) => {
    evt.preventDefault();
    const data = {
      first: state.first,
      last: state.last,
      gender: state.gender,
      dob: state.dob,
      lastPlayed: -1,
      origin: state.origin,
    };
    Nui.send(CreateCharacter, data);
    dispatch({ type: 'LOADING_SHOW', payload: { message: 'Creating Character' } });
  };

  return (
    <div className="absolute w-[650px] h-[550px] top-0 bottom-0 right-0 left-0 m-auto bg-[#141414] border-l-4 border-primary text-white">
      <div className="m-[25px]">
        <div className="text-center border-b border-[rgba(255,255,255,0.12)] text-[26px] pb-[15px] mb-[15px]">Create Character</div>
        <form autoComplete="off" id="createForm" className="flex justify-evenly py-[1%] flex-wrap" onSubmit={onSubmit}>
          <div className="w-[45%] block m-[10px]">
            <TextInput required label="First Name" name="first" value={state.first} onChange={onChange} />
          </div>
          <div className="w-[45%] block m-[10px]">
            <TextInput required label="Last Name" name="last" value={state.last} onChange={onChange} />
          </div>
          <div className="w-[94%] block m-[10px]">
            <Autocomplete
              label="Country of Origin"
              data={countries.map((c) => c.label)}
              value={state.originInput}
              onChange={(label) => { const found = countries.find((c) => c.label === label) || null; setState((s) => ({ ...s, originInput: label, origin: found })); }}
            />
          </div>
          <div className="w-[45%] block m-[10px]">
            <Select
              required
              label="Gender"
              name="gender"
              data={genders.map((g) => ({ value: String(g.value), label: g.label }))}
              value={String(state.gender)}
              onChange={(v) => setState((s) => ({ ...s, gender: parseInt(v ?? '0', 10) }))}
            />
          </div>
          <div className="w-[45%] block m-[10px]">
            <DatePickerInput
              label="Date of Birth"
              required
              value={state.dob}
              onChange={(d) => setState((s) => ({ ...s, dob: d || s.dob }))}
              valueFormat="MM/DD/YYYY"
              maxDate={date}
              minDate={date2}
            />
          </div>
          <div className="w-[94%] block m-[10px]">
            <Textarea
              required
              label="Character Biography"
              name="bio"
              minRows={4}
              value={state.bio}
              onChange={(e) => onChange({ target: { name: 'bio', value: e.currentTarget.value } })}
            />
          </div>
        </form>
      </div>
      <div className="text-center">
        <button
          type="button"
          className="inline-block text-[14px] leading-5 font-medium px-5 py-2 rounded-[3px] select-none m-[10px] w-[40%] border-2 border-error-dark bg-error text-white hover:brightness-75"
          onClick={() => {
            dispatch({ type: 'SET_STATE', payload: { state: STATE_CHARACTERS } });
          }}
        >
          Cancel
        </button>
        <button
          type="submit"
          className="inline-block text-[14px] leading-5 font-medium px-5 py-2 rounded-[3px] select-none m-[10px] w-[40%] border-2 border-success-dark bg-success text-black hover:brightness-75"
          form="createForm"
        >
          Create
        </button>
      </div>
    </div>
  );
};


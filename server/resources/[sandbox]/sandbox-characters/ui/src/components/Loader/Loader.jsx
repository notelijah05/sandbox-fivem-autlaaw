import React from 'react';
import { Loader } from '@mantine/core';

export default () => {
  return (
    <div className="inline-block w-[200px] h-[200px] overflow-hidden bg-transparent">
      <div className="w-full h-full flex items-center justify-center">
        <Loader color="yellow" size="xl" />
      </div>
    </div>
  );
};


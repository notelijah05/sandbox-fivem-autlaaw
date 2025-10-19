/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './index.html',
    './src/**/*.{js,jsx,ts,tsx}',
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        // Map primary/secondary and other palette used previously
        primary: {
          DEFAULT: '#E5A502',
          light: '#E8A933',
          dark: '#FA5800',
          contrastText: '#ffffff',
        },
        secondary: {
          DEFAULT: '#141414',
          light: '#1c1c1c',
          dark: '#0f0f0f',
          contrastText: '#ffffff',
        },
        error: {
          DEFAULT: '#6e1616',
          light: '#a13434',
          dark: '#430b0b',
        },
        success: {
          DEFAULT: '#52984a',
          light: '#60eb50',
          dark: '#244a20',
        },
        warning: {
          DEFAULT: '#f09348',
          light: '#f2b583',
          dark: '#b05d1a',
        },
        info: {
          DEFAULT: '#247ba5',
          light: '#247ba5',
          dark: '#175878',
        },
        text: {
          main: '#ffffff',
          alt: '#cecece',
          info: '#919191',
          light: '#ffffff',
          dark: '#000000',
        },
        border: {
          main: '#e0e0e008',
          light: '#ffffff',
          dark: '#26292d',
          input: 'rgba(255, 255, 255, 0.23)',
          divider: 'rgba(255, 255, 255, 0.12)',
        },
      },
    },
  },
  plugins: [],
};


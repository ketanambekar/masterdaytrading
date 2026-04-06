/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        dark: {
          bg: '#0a0a0b',
          surface: '#131314',
          border: '#1e1e1f',
          hover: '#1a1a1b',
        },
        chart: {
          green: '#26a69a',
          red: '#ef5350',
          grid: '#2a2e39',
        }
      },
    },
  },
  plugins: [],
}

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './_layouts/**/*.html',
    './_posts/**/*.{md,markdown}',
    './*.{html,md,markdown}'
  ],
  theme: {
    extend: {
      animation: {
        'fade-in': 'fadeIn 0.7s ease both'
      },
      keyframes: {
        fadeIn: {
          from: { opacity: '0', transform: 'translateY(10px)' },
          to: { opacity: '1', transform: 'translateY(0)' }
        }
      }
    }
  },
  plugins: []
};

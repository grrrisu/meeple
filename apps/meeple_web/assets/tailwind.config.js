const colors = require("tailwindcss/colors");

module.exports = {
  mode: "jit",
  purge: ["./js/**/*.js", "../lib/*_web/**/*.*ex"],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      colors: {
        brown: {
          50: "#644A36",
        },
        beige: {
          50: "#EEDFC2",
        },
        ochre: {
          50: "#D78C5D",
        },
        olive: {
          50: "#7E8F7C",
        },
        steelblue: {
          50: "#8294B0",
          900: "#252E42",
        },
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
};

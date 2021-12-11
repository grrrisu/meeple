const colors = require("tailwindcss/colors");

module.exports = {
  mode: "jit",
  purge: ["./js/**/*.js", "../lib/*_web/**/*.*ex"],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      colors: {
        brown: {
          50: "#FAF5F1",
          100: "#F4E8DE",
          200: "#EFDCCD",
          300: "#E2C2AA",
          400: "#CFA88A",
          500: "#B58D6E",
          600: "#926E52",
          700: "#644A36", // original
          800: "#3B2A1D",
          900: "#0F0A07",
        },
        almond: {
          50: "#FFFBF2",
          100: "#EEDFC2", // original
          200: "#EED7AA",
          300: "#E7C27A",
          400: "#DBAC51",
          500: "#C89633",
          600: "#AE7E1E",
          700: "#8A6210",
          800: "#5F4208",
          900: "#302103",
        },
        copperfield: {
          50: "#FFF8F3",
          100: "#FDEADF",
          200: "#FCDDCA",
          300: "#F4C09F",
          400: "#E9A47A",
          500: "#D78C5D", // original
          600: "#BD7141",
          700: "#9C562B",
          800: "#733C1A",
          900: "#47240E",
        },
        olive: {
          50: "#FDFFFD",
          100: "#F3F9F2",
          200: "#E9F2E8",
          300: "#D5E4D3",
          400: "#BED0BB",
          500: "#A1B49F",
          600: "#7E8F7C", // original
          700: "#5B695A",
          800: "#323A31",
          900: "#262B26",
        },
        grass: {
          50: "#F8FAF1",
          100: "#F2F9D8",
          200: "#EDF7BE",
          300: "#DEF08D",
          400: "#CDE464",
          500: "#B9D344",
          600: "#A0BA2D", // original
          700: "#81971D",
          800: "#5C6D12",
          900: "#36400A",
        },
        yellowish: {
          50: "#FFFFF2",
          100: "#FFFFD9",
          200: "#FFFFBF",
          300: "#FAF88D",
          400: "#EFEC63",
          500: "#DED942",
          600: "#C6C02A", // original
          700: "#9E9A19",
          800: "#6E6C0E",
          900: "#3B3B07",
        },
        steelblue: {
          50: "#F2F7FF",
          100: "#E3EAF6",
          200: "#D5DEED",
          300: "#B7C6DE",
          400: "#9CAECA",
          500: "#8294B0", // original
          600: "#687D9E",
          700: "#4D6284",
          800: "#344562",
          900: "#1D2A3D",
        },
        blood: {
          50: "#FFF3F2",
          100: "#FDD8D3",
          200: "#FABCB4",
          300: "#F48C7E",
          400: "#EA6351",
          500: "#DC442F",
          600: "#C82D17", // original
          700: "#B1220F",
          800: "#941B0B",
          900: "#751609",
        },
        marine: {
          50: "#E7F0FA",
          100: "#CDE5FF",
          200: "#B2D9FF",
          300: "#7ABBFF",
          400: "#499EFE",
          500: "#2483F0", // original
          600: "#0E68CF",
          700: "#034FA5",
          800: "#003674",
          900: "#001E40",
        },
        forest: {
          50: "#F5F5F5",
          100: "#EDF3DE",
          200: "#E6F1C8",
          300: "#D2E89B",
          400: "#BDD974",
          500: "#A3C255",
          600: "#85A13B",
          700: "#607626",
          800: "#354213", // original
          900: "#20290B",
        },
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
};

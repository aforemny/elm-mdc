const path = require('path');

module.exports = {
  entry: './src/elm-mdc.js',
  output: {
      path: path.resolve(__dirname, './'),
    filename: 'elm-mdc.js'
  }
};


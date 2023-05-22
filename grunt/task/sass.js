/* jshint strict:false */

const sass = require('node-sass')

module.exports = {
  options: {
    implementation: sass
  },

  "general": {
    files: {
      'dist/general/css/main.css': [
        'src/general/sass/main.scss'
      ]
    }
  },

  "ym-primary": {
    files: {
      'dist/ym-primary/css/main.css': [
        'src/ym-primary/sass/main.scss'
      ],
      'dist/ym-primary/css/participant.css': [
        'src/ym-primary/sass/participant.scss'
      ]
    }
  },

  "middle-school": {
    files: {
      'dist/middle-school/css/main.css': [
        'src/middle-school/sass/main.scss'
      ],
      'dist/middle-school/css/participant.css': [
        'src/middle-school/sass/participant.scss'
      ]
    }
  },

  "ym-rewards": {
    files: {
      'dist/ym-rewards/css/main.css': [
        'src/ym-rewards/sass/main.scss'
      ]
    }
  }
}

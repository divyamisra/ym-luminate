/* jshint strict:false */

module.exports = {
  "general": {
    files: [
      {
        src: [
          'dist/general/js/main.js'
        ],
        dest: 'dist/general/js/main.' + '<%= timestamp %>' + '.min.js'
      }
    ]
  },

  "ym-primary": {
    files: [
      {
        src: [
          'dist/ym-primary/js/main.js'
        ],
        dest: 'dist/ym-primary/js/main.' + '<%= timestamp %>' + '.min.js'
      },
      {
        src: [
          'dist/ym-primary/js/participant.js'
        ],
        dest: 'dist/ym-primary/js/participant.' + '<%= timestamp %>' + '.min.js'
      }
    ]
  },

  "middle-school": {
    files: [
      {
        src: [
          'dist/middle-school/js/main.js'
        ],
        dest: 'dist/middle-school/js/main.' + '<%= timestamp %>' + '.min.js'
      },
      {
        src: [
          'dist/middle-school/js/participant.js'
        ],
        dest: 'dist/middle-school/js/participant.' + '<%= timestamp %>' + '.min.js'
      }
    ]
  },

  "ym-rewards": {
    files: [
      {
        src: [
          'dist/ym-rewards/js/main.js'
        ],
        dest: 'dist/ym-rewards/js/main.' + '<%= timestamp %>' + '.min.js'
      }
    ]
  }
}

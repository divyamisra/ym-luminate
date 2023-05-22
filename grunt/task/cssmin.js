/* jshint strict:false */

module.exports = {
  options: {
    noAdvanced: true
  },

  "general": {
    files: [
      {
        src: 'dist/general/css/main.css',
        dest: 'dist/general/css/main.'+ '<%= timestamp %>' +'.min.css'
      }
    ]
  },

  "ym-primary": {
    files: [
      {
        src: 'dist/ym-primary/css/main.css',
        dest: 'dist/ym-primary/css/main.'+ '<%= timestamp %>' +'.min.css'
      },
      {
        src: 'dist/ym-primary/css/participant.css',
        dest: 'dist/ym-primary/css/participant.'+'<%= timestamp %>'+'.min.css'
      }
    ]
  },

  "middle-school": {
    files: [
      {
        src: 'dist/middle-school/css/main.css',
        dest: 'dist/middle-school/css/main.'+ '<%= timestamp %>' +'.min.css'
      },
      {
        src: 'dist/middle-school/css/participant.css',
        dest: 'dist/middle-school/css/participant.'+'<%= timestamp %>'+'.min.css'
      }
    ]
  },

  "ym-rewards": {
    files: [
      {
        src: 'dist/ym-rewards/css/main.css',
        dest: 'dist/ym-rewards/css/main.'+ '<%= timestamp %>' +'.min.css'
      }
    ]
  }
}

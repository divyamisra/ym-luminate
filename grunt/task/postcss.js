/* jshint strict:false */

module.exports = {
  options: {
    processors: [
      require('autoprefixer')({
        overrideBrowserslist: [
          'last 2 versions',
          'ie >= 9',
          'Safari >= 9',
          'ios_saf >= 9'
        ]
      })
    ]
  },

  "general": {
    files: [
      {
        expand: true,
        cwd: 'dist/general/css/',
        src: [
          'main.css'
        ],
        dest: 'dist/general/css/'
      }
    ]
  },

  "ym-primary": {
    files: [
      {
        expand: true,
        cwd: 'dist/ym-primary/css/',
        src: [
          'main.css'
        ],
        dest: 'dist/ym-primary/css/'
      },
      {
        expand: true,
        cwd: 'dist/ym-primary/css/',
        src: [
          'participant.css'
        ],
        dest: 'dist/ym-primary/css/'
      }
    ]
  },

  "middle-school": {
    files: [
      {
        expand: true,
        cwd: 'dist/middle-school/css/',
        src: [
          'main.css'
        ],
        dest: 'dist/middle-school/css/'
      },
      {
        expand: true,
        cwd: 'dist/middle-school/css/',
        src: [
          'participant.css'
        ],
        dest: 'dist/middle-school/css/'
      }
    ]
  },

  "ym-rewards": {
    files: [
      {
        expand: true,
        cwd: 'dist/ym-rewards/css/',
        src: [
          'main.css'
        ],
        dest: 'dist/ym-rewards/css/'
      }
    ]
  }
}

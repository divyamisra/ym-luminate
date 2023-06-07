/* jshint strict:false */

module.exports = {
  options: {
    patterns: [
      {
        match: 'buildTimestamp',
        replacement: '<%= timestamp %>'
      }
    ]
  },

  "general": {
    files: [
      {
        expand: true,
        cwd: 'src/general/html/',
        src: [
          '**/*.*'
        ],
        dest: "dist/general/html/"
      }
    ]
  },

  "youth-markets": {
    files: [
      {
        expand: true,
        cwd: 'src/youth-markets/html/',
        src: [
          '**/*.*'
        ],
        dest: "dist/youth-markets/html/"
      }
    ]
  },

  "ym-primary": {
    files: [
      {
        expand: true,
        cwd: 'src/ym-primary/html/',
        src: [
          '**/*.*'
        ],
        dest: "dist/ym-primary/html/"
      }
    ]
  },

  "middle-school": {
    files: [
      {
        expand: true,
        cwd: 'src/middle-school/html/',
        src: [
          '**/*.*'
        ],
        dest: "dist/middle-school/html/"
      }
    ]
  },

  "ym-rewards": {
    files: [
      {
        expand: true,
        cwd: 'src/ym-rewards/html/',
        src: [
          '**/*.*'
        ],
        dest: "dist/ym-rewards/html/"
      }
    ]
  }
}

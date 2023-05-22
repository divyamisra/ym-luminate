/* jshint strict:false */

module.exports = {
  options: {
    collapseBooleanAttributes: true,
    collapseWhitespace: true,
    minifyCSS: true,
    minifyJS: true,
    removeComments: true,
    removeEmptyAttributes: true,
    removeScriptTypeAttributes: true,
    removeStyleLinkTypeAttributes: true
  },

  "general": {
    files: [
      {
        expand: true,
        cwd: 'dist/general/html/',
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
        cwd: 'dist/youth-markets/html/',
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
        cwd: 'dist/ym-primary/html/',
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
        cwd: 'dist/middle-school/html/',
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
        cwd: 'dist/ym-rewards/html/',
        src: [
          '**/*.*'
        ],
        dest: "dist/ym-rewards/html/"
      }
    ]
  }
}

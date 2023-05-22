/* jshint strict:false */

require('events').EventEmitter.prototype._maxListeners = 100;

module.exports = {
  "grunt-config": {
    files: [
      'Gruntfile.coffee',
      'grunt/task/*.js',
      'grunt/.jshintrc'
    ],
    tasks: [
      'jshint:grunt-config',
      'notify:grunt-config'
    ]
  },

  "global": {
    files: [
      'src/global/sass/**/*',
      'src/global/coffee/**/*',
      'src/global/html/**/*'
    ],
    tasks: [
      'notify:global'
    ]
  },

  "general": {
    files: [
      'src/global/sass/**/*',
      'src/global/coffee/**/*',
      'src/global/html/**/*',
      'src/general/sass/**/*',
      'src/general/coffee/**/*',
      'src/general/html/**/*',
      'src/general/image/**/*'
    ],
    tasks: [
      'clean:general',
      'css-dist:general',
      'js-dist:general',
      'html-dist:general',
      'img-copy:general-images',
      'notify:general'
    ]
  },

  "youth-markets": {
    files: [
      'src/youth-markets/html/**/*',
      'src/youth-markets/image/**/*'
    ],
    tasks: [
      'clean:youth-markets',
      'html-dist:youth-markets',
      'img-copy:youth-markets-images',
      'notify:youth-markets'
    ]
  },

  "ym-primary": {
    files: [
      'src/youth-markets/sass/**/*',
      'src/global/coffee/**/*',
      'src/youth-markets/coffee/**/*',
      'src/ym-primary/html/**/*',
      'src/ym-primary/image/**/*',
      'src/ym-primary/sass/**/*',
      'src/ym-primary/coffee/**/*'
    ],
    tasks: [
      'clean:ym-primary',
      'css-dist:ym-primary',
      'js-dist:ym-primary',
      'html-dist:ym-primary',
      'img-copy:ym-primary-images',
      'notify:ym-primary'
    ]
  },

  "middle-school": {
    files: [
      'src/youth-markets/sass/**/*',
      'src/global/coffee/**/*',
      'src/youth-markets/coffee/**/*',
      'src/middle-school/html/**/*',
      'src/middle-school/image/**/*',
      'src/middle-school/sass/**/*',
      'src/middle-school/coffee/**/*'
    ],
    tasks: [
      'clean:middle-school',
      'css-dist:middle-school',
      'js-dist:middle-school',
      'html-dist:middle-school',
      'img-copy:middle-school-images',
      'notify:middle-school'
    ]
  },

  "ym-rewards": {
    files: [
      'src/youth-markets/sass/**/*',
      'src/global/coffee/**/*',
      'src/youth-markets/coffee/**/*',
      'src/ym-rewards/html/**/*',
      'src/ym-rewards/images/**/*',
      'src/ym-rewards/sass/**/*',
      'src/ym-rewards/coffee/**/*'
    ]
  }
}

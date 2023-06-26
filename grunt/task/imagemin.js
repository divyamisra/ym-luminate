/* jshint strict:false */

module.exports = {
  options: {
    optimizationLevel: 3
  },

  "general": {
    files: [
      {
        expand: true,
        cwd: 'src/general/image/',
        src: [
          '*.{gif,GIF,jpg,JPG,png,PNG,svg,SVG}'
        ],
        dest: 'dist/general/image/'
      }
    ]
  },

  "youth-markets": {
    files: [
      {
        expand: true,
        cwd: 'src/youth-markets/image/',
        src: [
          '*.{gif,GIF,jpg,JPG,png,PNG,svg,SVG}'
        ],
        dest: 'dist/youth-markets/image/'
      }
    ]
  },

  "ym-primary": {
    files: [
      {
        expand: true,
        cwd: 'src/ym-primary/image/',
        src: [
          '*.{gif,GIF,jpg,JPG,png,PNG,svg,SVG}',
          'prizes*/*.{gif,GIF,jpg,JPG,png,PNG,svg,SVG}',
          'fy*/*.{gif,GIF,jpg,JPG,png,PNG,svg,SVG}'
        ],
        dest: 'dist/ym-primary/image/'
      }
    ]
  },

  "middle-school": {
    files: [
      {
        expand: true,
        cwd: 'src/middle-school/image/',
        src: [
          '*.{gif,GIF,jpg,JPG,png,PNG,svg,SVG}',
          'prizes2023/*.{gif,GIF,jpg,JPG,png,PNG,svg,SVG}',
          'fy*/*.{gif,GIF,jpg,JPG,png,PNG,svg,SVG}'
        ],
        dest: 'dist/middle-school/image/'
      }
    ]
  },

  "ym-rewards": {
    files: [
      {
        expand: true,
        cwd: 'src/ym-rewards/images/',
        src: [
          '*.{gif,GIF,jpg,JPG,png,PNG,svg,SVG}'
        ],
        dest: 'dist/ym-rewards/images/'
      }
    ]
  }
}

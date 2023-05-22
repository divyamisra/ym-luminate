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
          'prizes/*.{gif,GIF,jpg,JPG,png,PNG,svg,SVG}',
          'prizes2020/*.{gif,GIF,jpg,JPG,png,PNG,svg,SVG}',
          'prizes2021/*.{gif,GIF,jpg,JPG,png,PNG,svg,SVG}',
          'prizes2022/*.{gif,GIF,jpg,JPG,png,PNG,svg,SVG}',
          'prizes2023/*.{gif,GIF,jpg,JPG,png,PNG,svg,SVG}',
          'fy21/*.{gif,GIF,jpg,JPG,png,PNG,svg,SVG}',
          'fy22/*.{gif,GIF,jpg,JPG,png,PNG,svg,SVG}',
          'fy23/*.{gif,GIF,jpg,JPG,png,PNG,svg,SVG}'
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
          'fy22/*.{gif,GIF,jpg,JPG,png,PNG,svg,SVG}',
          'fy23/*.{gif,GIF,jpg,JPG,png,PNG,svg,SVG}'
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

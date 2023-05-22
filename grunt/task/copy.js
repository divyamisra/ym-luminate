/* jshint strict:false */

module.exports = {
  "general-images": {
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

  "youth-markets-images": {
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

  "ym-primary-images": {
    files: [
      {
        expand: true,
        cwd: 'src/ym-primary/image/',
        src: [
          '*.{gif,GIF,jpg,JPG,png,PNG,svg,SVG}'
        ],
        dest: 'dist/ym-primary/image/'
      }
    ]
  },

  "middle-school-images": {
    files: [
      {
        expand: true,
        cwd: 'src/middle-school/image/',
        src: [
          '*.{gif,GIF,jpg,JPG,png,PNG,svg,SVG}'
        ],
        dest: 'dist/middle-school/image/'
      }
    ]
  },

  "ym-rewards-images": {
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

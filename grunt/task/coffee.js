/* jshint strict:false */

module.exports = {
  options: {
    join: true
  },
  
  "general": {
    files: {
      'dist/general/js/main.js': [
        'src/general/coffee/init.coffee',
        'src/global/coffee/config/*.*',
        'src/general/coffee/config/*.*',
        'src/global/coffee/service/*.*',
        '!src/global/coffee/service/trpc-*.*',
        'src/general/coffee/service/*.*',
        'src/global/coffee/directive/*.*',
        'src/general/coffee/directive/*.*',
        'src/general/coffee/**/*.*'
      ]
    }
  },
  
  "ym-primary": {
    files: {
      'dist/ym-primary/js/main.js': [
        'src/ym-primary/coffee/init.coffee',
        'src/ym-primary/coffee/config/*.*',
        '!src/ym-primary/coffee/config/trpc-*.*',
        'src/global/coffee/service/*.*',
        '!src/global/coffee/service/trpc-*.*',
        'src/youth-markets/coffee/service/*.*',
        'src/youth-markets/coffee/controller/*.*',
        '!src/youth-markets/coffee/service/trpc-*.*',
        'src/ym-primary/coffee/service/*.*',
        '!src/ym-primary/coffee/service/trpc-*.*',
        'src/global/coffee/directive/*.*',
        'src/ym-primary/coffee/directive/*.*',
        '!src/ym-primary/coffee/directive/trpc-*.*',
        'src/ym-primary/coffee/**/*.*',
        '!src/ym-primary/coffee/**/trpc-*.*'
      ],
      'dist/ym-primary/js/participant.js': [
        'src/ym-primary/coffee/trpc-init.coffee',
        'src/ym-primary/coffee/config/trpc-*.*',
        'src/global/coffee/service/trpc-*.*',
        'src/youth-markets/coffee/service/trpc-*.*',
        'src/ym-primary/coffee/**/trpc-*.*'
      ]
    }
  },
  
  "middle-school": {
    files: {
      'dist/middle-school/js/main.js': [
        'src/middle-school/coffee/init.coffee',
        'src/middle-school/coffee/config/*.*',
        '!src/middle-school/coffee/config/trpc-*.*',
        'src/global/coffee/service/*.*',
        '!src/global/coffee/service/trpc-*.*',
        'src/youth-markets/coffee/service/*.*',
        'src/youth-markets/coffee/controller/*.*',
        '!src/youth-markets/coffee/service/trpc-*.*',
        'src/middle-school/coffee/service/*.*',
        '!src/middle-school/coffee/service/trpc-*.*',
        'src/global/coffee/directive/*.*',
        'src/middle-school/coffee/directive/*.*',
        '!src/middle-school/coffee/directive/trpc-*.*',
        'src/middle-school/coffee/filter/*.*',
        '!src/middle-school/coffee/filter/trpc-*.*',
        'src/middle-school/coffee/**/*.*',
        '!src/middle-school/coffee/**/trpc-*.*'
      ],
      'dist/middle-school/js/participant.js': [
        'src/middle-school/coffee/trpc-init.coffee',
        'src/middle-school/coffee/config/trpc-*.*',
        'src/global/coffee/service/trpc-*.*',
        'src/youth-markets/coffee/service/trpc-*.*',
        'src/middle-school/coffee/**/trpc-*.*'
      ]
    }
  },
  
  "ym-rewards": {
    files: {
      'dist/ym-rewards/js/main.js': [
        'src/ym-rewards/coffee/init.coffee',
        'src/ym-rewards/coffee/config/*.*',
        'src/global/coffee/service/*.*',
        'src/ym-rewards/coffee/service/*.*',
        'src/global/coffee/directive/*.*',
        'src/ym-rewards/coffee/directive/*.*',
        'src/ym-rewards/coffee/**/*.*'
      ]
    }
  }
}

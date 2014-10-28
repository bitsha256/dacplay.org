/*global module:false*/
module.exports = function(grunt) {
  // require('load-grunt-tasks')(grunt);

  // Project configuration.
  grunt.initConfig({
    // Metadata.
    pkg: grunt.file.readJSON('package.json'),
    banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
      '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
      '<%= pkg.homepage ? "* " + pkg.homepage + "\\n" : "" %>' +
      '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
      ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */\n',
    // Task configuration.
    concat: {
      options: {
        banner: '<%= banner %>',
        stripBanners: true
      },
      vendor: {
        src: ['jquery.easing.min.js', 'jquery.scrollUp.min.js',
              'material.min.js', 'ripple.min.js', 'waypoints.min.js'
              ].map(function(f){ return 'src/js/vendor/' + f; }),
        dest: 'js/vendor.min.js'
      },
      ie: {
        src: ['src/js/ie/html5shiv.js', 'src/js/ie/respond.min.js'],
        dest: 'js/ie.min.js'

      }
    },
    coffee: {
      compileBare: {
        options: {
          bare: true
        },
        files: {
          'js/app.js': ['src/js/app.coffee']
        }
      }
    },
    uglify: {
      options: {
        banner: '<%= banner %>'
      },
      dist: {
        src: 'js/app.js',
        dest: 'js/app.min.js'
      }
    },
    jshint: {
      options: {
        curly: true, eqeqeq: true, immed: true, latedef: true,
        newcap: true, noarg: true, sub: true, undef: true,
        unused: true, boss: true, eqnull: true,
        globals: {
          jQuery: true
        }
      },
      gruntfile: {
        src: 'Gruntfile.js'
      }
    },
    sass: {                              // Task
      dist: {                            // Target
        options: {                       // Target options
          style: 'compressed'
        },
        files: {                         // Dictionary of files
          'css/app.min.css': 'src/css/app.scss'       // 'destination': 'source'
        }
      }
    },
    cssmin: {
      minify: {
        files: {
          // 'css/app.min.css': ['css/app.scss'],
          'css/vendor.min.css': ['src/css/vendor/*.min.css']
        }
      }
    },
    watch: {
      // grunthint: {
      //   files: '<%= jshint.gruntfile.src %>',
      //   tasks: ['jshint:gruntfile']
      // },
      coffee: {
        files: 'src/js/app.coffee',
        tasks: ['coffee','uglify']
      },
      js: {
        files: 'src/js/app.js',
        tasks: ['uglify']
      },
      sass: {
        files: 'src/css/app.scss',
        tasks: ['sass']
      },
      css: {
        files: 'src/css/vendor/*.min.css',
        tasks: ['css']
      }
    }
  });

  // These plugins provide necessary tasks.
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-watch');

  // Default task.
  grunt.registerTask('default', ['coffee', 'jshint', 'concat', 'uglify', 'sass', 'cssmin']);
  grunt.registerTask('js', ['coffee', 'jshint', 'concat', 'uglify']);
  grunt.registerTask('css', ['sass', 'cssmin']);
};

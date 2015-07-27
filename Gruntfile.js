module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    browserDependencies: grunt.file.readJSON('project/browserDependencies.json'),
    coffee: {
      compileMain: {
        options: {
          bare: true
        },
        files: {
          'build/js/Main.js': ['src/*.coffee']
        }
      },
      compilePackages: {
        options: {
          bare: false,
          join: true
        },
        files: grunt.file.expand('src/coffee/*').forEach(function(dir){
          //http://stackoverflow.com/questions/17009874/dynamic-mapping-for-destinations-in-grunt-js
          var path = dir.split('/')
          var pkgName = path[path.length-1]
          console.log(pkgName)

          var k = 'build/js/<%= pkg.name %>-' + pkgName +'.js'
          var v = dir + '/**/*.coffee'
          console.log(k +": "+ v)

          var obj = { k : v}
          console.log(obj)

          return obj
        })

        //{ 'build/js/<%= pkg.name %>-CS-background.js': ['src/coffee/CS/background/**/*.coffee'],
        //  'build/js/<%= pkg.name %>-CS-engine.js': ['src/coffee/CS/engine/**/*.coffee'] }
      }
    },
    json: {
      props: {
        options: {
          namespace: 'props',
          processName: function(filename) {
            return filename;
          }
        },
        src: ['src/*.json'],
        dest: 'build/props.js'
      }
    },
    copy: {
      statics: {
        src: 'src/index.html',
        dest: 'build/index.html',
        options: {
          process: function(content, srcpath) {
            return grunt.template.process(content);
          }
        }
      },
      html: {
        files: [
          {
            expand: true,
            cwd: 'src/',
            src: ['html/**/*.html'],
            dest: 'build/'
          }
        ]
      },
      resources: {
        files: [
          {
            expand: true,
            cwd: 'src/',
            src: ['resources/**'],
            dest: 'build/'
          }
        ]
      },
      lib: {
        files: [
          {
            expand: true,
            src: ['lib/**/*.js'],
            dest: 'build/'
          }
        ]
      }
    },
    watch: {
      configFiles: {
        files: ['Gruntfile.coffee'],
        options: {
          reload: true
        }
      },
      coffee: {
        files: ['src/**/*.coffee'],
        tasks: ['coffee']
      },
      json: {
        files: ['src/**/*.json'],
        tasks: ['json']
      },
      copy: {
        files: ['src/**/*.html', 'src/resources/**/*'],
        tasks: ['copy']
      }
    },
    clean: ["build"],
    jshint: {
      js: ["build/js/**/*.js"]
    },
    concurrent: {
      build: ['browserDependencies', 'coffee', 'json'],
      exampleTarget2: ['jshint', 'mocha']
    }
  });
  grunt.loadNpmTasks('grunt-browser-dependencies');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-json');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-concurrent');
  return grunt.registerTask('default', ['clean', 'concurrent:build', 'copy']);
};

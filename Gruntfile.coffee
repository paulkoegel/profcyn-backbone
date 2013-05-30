#grunt.registerTask 'setGlobal', 'Set a global variable.', (name, val) ->
#global['name'] = val

# grunt-connect-rewrite
rewriteRulesSnippet = require('grunt-connect-rewrite/lib/utils').rewriteRequest

devTasks = ['set_global', 'clean:dev', 'copy:dev', 'haml:dev_html', 'haml:dev_haml_coffee', 'coffee:dev', 'markdown:dev', 'html_json_wrapper:dev', 'insert_json_to_dom:dev']
prodTasks = ['clean:prod', 'copy:prod', 'haml:prod_html', 'haml:prod_haml_coffee', 'coffee:prod', 'markdown:prod', 'html_json_wrapper:prod', 'compass:prod', 'concat:prod', 'closure-compiler:prod', 'insert_json_to_dom:prod', 'cssmin:prod', 'cachebust', 'clean:prod_js']

# can't use 'source/javascripts/**' for this as the loading sequence is important
filesToLoad = (path) ->
  if path?
    basePath = "#{path}/"
  else
    basePath = ''
  files = [
    'vendor/jquery.js'
    'vendor/underscore.js'
    'vendor/backbone.js'
    'vendor/backbone.marionette.js'
    'vendor/marionette_renderer.js'
    'vendor/swipe.js'
    'vendor/jquery.imagesloaded.js'
    'app_init.js'
    'collections/galleries.js'
    'models/gallery.js'
    'routers/app_router.js'
    'controllers/sessions_controller.js'
    'views/layouts/app.js'
    'views/login_view.js'
    'views/navigation_view.js'
    'templates/layouts/app.js'
    'templates/login.js'
    'templates/navigation.js'
    # "#{basePath}javascripts/templates/navigation.js"
  ]
  result = []
  i = 0
  while i < files.length
    result.push("#{basePath}javascripts/#{files[i]}")
    i++
  result

# console.log global
# global.grunt.sourceFiles = filesToLoad('grunt_dev')

module.exports = (grunt) ->
  grunt.initConfig
    connect:
      server:
        options:
          middleware: (connect, options) ->
            [
              rewriteRulesSnippet, # RewriteRules support
              connect.static(require('path').resolve(options.base)) # mount filesystem
            ]
          base: './grunt_dev'
          hostname: null # required to call the server via IP, e.g. from a local mobile device (documentation says to use '*', but this says to stick with null for now:  https://github.com/gruntjs/grunt-contrib-connect/issues/21)
          port: 3000
          keepalive: true # without this the server process would close immediately after a successful start; you can then not chain any task behind connect, however
      rules:
        '^/login$': '/'

    clean:
      dev:
        files: [
          # can't clean /grunt_dev/**/* because we need the stylesheets created by the separate Compass process we use for development. Excluding a single folder didn't work, last i looked, see Github issue below.
          { src: [
              './grunt_dev/content/**',
              './grunt_dev/images/**',
              './grunt_dev/javascripts/**',
              './grunt_dev/index.html'
            ]
            , filter: 'isFile' # this line MUST start with a comma; reason for this option: prevent 'Cannot delete files outside the current working directory.' error, see: https://github.com/gruntjs/grunt-contrib-clean/issues/15#issuecomment-14301612
          }
        ]
      prod:
        files: [
          { src: [
              './grunt_prod/**/*'
            ]
            , filter: 'isFile'
          }
        ]
      prod_js: # clean up JS files not needed anymore after concatenation and minification - makes Dropbox deployment easier without all the unnecessary files
        options:
          force: true
        files: [
          { src: [
              './grunt_prod/javascripts/*', '!./grunt_prod/javascripts/application-*.min.js'
            ]
          }
        ]

    copy:
      dev:
        files: [
          { expand: true, cwd: 'source/', src: ['images/**'], dest: 'grunt_dev/' }
          { expand: true, cwd: 'source/', src: ['javascripts/**/*.js'], dest: 'grunt_dev/' }
          { expand: true, cwd: 'source/', src: ['content/**/*.html'], dest: 'grunt_dev/', flatten: true }
          { expand: true, cwd: 'source/', src: ['content/**/*.json'], dest: 'grunt_dev/content', flatten: true }
          { expand: true, cwd: 'source/', src: ['swf/**'], dest: 'grunt_dev/' }
          { expand: true, cwd: 'source/', src: ['fonts/**'], dest: 'grunt_dev/' }
          { expand: true, cwd: 'source/', src: ['videos/**'], dest: 'grunt_dev/' }
        ]
      prod:
        files: [
          { expand: true, cwd: 'source/', src: ['images/**'], dest: 'grunt_prod/' }
          { expand: true, cwd: 'source/', src: ['javascripts/**/*.js'], dest: 'grunt_prod/' }
          { expand: true, cwd: 'source/', src: ['content/**/*.html'], dest: 'grunt_prod/content', flatten: true }
          { expand: true, cwd: 'source/', src: ['content/**/*.json'], dest: 'grunt_prod/content', flatten: true }
          { expand: true, cwd: 'source/', src: ['swf/**'], dest: 'grunt_prod/' }
          { expand: true, cwd: 'source/', src: ['fonts/**'], dest: 'grunt_prod/' }
          { expand: true, cwd: 'source/', src: ['videos/**'], dest: 'grunt_prod/' }
        ]

    haml:
      dev_html:
        files:
          'grunt_dev/index.html': 'source/index_dev.haml'
        options:
          target: 'html'
          language: 'coffee'
      dev_haml_coffee:
        files:
          'grunt_dev/javascripts/templates/about.js': 'source/javascripts/templates/about.hamlc'
          'grunt_dev/javascripts/templates/contact.js': 'source/javascripts/templates/contact.hamlc'
          'grunt_dev/javascripts/templates/login.js': 'source/javascripts/templates/login.hamlc'
          'grunt_dev/javascripts/templates/navigation.js': 'source/javascripts/templates/navigation.hamlc'
          'grunt_dev/javascripts/templates/layouts/app.js': 'source/javascripts/templates/layouts/app.hamlc'
          'grunt_dev/javascripts/templates/projects/index.js': 'source/javascripts/templates/projects/index.hamlc'
          'grunt_dev/javascripts/templates/projects/show.js': 'source/javascripts/templates/projects/show.hamlc'
          'grunt_dev/javascripts/templates/projects/slide.js': 'source/javascripts/templates/projects/slide.hamlc'
        options:
          target: 'js'
          language: 'coffee'
          placement: 'global'
          namespace: 'window.JST'
      prod_html:
        files:
          'grunt_prod/index.html': 'source/index_prod.haml'
        options:
          target: 'html'
          language: 'coffee'
      prod_haml_coffee:
        files:
          'grunt_prod/javascripts/templates/about.js': 'source/javascripts/templates/about.hamlc'
          'grunt_prod/javascripts/templates/contact.js': 'source/javascripts/templates/contact.hamlc'
          'grunt_prod/javascripts/templates/navigation.js': 'source/javascripts/templates/navigation.hamlc'
          'grunt_prod/javascripts/templates/layouts/app.js': 'source/javascripts/templates/layouts/app.hamlc'
          'grunt_prod/javascripts/templates/projects/index.js': 'source/javascripts/templates/projects/index.hamlc'
          'grunt_prod/javascripts/templates/projects/show.js': 'source/javascripts/templates/projects/show.hamlc'
          'grunt_prod/javascripts/templates/projects/slide.js': 'source/javascripts/templates/projects/slide.hamlc'
        options:
          target: 'js'
          language: 'coffee'
          placement: 'global'
          namespace: 'window.JST'

    coffee:
      dev:
        expand: true
        cwd: 'source/'
        src: ['javascripts/**/*.coffee']
        dest: 'grunt_dev/'
        ext: '.js'
      prod:
        expand: true
        cwd: 'source/'
        src: ['javascripts/**/*.coffee']
        dest: 'grunt_prod/'
        ext: '.js'

    watch:
      dev:
        files: [
          './source/images/**',
          './source/javascripts/**',
          './source/content/**',
          './source/index_dev.haml',
          './Gruntfile.coffee'
        ]
        tasks: devTasks

    markdown:
      dev:
        files: ['source/content/**/*.mdown']
        dest: 'grunt_dev/content/' # is there any way to preserve folder structure?
        template: 'source/markdown_template.html'
        options:
          gfm: false
          highlight: 'manual'
          codeLines:
            before: '<span>'
            after: '</span>'
      prod:
        files: ['source/content/**/*.mdown']
        # is there any way to preserve folder structure?
        dest: 'grunt_prod/content/'
        template: 'source/markdown_template.html'
        options:
          gfm: false
          highlight: 'manual'
          codeLines:
            before: '<span>'
            after: '</span>'

    html_json_wrapper:
      dev:
        options: {}
        files:
          'grunt_dev/content/projects.json': [
            'grunt_dev/content/project_a.html'
          ]
      prod:
        options: {}
        files:
          'grunt_prod/content/projects.json': [
            'grunt_dev/content/project_a.html'
          ]

    compass:
      prod:
        options:
          config: 'compass_prod_config.ru'
          sassDir: 'source/stylesheets'
          cssDir: 'grunt_prod/stylesheets'
          importPath: 'source'
          noLineComments: true
          force: true
          debugInfo: false
          outputStyle: 'compressed'
          imagesDir: 'source/images'
          relativeAssets: true
          environment: 'production'

    concat:
      options:
        separator: ';'
      prod:
        src: filesToLoad('grunt_prod')
        dest: 'grunt_prod/javascripts/application.js'

    uglify:
      prod:
        preserveComments: false
        files:
          'grunt_prod/javascripts/application.min.js': ['grunt_prod/javascripts/application.js']

    'closure-compiler':
      prod:
        closurePath: '/usr/local/opt/closure-compiler/libexec' || process.env.CLOSURE_PATH || 'vendor/bin/google_closure_compiler'
        js: 'grunt_prod/javascripts/application.js'
        jsOutputFile: 'grunt_prod/javascripts/application.min.js'
        maxBuffer: 500
        options:
          compilation_level: 'SIMPLE_OPTIMIZATIONS'
          language_in: 'ECMASCRIPT5'

    cachebust:
      prod:
        files: [
          'grunt_prod/javascripts/application.min.js',
          'grunt_prod/stylesheets/application.min.css'
        ],
        # src file in which paths to the cachebusted files will be adjusted
        src:  'grunt_prod/index.html',
        dest: 'grunt_prod/index.html'

    insert_json_to_dom:
      dev:
        src: 'grunt_dev/index.html',
        dest: 'grunt_dev/index.html',
        jsonFile: 'grunt_dev/content/projects.json'
      prod:
        src: 'grunt_prod/index.html',
        dest: 'grunt_prod/index.html',
        jsonFile: 'grunt_prod/content/projects.json'

    cssmin:
      prod:
        files:
          'grunt_prod/stylesheets/application.min.css': ['grunt_prod/stylesheets/application.css']
        options:
          keepSpecialComments: 0

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-haml'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-markdown'
  grunt.loadNpmTasks 'grunt-html-json-wrapper'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-closure-compiler'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-connect-rewrite'
  grunt.loadTasks './tasks/'

  grunt.registerTask 'build:dev', devTasks
  grunt.registerTask 'build:prod', prodTasks
  grunt.registerTask 'default', ['watch:dev']
  #grunt.registerTask 'server', ['connect']

  # workaround with which we could call, e.g., grunt.file functions inside of HAML templates with `= global.grunt.file(...)`
  # not using this for now as the cachebusting task is more elegant and we have no further use for this; please keep for reference, though.
  # cf. http://gruntjs.com/frequently-asked-questions#globals-and-configs
  grunt.registerTask 'set_global', 'Set a global variable.', (name, val) ->
    global['grunt'] = grunt
    global.sourceFiles = filesToLoad()

  grunt.registerTask 'server', (target) ->
    grunt.task.run [
      'configureRewriteRules'
      'connect:server'
    ]

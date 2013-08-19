/*
 * This is not very flexible at the moment, and just relies
 * on grunt-shell to execute a number of ad-hoc commands.
 */
module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    less: {
      buildall: {
        options: {
          concat: false,
          compress: false,
          stripBanners: false,
          paths: ['css']
        },
        expand: true,
        cwd: 'css',
        src: '*.less',
        ext: '.css',
        dest: 'css'
      },
    },
    shell: {
      createTmpDir: {
        command: 'mkdir <%= buildTitle %>'
      },
      buildPDF: {
        command: 'source bin/activate && python collectiondbk2pdf.py -p /usr/local/bin/prince -d ./test-ccap/m-<%= buildTitle %>/ -s ccap-<%= buildTitle %> -t <%= buildTitle %>/ ./<%= buildTitle %>/<%= buildTitle %>.pdf',
        options: {
          stdout: true
        },
      },
      cleanXHTML: {
        command: 'cd <%= buildTitle %> && xmllint --format collection.xhtml > <%= buildTitle %>.xhtml && mv <%= buildTitle %>.xhtml collection.xhtml'
      },
      copyCSS: {
        command: 'cp css/ccap-<%= buildTitle %>.css <%= buildTitle %>'
      },
      injectStylesheet: {
        command: 'sed -i -e \'s#</head>#<link rel="stylesheet" type="text/css" href="ccap-<%= buildTitle %>.css" /></head>#\' <%= buildTitle %>/collection.xhtml'
      }
    }
  });

  grunt.loadNpmTasks('assemble-less');
  grunt.loadNpmTasks('grunt-shell');

  grunt.registerTask('lessc', ['less']);

  grunt.registerTask('createBuildDir', 'Creates a build directory for a book.', function(n) {
    grunt.task.requires('lessc');

    var book = grunt.option('book');

    grunt.log.writeln('Creating output directory for ' + book + '/');
    grunt.task.run('shell:createTmpDir');
  });

  grunt.registerTask('buildpdf', 'Runs python scripts to produce a PDF.', function(n) {
    grunt.task.requires('createBuildDir');

    grunt.task.run('shell:buildPDF');
  });

  grunt.registerTask('prepareXHTML', 'Prepares XHTML for viewing/debugging.', function(n) {
    grunt.task.requires('buildpdf');

    grunt.log.writeln('Cleaning the XHTML and injecting the stylesheet.');
    grunt.task.run('shell:cleanXHTML');
    grunt.task.run('shell:copyCSS');
    grunt.task.run('shell:injectStylesheet');
  });

  grunt.registerTask('build', 'Build a given book.', function(n) {
    var book = grunt.option('book');
    if (book == undefined) {
        grunt.fatal('Provide a --book=parameter in order to build a specific book.');
        return false;
    }

    grunt.config.set('buildTitle', book);

    grunt.log.writeln('Compiling LESS...');
    grunt.task.run('lessc');

    grunt.task.run('createBuildDir');
    grunt.task.run('buildpdf');
    grunt.task.run('prepareXHTML');
  });
}

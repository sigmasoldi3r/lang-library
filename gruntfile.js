module.exports = function (grunt) {
  grunt.loadNpmTasks('grunt-run');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-mkdir');

  grunt.initConfig({
    run: {
      options: {},
      moonc: {
        cmd: 'moonc',
        args: [
          '-t',
          'build',
          'src'
        ]
      }
    },
    copy: {
      main: {
        files: [
          {expand: true, cwd: 'lua/', src: ['**'], dest: 'dist/'},
          {expand: true, cwd: 'build/src', src: ['**'], dest: 'dist/'}
        ]
      }
    },
    clean: ['dist', 'build', 'temp'],
    mkdir: {
      output: {
        create: ['dist', 'build']
      },
      temp: {
        create: ['temp']
      }
    }
  });

  grunt.registerTask('default', ['build']);
  grunt.registerTask('build', ['mkdir:output', 'clean', 'run:moonc', 'copy:main']);
};

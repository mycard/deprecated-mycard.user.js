module.exports = (grunt)->
	grunt.initConfig
		coffee:
			compileJoined:
				options:
					join: on
				files:
					"mycard.user.js" : "src/*.coffee"
		watch:
			scripts:
				files: ['src/*.coffee']
				tasks: ['coffee', 'concat']
		concat:
			options:
				separator: "\r\n"
			dist:
				src: ['define.js', 'mycard.user.js', 'src/*.js']
				dest: 'mycard.user.js'

	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-concat'

	grunt.registerTask 'default', ['coffee', 'concat', 'watch']

using build

class Build : BuildPod {

	new make() {
		podName = "ex1"
		summary = "My Awesome ex1 Project"
		version = Version("1.0")

		meta = [
			"proj.name" : "ex1"
		]

		depends = [
			"sys 1.0"
		]

		srcDirs = [`fan/`]
		resDirs = [,]

		docApi = true
		docSrc = true
	}
}

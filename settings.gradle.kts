include("adobe-webhook")
rootProject.name = "otc-aws"

rootProject.children.forEach {
    it.buildFileName = "${it.name}.gradle.kts"
}
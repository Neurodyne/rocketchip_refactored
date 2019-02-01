resolvers ++= Seq(
  Resolver.mavenLocal,
  Resolver.sonatypeRepo("snapshots"),
  Resolver.sonatypeRepo("releases"),
)

resolvers += "Sonatype OSS Releases" at "https://oss.sonatype.org/service/local/staging/deploy/maven2"

addSbtPlugin("com.typesafe.sbt" % "sbt-ghpages" % "0.6.3")

addSbtPlugin("com.typesafe.sbt" % "sbt-site" % "1.3.2")

addSbtPlugin("com.eed3si9n" % "sbt-buildinfo" % "0.9.0")

addSbtPlugin("org.xerial.sbt" % "sbt-pack" % "0.11")

addSbtPlugin("com.eed3si9n" % "sbt-unidoc" % "0.4.2")

addSbtPlugin("org.scoverage" % "sbt-scoverage" % "1.5.1")

//addSbtPlugin("org.scalastyle" %% "scalastyle-sbt-plugin" % "1.0.0")

// Automatic Formatting Tool -Automatic text format in all sources and tests
//addSbtPlugin("org.scalariform" % "sbt-scalariform" % "1.8.2")

// Easy and Powerful Linting with HTML output 
addSbtPlugin("com.sksamuel.scapegoat" %% "sbt-scapegoat" % "1.0.9")

// Yet another linting tool
//addSbtPlugin("org.wartremover" % "sbt-wartremover" % "2.4.1")

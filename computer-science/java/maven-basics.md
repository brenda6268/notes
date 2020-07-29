# Maven 基础

<!--
ID: 4a108572-35ef-4c58-b214-e6e75677c818
Status: draft
Date: 2018-04-04T05:57:00
Modified: 2018-04-04T05:57:00
wp_id: 545
-->

From: http://tutorials.jenkov.com/maven/maven-tutorial.html

## Introduction

Maven is built around the pom.xml file. In Maven, how to build your project is predefined in the Maven Build Life Cycles, Phases and Goals.  The POM file describes *what to build*, but most often *not how to build it*. How to build it is up to the Maven build phases and goals.

# Minimal POM file
Here is a minimal POM file: 

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                      http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
	<groupId>com.jenkov</groupId>
    <artifactId>java-web-crawler</artifactId>
    <version>1.0.0</version>
</project>
```

this outputs MAVEN_REPO/com/jenkov/java-web-crawler/1.0.0/java-web-crawler-1.0.0.jar

## Super POM

You can make a POM file explicitly inherit from another POM file. That way you can change the settings across all inheriting POM's via their common super POM. You specify the super POM at the top of a POM file like this: 

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                      http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <parent>
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>my-parent</artifactId>
        <version>2.0</version>
        <relativePath>../my-parent</relativePath>
    </parent>
    
	<artifactId>my-project</artifactId>
    ...
</project>
```

mvn help:effective-pom shows the combined pom of parent and current

## Running Maven

When executing the mvn command you pass the name of a build life cycle, phase or goal to it, which Maven then executes.

syntax: mvn phase:goal

# Directory Structure
You must follow the maven directory structure

```
- src
  - main
    - java
    - resources
    - webapp
  - test
    - java
    - resources
- target
```

## Dependencies

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
   http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.jenkov.crawler</groupId>
    <artifactId>java-web-crawler</artifactId>
    <version>1.0.0</version>
    
 <dependencies>
    <dependency>
        <groupId>org.jsoup</groupId>
        <artifactId>jsoup</artifactId>
        <version>1.7.1</version>
    </dependency>

    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.8.1</version>
        <scope>test</scope>
    </dependency>
</dependencies>
    
<build>
</build>
</project>
```

## external dependencies

```xml
<dependency>
  <groupId>mydependency</groupId>
  <artifactId>mydependency</artifactId>
  <scope>system</scope>
  <version>1.0</version>
  <systemPath>${basedir}\war\WEB-INF\lib\mydependency.jar</systemPath>
</dependency>
```

## snapshot dependencies

Snapshot dependencies are dependencies (JAR files) which are under development. 

`<version>1.0-SNAPSHOT</version>`


# Repositories

maven tries to pull dependencies from local, central, and remote repo

## Local Repositores

it's defined in ~/.m2/settings.xml

```xml
<settings>
    <localRepository>
        d:\data\java\products\maven\repository
    </localRepository>
</settings>
```

## Central Repositories

Maintained by the maven community

## Remote Repositories

A remote repository is often used for hosting projects internal to your organization, which are shared by multiple projects.

```xml
<repositories>
   <repository>
       <id>jenkov.code</id>
       <url>http://maven.jenkov.com/maven2/lib</url>
   </repository>
</repositories>
```

# Maven Build Cycles

When Maven builds a software project it follows a build life cycle. The build life cycle is divided into build phases, and the build phases are divided into build goals.
Since you cannot execute the default life cycle directly, you need to execute a build phase or goal from the default life cycle. 

1. default 

    validate	Validates that the project is correct and all necessary information is available. This also makes sure the dependencies are downloaded.
    compile	Compiles the source code of the project.
    test	Runs the tests against the compiled source code using a suitable unit testing framework. These tests should not require the code be packaged or deployed.
    package	Packs the compiled code in its distributable format, such as a JAR.
    install	Install the package into the local repository, for use as a dependency in other projects locally.
    deploy	Copies the final package to the remote repository for sharing with other developers and projects.

2. clean
3. site

# Profiles

Profiles let you use differvent build settings
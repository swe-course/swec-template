
properties([
  parameters([
    string(name: 'COMPONENT_PARAM_HOST', defaultValue: '127.0.0.1'),
    string(name: 'COMPONENT_PARAM_LSTN', defaultValue: '0.0.0.0'),
    string(name: 'COMPONENT_PARAM_PORT', defaultValue: '9082'),
    string(name: 'COMPONENT_PARAM_PORTS', defaultValue: '9444'),
    string(name: 'SONARQUBE_SERVER', defaultValue: 'SonarQube'),
    string(name: 'SONARQUBE_SCANNER', defaultValue: 'SonarQubeScanner'),
    string(name: 'SONARQUBE_ACCESS_TOKEN', defaultValue: "${SWEC_SONARQUBE_ACCESS_TOKEN}"),
    string(name: 'GITHUB_ACCESS_TOKEN', defaultValue: "${SWEC_GITHUB_ACCESS_TOKEN}"),
    string(name: 'NEXUS_HOST', defaultValue: "${SWEC_NEXUS_HOST}"),
    string(name: 'NEXUS_REPO', defaultValue: "${SWEC_NEXUS_REPO}"),
    string(name: 'NEXUS_USER', defaultValue: "${SWEC_NEXUS_USER}"),
    string(name: 'NEXUS_PASS', defaultValue: "${SWEC_NEXUS_PASS}")
  ])
])

def configBuildEnvironment(configFile) {
  def tools = [
    'openjdk': ['envs':['JAVA_HOME'], 'paths':['/bin'], 'validate':'java -version'],
    'nodejs': ['envs':['NODEJS_HOME'], 'paths':['/bin'], 'validate':'node -v'],
    'maven': ['envs':['MAVEN_HOME', 'M2_HOME'], 'paths':['/bin'], 'validate':'mvn -v']
  ]
  def config = [:]
  if (fileExists(configFile)) {
    print("Use Configuration from ${configFile}")
    config = readJSON file: configFile
  }else{
    print('Default VM setup will be used')
  }
  printTopic('Build environment config')
  print(config)
  // configure
  config.each { prop, val -> 
    if (tools[prop]) {
      try {
        def t = tool "${val}"
        sh "echo Configuring ${prop} using ${val} version"

        tools[prop].envs.each { e ->
          env[e] = "${t}"
        }
        tools[prop].paths.each { p ->
          env.PATH = "${t}${p}:${env.PATH}"
        }
      } catch (e) {
        sh "echo Tool ${prop} [${val}] is not available at this instance"
      }
      // validate setup
      sh "${tools[prop].validate}"
    }
  }
}

def sendEmailNotification(subj, recepients) {
    emailext body: "${BUILD_URL}",
    recipientProviders: [
      [$class: 'CulpritsRecipientProvider'],
      [$class: 'DevelopersRecipientProvider'],
      [$class: 'RequesterRecipientProvider']
    ],
    subject: subj,
    to: "${recepients}"
}
def printTopic(topic) {
  println("[*] ${topic} ".padRight(80, '-'))
}

node {
  //
  def pullRequest = false
  def commitSha = ''
  def buildBranch = ''
  def pullId = ''
  def lastCommitAuthorEmail = ''
  def repo = ''
  def org = ''
  def uploadArtifacts = env.NEXUS_HOST && env.NEXUS_REPO && env.NEXUS_USER && env.NEXUS_PASS
  //
  stage('Clone sources') {
    //
    def scmVars = checkout scm
    printTopic('Job input parameters');
    println(params)
    printTopic('SCM variables')
    println(scmVars)
    // configure build env
    configBuildEnvironment('build.conf.json');
    //
    commitSha = scmVars.GIT_COMMIT
    buildBranch = scmVars.GIT_BRANCH
    if (buildBranch.contains('PR-')) {
      pullRequest = true
      pullId = CHANGE_ID
    } else if (params.containsKey('sha1')){
      pullRequest = true
      pullId = ghprbPullId
    } else {
    }
    //
    printTopic('Build info')
    echo "[PR:${pullRequest}] [BRANCH:${buildBranch}] [COMMIT: ${commitSha}] [PULL ID: ${pullId}]"
    printTopic('Environment variables')
    echo sh(returnStdout: true, script: 'env')
    //
    org = sh(returnStdout: true, script:'''git config --get remote.origin.url | rev | awk -F'[./:]' '{print $2}' | rev''').trim()
    repo = sh(returnStdout: true, script:'''git config --get remote.origin.url | rev | awk -F'[./:]' '{print $1}' | rev''').trim()
    //
    printTopic('Repo parameters')
    echo sh(returnStdout: true, script: 'git config --get remote.origin.url')
    echo "[org:${org}] [repo:${repo}]"
    //
    lastCommitAuthorEmail = sh(returnStdout: true, script:'''git log --format="%ae" HEAD^!''').trim()
    if (!pullRequest){
      lastCommitAuthorEmail = sh(returnStdout: true, script:'''git log -2 --format="%ae" | paste -s -d ",\n"''').trim()
    }
    printTopic('Author(s)')
    echo "[lastCommitAuthorEmail:${lastCommitAuthorEmail}]"
  }
  //
  stage('Build') {
    //
    dir('services/api') {
      sh "mvn clean install"
    }
    //
  }
  //
  stage('Unit tests') {
    /*/
    /*/
  }
  //
  stage('SonarQube analysis') {
    //
    printTopic('Sonarqube properties')
    echo sh(returnStdout: true, script: 'cat sonar-project.properties')
    def scannerHome = tool "${SONARQUBE_SCANNER}"
    withSonarQubeEnv("${SONARQUBE_SERVER}") {
      if (pullRequest){
        sh "${scannerHome}/bin/sonar-scanner -Dsonar.analysis.mode=preview -Dsonar.github.pullRequest=${pullId} -Dsonar.github.repository=${org}/${repo} -Dsonar.github.oauth=${GITHUB_ACCESS_TOKEN} -Dsonar.login=${SONARQUBE_ACCESS_TOKEN}"
      } else {
        sh "${scannerHome}/bin/sonar-scanner -Dsonar.login=${SONARQUBE_ACCESS_TOKEN}"
        // check SonarQube Quality Gates
        //// Pipeline Utility Steps
        def props = readProperties  file: '.scannerwork/report-task.txt'
        echo "properties=${props}"
        def sonarServerUrl=props['serverUrl']
        def ceTaskUrl= props['ceTaskUrl']
        def ceTask
        //// HTTP Request Plugin
        timeout(time: 1, unit: 'MINUTES') {
          waitUntil {
            def response = httpRequest "${ceTaskUrl}"
            println('Status: '+response.status)
            println('Response: '+response.content)
            ceTask = readJSON text: response.content
            return (response.status == 200) && ("SUCCESS".equals(ceTask['task']['status']))
          }
        }
        //
        def qgResponse = httpRequest sonarServerUrl + "/api/qualitygates/project_status?analysisId=" + ceTask['task']['analysisId']
        def qualitygate = readJSON text: qgResponse.content
        echo qualitygate.toString()
        if ("ERROR".equals(qualitygate["projectStatus"]["status"])) {
          currentBuild.description = "Quality Gate failure"
          error currentBuild.description
        }
      }
    }
    //
  }
  //
  stage('Delivery') {
    //
    if (uploadArtifacts) {
      if (pullRequest){
      } else {
        sh "./upload.sh"
      }
      // archiveArtifacts artifacts: 'path/2/artifact'
    }
    //
  }
}
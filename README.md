# Angular (7) skeleton application

## Getting started

### Attach to the existing project

* Add skeleton as subtree
```
git remote add tln-angular https://github.com/project-talan/tln-angular.git
git subtree add --prefix static/html tln-angular master --squash
```
* Update to get latest version
```
git subtree pull --prefix static/html tln-angular master --squash
```

### or Fork/clone repository

To develop standalone project, just clone repository or create fork using your account

### Refresh configuration
* run **prereq.sh** script
* Update environment variables inside **.env** file
```
COMPONENT_ID=io.company.project
COMPONENT_VERSION=19.4.0

COMPONENT_PARAM_HOST=company.io
COMPONENT_PARAM_LSTN=0.0.0.0
COMPONENT_PARAM_PORT=80
COMPONENT_PARAM_PORTS=443
```
* replace all accurencies of string **'org.talan.angular'** to you project id (for example **'io.company.project'**) inside **angular.json** file


### HTTP/HTTPS

* During deployment procedure, create ssl folder under project's root with two sertificates. Use your project id as files' names
```
  io.company.project.key
  io.company.project.crt
```
* otherwise, **http** access will be configured


## SDLC


| Script  | Description |
| ------------- | ------------- |
| prereq.sh | Prepare local dev box configuration scripts |
| init.sh | install npm dependencies |
| build.sh |  |
| lint.sh |  |
| serve.sh |  |
| sonar.sh | Run SonarQube static cide analysis |
| test.sh |  |
| build-prod.sh | Build production version |
| docker-build.sh |  |
| docker-load.sh |  |
| docker-run.sh |  |
| docker-save.sh |  |
| docker-stop.sh |  |


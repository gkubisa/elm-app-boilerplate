# Elm App Boilerplate

[![Run Status](https://api.shippable.com/projects/572133332a8192902e1e2958/badge?branch=master)](https://app.shippable.com/projects/572133332a8192902e1e2958)

Provides an efficient development workflow and a starting point for building Elm applications.


## Features

- automated build of all application resources using [webpack](http://webpack.github.io/)
- Hot Module Replacement for the Elm code using [elm-hot-loader](https://github.com/fluxxu/elm-hot-loader)
- automatic re-execution of tests on source change for Elm and JavaScript code
- test coverage using [istanbul](https://github.com/gotwarlost/istanbul) for the JavaScript tests
- JavaScript code written in ES6, transpiled using [Babel](https://babeljs.io/)
- JavaScript linted using [eslint](http://eslint.org/)
- building and running a [Docker](https://www.docker.com/) image
- continuous integration and deployment based on [Shippable](https://app.shippable.com/)
- dependency checking using [npm-check-updates](https://github.com/tjunnone/npm-check-updates)


## Getting Started

Fork and clone this repo.

```
npm install
npm start
```

Open `http://localhost:8080/` in a browser.

For an alternative host or port run:

```
npm start -- --host=0.0.0.0 --port=8081
```

## Testing

Run tests once off:

```
npm test # Elm and JavaScript tests
npm run test:elm # only Elm tests
npm run test:js # only JavaScript tests
```

Restart the tests on code change:

```
npm run tdd # Elm and JavaScript tests
npm run tdd:elm # only Elm tests
npm run tdd:js # only JavaScript tests
```


## Deployment

The deployment is automated using Shippable and is triggered as follows:

1. Run `npm version [major|minor|patch]` on the `master` branch.
2. Add release notes in GitHub.

On success:

- a new docker image is pushed to [elm-app-boilerplate on Docker Hub](https://hub.docker.com/r/gkubisa/elm-app-boilerplate/)
- the demo app is deployed to [elm-app-boilerplate GitHub Pages](http://gkubisa.github.io/elm-app-boilerplate/)

### Custom Deployments

Consider using `npm run release` as a base - it builds the app, creates a docker image, and then tags and pushes it to Docker Hub.

Alternatively use the output of the `npm run build` command which stores all the optimized application files in `./dist`.


## Updating Version

This project customizes the standard `npm version` script to also:

- ensure that the dependencies are up to date
- execute all tests
- update the version in `elm-package.json`
- push the branch on which the version change was made
- push the created tag


## Updating Dependencies

Dependeny check and update is handled by [ncu](https://github.com/tjunnone/npm-check-updates). A check runs automatically every time `npm version` is executed but can also be triggered explicitly.

```
npm run ncu # checks the dependencies in package.json
npm run ncu -- -a # updates all dependencies in node_modules and package.json
```

Note: all `ncu` parameters and flags have to be specified after `--`.


## Elm Commands

The following Elm commands are exposed through npm scripts:

- `npm run elm`
- `npm run elm-reactor`
- `npm run elm-repl`
- `npm run elm-package`
- `npm run elm-make`
- `npm run elm-test`

The parameters to those commands must be specified after `--`, for example: `npm run elm-package -- install evancz/elm-effects`. See [npm run-script](https://docs.npmjs.com/cli/run-script).


## Directory Structure

### General

- `package.json` - defines dependencies and scripts for building, testing and running the application
- `dist/` - built application artifacts produced by `npm run build`
- `coverage/` - JavaScript test coverage reports
- `shippable.yml` - configuration of the continuous integration and deployment process based on Shippable

### Elm

- `elm-package.json` - describes the Elm application and its dependencies
- `elm/` - Elm source files
- `elm/Main.elm` - Elm application entry point
- `elm/App/` - the namespace for all application Elm modules
- `elm-test/` - directory containing all Elm tests
- `elm-test/TestRunner.elm` - the entry point for executing tests and bootstrapping the actual test runner
- `elm-test/Tests.elm` - the main file loading and exposing all the test suites

### JavaScript

- `js/` - contains all application JavaScript code
- `js/main.js` - entry point to the application JavaScript code
- `js-test/` - directory containing all JavaScript tests
- `js-test/test.js` - entry point for JavaScript tests - automatically loads all `*.test.js` files in `js-test`

### HTML

- `html/index.html` - overall application entry point

### Docker

- `Dockerfile` - instructions for building a docker image
- `config` - configuration for the services embedded in the docker image


## Docker

This section describes the Docker-related commands which are used by the Shippable continuous integration and deployment process. Docker version 1.11.1 or later is required.

Creating a docker image containing a copy of the `./dist` directory which is served by [nginx](https://www.nginx.com/) on port 80:

```
npm run docker-build
```

Pushing the created docker image to Docker Hub with the tag `latest`:

```
npm run docker-push
```

Testing the created docker image locally:

```
npm run docker-run # creates and starts a Docker container
# the app is now available at http://localhost:8081

npm run docker-start # starts an existing container
npm run docker-stop # stops an existing container
npm run docker-rm # removes an existing, stopped container
```

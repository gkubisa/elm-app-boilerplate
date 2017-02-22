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

On success, the demo app is deployed to [elm-app-boilerplate GitHub Pages](http://gkubisa.github.io/elm-app-boilerplate/).


## Build Configuration Using Environment Variables

The default environment variables used by the build scripts are defined in the `.env` file. The defaults are always overridden by the variables defined in the environment. They are useful for abstracting away the differences between the development and production platforms. For example, the following command builds the application with a custom `BASE_PATH` suitable for deployment to GitHub Project Pages.

```
BASE_PATH=/elm-app-boilerplate npm run build
```

The environment variables are first available to the `webpack.config.babel.js` script, so that the build itself can be parameterized. From there, the variables can be passed to JavaScript using [DefinePlugin](https://webpack.github.io/docs/list-of-plugins.html#defineplugin), and from JavaScript to Elm using [flags](http://package.elm-lang.org/packages/elm-lang/html/1.1.0/Html-App#programWithFlags).

Currently the following variables are supported:

- `BASE_PATH` - defines the location of the generated JS and CSS files, and is prepended to all pathnames handled by the Elm application.


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

- `.editorconfig` - configures the white space rules for text editors
- `.env` - defines the default environment variables used by `webpack`
- `.gitignore` - defines files and directories ignored by `git` 
- `.npmrc` - configuration for `npm`, currently used to provide a message template for `npm version`
- `package.json` - defines dependencies and scripts for building, testing and running the application
- `shippable.yml` - configuration of the continuous integration and deployment process based on Shippable
- `webpack.config.babel.js` - webpack configuration used for building and running the application
- `dist/` - built application artifacts produced by `npm run build`

### Elm

- `elm-package.json` - describes the Elm application and its dependencies
- `elm/` - Elm source files
- `elm/Main.elm` - Elm application entry point
- `elm/TestRunner.elm` - the entry point for executing tests and bootstrapping the actual test runner
- `elm/App/` - the namespace for all application Elm modules
- `elm/App/Etc/` - contains configuration modules
- `elm/App/Etc/Tests.elm` - the main file loading and exposing all the test suites
- `elm/App/Etc/Config.elm` - the Elm app configuration
- `elm/App/Section/` - contains all sections. A section groups related pages and manages routing within its group.
- `elm/App/Section/<SomeSection>/Route.elm` - contains route mappings and helpers for `<SomeSection>`
- `elm/App/Page/` - contains all pages. A page is responsible for the main content of its section.
- `elm/App/Widget/` - contains all reusable widgets
- `elm/App/**/<SomeModule>/Test.elm` - contains tests for `<SomeModule>`

### JavaScript

- `.babelrc` - configures the JavaScript babel transpiler
- `.eslintrc.test.yml` - eslint config for JavaScript tests
- `.eslintrc.yml` - eslint config for JavaScript application code
- `karma.conf.js` - Krama configuration used for running the JavaScript tests in a browser
- `coverage/` - JavaScript test coverage reports
- `js/` - contains JavaScript code
- `js/main.js` - entry point to the application JavaScript code
- `js/tests.js` - entry point for JavaScript tests - automatically loads all `*.test.js` files in `js/`

### HTML

- `html-minifier.json` - configuration file used by the `html-minifier`
- `html/index.html` - overall application entry point

### Styles

- `styles/App/` - contains styles for all components
- `styles/Config.less` - global LESS variables defining things like the color scheme, breakpoints for media queries, font sizes, etc
- `styles/Global.less` - some universally applicable styles for HTML elements
- `styles/Main.less` - the entry point for the LESS compiler
- `styles/Util.less` - reusable LESS mixins

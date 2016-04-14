# Elm App Boilerplate

Provides an efficient development workflow and a starting point for building Elm applications.

## Features

- easy to use npm scripts
- automated build of all application resources using [webpack](http://webpack.github.io/)
- Hot Module Replacement for the Elm code using [elm-hot-loader](https://github.com/fluxxu/elm-hot-loader)
- automatic re-execution of tests on source change
- [Semantic UI](http://semantic-ui.com/) integration

## Getting Started

Fork and clone this repo.

```
npm install
npm start
```

Open `http://localhost:8080/` in a browser.

## Preparing for Deployment

```
npm run build
```

The application code ready for deployment will be stored in `./dist`.

## Testing

Once off

```
npm test
```

Restart the tests on code change

```
npm run tdd
```

## Updating Version

Use the standard `npm version` command. This project contains npm scripts which also:

- update the version in `elm-package.json`
- push the branch on which the version change was made
- push the created tag

## Elm Commands

The following Elm commands are exposed through npm scripts:

- `npm run elm-reactor`
- `npm run elm-repl`
- `npm run elm-package`
- `npm run elm-make`
- `npm run elm-test`

The parameters to those commands must be specified after `--`, for example: `npm run elm-package -- install evancz/elm-effects`. See [npm run-script](https://docs.npmjs.com/cli/run-script).

## Directory Structure

### General

- `package.json` - defines dependencies and scripts for building and running the application
- `dist/` - built application artifacts produced by `npm run build`

### Elm

- `elm-package.json` - describes the Elm application and its dependencies
- `src/` - Elm source files
- `src/Main.elm` - Elm application entry point
- `src/App/` - the namespace for all application Elm modules
- `test/` - directory containing all the tests
- `test/TestRunner.elm` - the entry point for executing tests and bootstrapping the actual test runner
- `test/Tests.elm` - the main file loading and exposing all the test suites

### Semantic UI

- `styles/` - all the application styles
- `styles/theme.config` - specifies which theme to use for each components
- `styles/site/` - project-specific configuration and overrides

#### Semantic UI (auto-generated)

These files and  directories are copied from `semantic-ui-less` node module by the `postinstall` script.

- `styles/definitions/` - Semantic UI component definitions
- `styles/themes/` - Semantic UI themes
- `styles/semantic.less` - includes all Semantic UI components
- `styles/theme.less` - internal theme loading helper

### JavaScript

- `scripts/` - contains all application JavaScript code
- `scripts/main.js` - entry point to the application JavaScript code
- `scripts/semantic-ui/` - scripts for Semantic UI integration

### HTML

- `html/index.html` - overall application entry point


## Semantic UI

Semantic UI provides a lot of ready-made, customizable UI components and helps to implement the design of the application quickly and consistently. It was included in `elm-app-boilerplate` because it integrates nicely with Elm.

The main idea behind the integration is that Elm handles all the application logic, integration with the backend and rendering of the HTML. Semantic UI on the other hand is responsible for making the application look nice on the screen.

### Integration

Semantic UI `globals`, `views`, `collections` and `elements` are defined using LESS only (except for `globals/site.js` which handles the global configuration), so they work seamlessly with Elm out of the box.

The `modules` require some JavaScript to work and must be initialized by the application. However, some (if not all) `modules` can be automatically managed in JavaScript in a way that is completely transparent to the Elm code. The demo page of `elm-app-boilerplate` contains some examples of that technique. _Pull requests with examples for other `modules` welcome!_

The `behaviors` would certainly be the most difficult to integrate, however, they are probably also the least likely to be useful to an Elm application. Specifically, the interaction with the backend (`API` behaviour) is better handled in Elm. `Form validation` could be useful, however, [Elm validation](https://github.com/etaque/elm-simple-form) is also available. The `visibility` behaviour is the one which cannot be easily done in Elm, so the integration might be worth the effort.

### Usage

The application can be styled using the following techniques, in order of preference:

1. Select suitable themes for the components by modifying `styles/theme.config`.
2. Configure the Semantic UI variables in `styles/site/**/*.variables`.
3. Add custom LESS code to modify some components in `styles/site/**/*.overrides`.
4. Add any other custom LESS code to `styles/site/globals/site.overrides`.

Please refer to [Semantic UI](http://semantic-ui.com/) documentation for more details, including defining your own reusable themes.

# Elm App Boilerplate

Provides an efficient development workflow and a starting point for building Elm applications.

## Features

- easy to use npm scripts
- automated build of all application resources
- JavaScript and CSS minification
- automatic rebuild and reload on source change
- automatic re-execution of tests on source change
- [Semantic UI](http://semantic-ui.com/) integration

## Getting Started

Fork and clone this repo.

```
npm install
npm start
```

Open `http://localhost:3000/` in a browser.

Start coding! :-)

The application files are automatically rebuilt on code change and stored in `./dist`. That directory is then served by `browser-sync`, which also reloads the browser on any file change.

## Preparing for Deployment

```
npm run build
```

The application code ready for deployment will be stored in `./dist`.

**Even though the minified versions of all the necessary scripts and styles are produced, index.html always references the non-minified ones. Make sure you modify those references before creating the production build.**

## Testing

Once off

```
npm test
```

Restart the tests on code change

```
npm run tdd
```

## Directory Structure

- `package.json` - used mostly for build and deployment support
- `elm-package.json` - describes the Elm application and its dependencies
- `semantic.json` - the main Semantic UI configuration file
- `dist/` - built application artifacts, used by both `npm start` and `npm run build`
- `test/` - directory containing all the tests
- `test/TestRunner.elm` - the entry point for executing tests, bootstraps the actual test runner
- `test/Tests.elm` - the main file loading and exposing all the test suites
- `src/` - all source files
- `src/index.html` - overall application entry point
- `src/Main.elm` - Elm application entry point
- `src/ElmAppBoilerplate` - the namespace for all `elm-app-boilerplate` Elm modules
- `src/definitions/` - Semantic UI component definitions
- `src/themes/` - Semantic UI themes
- `src/site/` - Semantic UI variables and overrides for this application
- `src/theme.config` - defines which theme to use for each Semantic UI component
- `src/semantic.less` and `src/theme.less` - other Semantic UI files
- `tasks` and `gulpfile.js` - gulp scripts for building Semantic UI

## Integration with Semantic UI

Semantic UI provides a lot of ready-made, customizable UI components and helps to implement the design of the application quickly and consistently. It was included in `elm-app-boilerplate` because it integrates nicely with Elm.

The main idea behind the integration is that Elm handles all the application logic, integration with the backend and rendering of the HTML. Semantic UI on the other hand is responsible for making the application look nice on the screen.

Semantic UI `globals`, `views`, `collections` and `elements` are defined using LESS only, so they work seamlessly with Elm out of the box.

The `modules` require some JavaScript to work and must be initialized by the application. However, some (if not all) `modules` can be automatically managed in JavaScript in a way that is completely transparent to the Elm code. The demo page of `elm-app-boilerplate` contains some examples of that technique. _Pull requests with examples for other `modules` welcome!_

The `behaviors` would certainly be the most difficult to integrate, however, they are probably also the least likely to be useful to an Elm application. Specifically, the interaction with the backend (`API` behaviour) is better handled in Elm. `Form validation` could be useful, however, [Elm validation](https://github.com/etaque/elm-simple-form) is also available. The `visibility` behaviour is the one which cannot be easily done in Elm, so the integration might be worth the effort.

**`elm-app-boilerplate` is currently configured to include all Semantic UI components. Make sure you remove the unnecessary components before deploying your application to production.**

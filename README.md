# Elm App Boilerplate

Elm application boilerplate providing an efficient development workflow.

## Getting Started

Fork and clone this repo.

```
npm install
npm start
```

Open `http://localhost:3000/` in a browser.

Start coding! :-)

The application files are automatically rebuilt on code change and stored in `./public`. That directory is then served by `browser-sync`, which also reloads the browser on any file change.

## Preparing for Deployment

```
npm run build
```

The application code ready for deployment will be stored in `./public`.

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

- `scripts/` - build and deployment helper scripts
- `public/` - built application artifacts, used by both `npm start` and `npm run build`
- `src/` - all source files
- `src/index.html` - overall application entry point
- `src/Main.elm` - Elm application entry point
- `src/styles/` - all styles
- `src/images/` - all images
- `src/scripts/` - any JavaScript files, supporting the main Elm application, if needed
- `elm-package.json` - describes the Elm application and its dependencies
- `package.json` - used mostly for build and deployment support

## TODO

- build JavaScript in `src/scripts/`
- set up tests

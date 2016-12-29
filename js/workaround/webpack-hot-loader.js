// a workaround for https://github.com/webpack/webpack-dev-server/issues/216
const base = document.createElement('base')
base.href = window.location.origin
document.head.appendChild(base)

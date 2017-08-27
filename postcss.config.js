module.exports = ({ file, options, env }) => ({
  plugins: {
    'autoprefixer': env == 'production' ? {} : false,
    'cssnano': env == 'production' ? {} : false
  }
})

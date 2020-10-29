const { environment } = require('@rails/webpacker')

const webpack = require('webpack')

environment.plugins.prepend(
  'MomentContextReplacement',
  new webpack.ContextReplacementPlugin(/moment[\/\\]locale$/, /en|es/)
)

environment.plugins.append('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default'],
  })
)

module.exports = environment

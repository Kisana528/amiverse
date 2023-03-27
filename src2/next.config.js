/** @type {import('next').NextConfig} */

const withPWA = require("next-pwa")({
  dest: 'public',
  register: true,
  skipWaiting: true,
})

module.exports = withPWA({
  images: {
    domains: ['localhost','amiverse.net', '192.168.0.4'],
  },
  async rewrites() {
    return [
      {
        source: '/@:name_id',
        destination: '/accounts/:name_id'
      }
    ]
  }
})
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
        destination: '/accounts/:name_id/account'
      },
      {
        source: '/@:name_id/ap',
        destination: '/accounts/:name_id/ap'
      },
      {
        source: '/@:name_id/outbox',
        destination: '/api/accounts/:name_id/outbox'
      },
      {
        source: '/@:name_id/inbox',
        destination: '/api/accounts/:name_id/inbox'
      },
      {
        source: '/inbox',
        destination: '/api/inbox'
      }
    ]
  }
})
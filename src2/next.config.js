/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  async rewrites() {
    return [
      {
        source: '/@:name_id',
        destination: '/accounts/:name_id'
      }
    ]
  }
}

module.exports = nextConfig

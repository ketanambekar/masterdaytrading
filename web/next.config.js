/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  env: {
    NEXT_PUBLIC_UPSTOX_API_URL: 'https://api.upstox.com/v3',
    NEXT_PUBLIC_UPSTOX_TOKEN: '0e239d4b-55da-4aa6-9f9f-7e335ed273cb',
    NEXT_PUBLIC_ENABLE_ADS: 'false',
  },
}

module.exports = nextConfig

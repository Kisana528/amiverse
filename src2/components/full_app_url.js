function FullAppUrl(path) {
  const host = process.env.NEXT_PUBLIC_APPNAME
  const url = new URL(path, host)
  return url
}

export default FullAppUrl
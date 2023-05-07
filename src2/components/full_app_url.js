function FullAppUrl(path) {
  const host = process.env.NEXT_PUBLIC_APPNAME
  const url = `${host}${path}`
  return url
}

export default FullAppUrl
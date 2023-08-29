export async function getServerSideProps({req, res, context, query}) {
  const xml = `
    <?xml version="1.0" encoding="UTF-8"?>
    <XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0">
      <Link rel="lrdd" type="application/xrd+xml"
        template="https://amiverse.net/.well-known/webfinger?resource={uri}"/>
    </XRD>
  `

  res.setHeader('Content-Type', 'text/xml')
  res.write(xml)
  res.end()
  return { props: {} }
}

export default function HostMeta() {}
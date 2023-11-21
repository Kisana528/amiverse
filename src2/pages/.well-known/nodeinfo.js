import axios from '@/lib/axios'
import FullAppUrl from '@/components/full_app_url'

export async function getServerSideProps({ req, res, context, query }) {
  const data = {
    "links":[{
      "rel":"http://nodeinfo.diaspora.software/ns/schema/2.0",
      "href":"https://amiverse.net/nodeinfo/2.0"
    },
    {
      "rel":"http://nodeinfo.diaspora.software/ns/schema/2.1",
      "href":"https://amiverse.net/nodeinfo/2.1"
    }
  ]
  }
  res.setHeader('Content-Type', 'application/json')
  res.write(JSON.stringify(data))
  res.end()
  return { props: {} }
}

export default function Nodeinfo() { }
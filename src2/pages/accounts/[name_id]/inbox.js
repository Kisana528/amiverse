export async function getServerSideProps({req, res, context, query}) {
  const data = {
    "@context":"https://www.w3.org/ns/activitystreams",
    "summary": "inbox desu.",
    "type": "OrderedCollection",
    "totalItems": 0,
    "orderedItems": []
  }

  res.setHeader('Content-Type', 'application/activity+json; charset=utf-8')
  res.write(JSON.stringify(data))
  res.end()
  return { props: {} }
}

export default function Inbox() {}
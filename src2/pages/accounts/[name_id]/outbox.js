import axios from '@/lib/axios'

export async function getServerSideProps(req, res, context, query) {
  let accountData
  if (query.name_id) {
    await axios.post('http://app:3000/v1/@' + query.name_id)
      .then(res => {
        accountData = res.data
        console.log(accountData.items.length)
      })
      .catch(err => {
        //アカウント取得例外
      })
  }

  const data = {
    "@context": "https://www.w3.org/ns/activitystreams",
    "summary": "outbox desu.",
    "type": "OrderedCollection",
    "totalItems": 1,
    "orderedItems": 
      accountData.items.map(item => ({
        "@context": "https://www.w3.org/ns/activitystreams",
        "type": "Create",
        "id": `https://amiverse.net/items/${item.item_id}`,
        "url": `https://amiverse.net/items/${item.item_id}`,
        "published": item.created_at,
        "to": [
          `https://amiverse.net/${accountData.name_id}/followers`,
          "https://www.w3.org/ns/activitystreams#Public"
        ],
        "actor": `https://amiverse.net/${accountData.name_id}`,
        "object": {
          "@context": "https://www.w3.org/ns/activitystreams",
          "type": "Note",
          "id": `https://amiverse.net/items/${item.item_id}`,
          "url": `https://amiverse.net/items/${item.item_id}`,          "published": "2023-01-16T06:48:29Z",
          "to": [
            `https://amiverse.net/${accountData.name_id}/followers`,
            "https://www.w3.org/ns/activitystreams#Public"
          ],
          "attributedTo": `https://amiverse.net/${accountData.name_id}/followers`,
          "content": item.content
        }
      }))
  }

  res.setHeader('Content-Type', 'application/activity+json; charset=utf-8')
  res.write(JSON.stringify(data))
  res.end()
  return { props: {} }
}

export default function Outbox() {}
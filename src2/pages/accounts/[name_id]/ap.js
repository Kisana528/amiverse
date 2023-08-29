import axios from '@/lib/axios'
import FullAppUrl from '@/components/full_app_url'

export async function getServerSideProps({req, res, context, query}) {
  let accountData = {}
  //問い合わせ
  await axios.post('http://app:3000/v1/@' + query.name_id)
    .then(res => {
      accountData = res.data
    })
    .catch(err => {
      accountData = res.data
    })
  const data = {
    "@context": [
      "https://www.w3.org/ns/activitystreams",
      "https://w3id.org/security/v1"
    ],
    type: "Person",
    id: FullAppUrl(`@${accountData.name_id}`),
    url: FullAppUrl(`@${accountData.name_id}`),
    tag: [],
    published: accountData.created_at,
    discoverable: true,
    attachment: [],
    manuallyApprovesFollowers: true,
    name: accountData.name,
    summary: "",
    icon: {
      type: 'Image',
      mediaType: 'image/webp',
      url: accountData.icon_url
    },
    preferredUsername: accountData.name_id,
    inbox: FullAppUrl(`@${accountData.name_id}/inbox`),
    outbox: FullAppUrl(`@${accountData.name_id}/outbox`),
    followers: FullAppUrl(`@${accountData.name_id}/followers`),
    following: FullAppUrl(`@${accountData.name_id}/following`),
    publicKey: {
      id: `https://amiverse.net/@${accountData.name_id}#main-key`,
      owner: `https://amiverse.net/@${accountData.name_id}`,
      publicKeyPem: accountData.public_key
    }
  }

  res.setHeader('Content-Type', 'application/activity+json; charset=utf-8')
  res.write(JSON.stringify(data))
  res.end()
  return { props: {} }
}

export default function Outbox() {}
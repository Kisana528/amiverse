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
      "https://w3id.org/security/v1",
      {
        "manuallyApprovesFollowers": "as:manuallyApprovesFollowers",
        "sensitive": "as:sensitive",
        "Hashtag": "as:Hashtag",
        "quoteUrl": "as:quoteUrl",
        "toot": "http://joinmastodon.org/ns#",
        "Emoji": "toot:Emoji",
        "featured": "toot:featured",
        "discoverable": "toot:discoverable",
        "schema": "http://schema.org#",
        "PropertyValue": "schema:PropertyValue",
        "value": "schema:value",
        "misskey": "https://misskey-hub.net/ns#",
        "_misskey_content": "misskey:_misskey_content",
        "_misskey_quote": "misskey:_misskey_quote",
        "_misskey_reaction": "misskey:_misskey_reaction",
        "_misskey_votes": "misskey:_misskey_votes",
        "isCat": "misskey:isCat",
        "vcard": "http://www.w3.org/2006/vcard/ns#"
      }
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
      id: FullAppUrl(`@${accountData.name_id}#main-key`),
      owner: FullAppUrl(`@${accountData.name_id}`),
      publicKeyPem: accountData.public_key
    }
  }

  res.setHeader('Content-Type', 'application/activity+json; charset=utf-8')
  res.write(JSON.stringify(data))
  res.end()
  return { props: {} }
}

export default function Outbox() {}
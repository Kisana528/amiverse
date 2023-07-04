export async function getServerSideProps({req, res, context, query}) {
  const data = {
    "@context":["https://www.w3.org/ns/activitystreams",
      "https://w3id.org/security/v1",
      {
        "manuallyApprovesFollowers":"as:manuallyApprovesFollowers",
        "sensitive":"as:sensitive",
        "Hashtag":"as:Hashtag",
        "quoteUrl":"as:quoteUrl",
        "toot":"http://joinmastodon.org/ns#",
        "Emoji":"toot:Emoji",
        "featured":"toot:featured",
        "discoverable":"toot:discoverable",
        "schema":"http://schema.org#",
        "PropertyValue":"schema:PropertyValue",
        "value":"schema:value",
        "misskey":"https://misskey-hub.net/ns#",
        "_misskey_content":"misskey:_misskey_content",
        "_misskey_quote":"misskey:_misskey_quote",
        "_misskey_reaction":"misskey:_misskey_reaction",
        "_misskey_votes":"misskey:_misskey_votes",
        "isCat":"misskey:isCat",
        "vcard":"http://www.w3.org/2006/vcard/ns#"
      }
    ],
    "id":"https://amiverse.net/@kisana/outbox",
    "type":"OrderedCollection",
    "totalItems":1,
    "first":"https://amiverse.net/@kisana/ap",
    "last":"https://amiverse.net/@kisana/ap"
  }

  res.setHeader('Content-Type', 'application/json')
  res.write(JSON.stringify(data))
  res.end()
  return { props: {} }
}

export default function Outbox() {}
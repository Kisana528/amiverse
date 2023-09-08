import axios from '@/lib/axios'
import FullAppUrl from '@/components/full_app_url'

export async function getServerSideProps({req, res, context, query}) {
  let { resource } = query
  let name_id = ''
  let domain = ''
  let accountStatus = false
  let domainStatus = false

  if (resource.startsWith("acct:")) {
    resource = resource.substring(5);
  }
  if (resource.includes('@')) {
    const parts = resource.split('@');
    if (parts.length === 3) {
      domain = parts.pop();
      name_id = parts.pop();
    } else if (parts.length === 2) {
      if (resource.startsWith('@')) {
        name_id = parts[1];
      } else {
        name_id = parts[0];
        domain = parts[1];
      }
    } else if (parts.length === 1) {
      name_id = parts[0];
    }
  } else {
    name_id = resource;
  }
  //問い合わせ
  await axios.post('http://app:3000/v1/@' + name_id)
    .then(res => {
      accountStatus = true
    })
    .catch(err => {
      accountStatus = false
    })
  if (!domain || domain === 'amiverse.net') {
    domainStatus = true
  }
  if(accountStatus && domainStatus){
    const data = {
      subject: `acct:${name_id}@amiverse.net`,
      aliases: [FullAppUrl(`@${name_id}`)],
      links: [
        {
          "rel":"self",
          "type":"application/activity+json",
          "href":FullAppUrl(`accounts/${name_id}/ap`)
        }
      ]
    }
    res.setHeader('Content-Type', 'application/jrd+json; charset=utf-8')
    res.write(JSON.stringify(data))
  } else {
    res.statusCode = 400;
  }
  res.end()
  return { props: {} }
}

export default function Webfinger() {}
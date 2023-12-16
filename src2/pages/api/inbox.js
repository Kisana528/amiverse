import axios from '@/lib/axios'

export default function handler(req, res) {
  let data = {'default':'value'}
  if (req.method === "POST") {
    data.received_at = 'inbox'
    data.headers = JSON.parse(JSON.stringify(req.headers))
    data.body = JSON.parse(JSON.stringify(req.body))
    axios.post('http://app:3000/v1/activitypub/inbox', JSON.stringify(data))
    .then(res => {
      console.log(res.data)
    })
    .catch(err => {
      //例外
    })
  } else {
    data = {'error':'Request you sent was not POST. This program is not support Activity Pub cliant.'}
  }

  res.setHeader('Content-Type', 'application/activity+json; charset=utf-8')
  res.write(JSON.stringify(data))
  res.end()
}

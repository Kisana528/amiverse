import axios from '@/lib/axios'

export default function handler(req, res) {
  let data = {'default':'value'}
  if (req.method === "POST") {
    data.received_at = String(`@${req.query.name_id}`)
    data.headers = JSON.parse(JSON.stringify(req.headers))
    data.body = JSON.parse(JSON.stringify(req.body))
    axios.post('http://app:3000/v1/activitypub/inbox', JSON.stringify(data))
    .then(res => {
    })
    .catch(err => {
      //例外
    })
  } else {
    data = {'error':'Request you sent was not POST. This program is not support Activity Pub cliant.'}
  }

  res.setHeader('Content-Type', 'application/json')
  res.write(JSON.stringify(data))
  res.end()
}

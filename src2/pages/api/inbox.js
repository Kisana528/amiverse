import axios from '@/lib/axios'

export default async function handler(req, res) {
  let req_data = {'default':'value'}
  let res_data = {'status':'Error:Data was not send to API.'}
  if (req.method === "POST") {
    req_data.received_at = 'inbox'
    req_data.headers = JSON.parse(JSON.stringify(req.headers))
    req_data.body = JSON.parse(JSON.stringify(req.body))
    await axios.post('http://app:3000/v1/activitypub/inbox', JSON.stringify(req_data))
    .then(res => {
      res_data.status = res.data.status
    })
    .catch(err => {
      //例外
      res_data = {'status':'Error:Cannot received API response.'}
    })
  } else {
    res_data = {'status':'Error:Request you sent was not POST. This program is not support Activity Pub cliant.'}
  }

  res.setHeader('Content-Type', 'application/json')
  res.write(JSON.stringify(res_data))
  res.end()
}

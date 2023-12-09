import axios from '@/lib/axios'

export default async function handler(req, res) {
  let data = {'inbox':'content'}
  let to_url_res = {'default':'data'}
  if (req.method === "POST") {
    if (req.headers['content-type'] == 'application/json'){
      console.log('content-type: OK')
      if (req.headers.authorization == 'Bearer token-here'){
        console.log('認証OK')
        data = req.body
        console.log(data.to_url, data.body)
        await axios.post(data.to_url, data.body, {headers: data.headers})
        .then(res => {
          console.log('--------res-----------')
          console.log(res.data)
          to_url_res = res.data
        })
        .catch(err => {
          console.log('--------err-----------')
          console.log(err.response.data)
          to_url_res = err.response.data
        })
      } else {
        console.log('認証NG')
      }
    } else {
      console.log('content-type: NG')
    }
  } else {
    data = {'error':'Request you sent was not POST. This program is not support Activity Pub cliant.'}
  }

  res.setHeader('Content-Type', 'application/activity+json; charset=utf-8')
  res.write(JSON.stringify(to_url_res))
  res.end()
}
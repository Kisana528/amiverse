import axios from '@/lib/axios'
import FullAppUrl from '@/components/full_app_url'

export default async function handler(req, res) {
  //const accept = req.headers.accept
  //const isActivity = accept.includes('application/activity+json')
  let res_data = {'status':'Error:Data was not send to API.'}
  if(req.method === "GET"){
    let accountData = {}
    await axios.post('http://app:3000/v1/@' + req.query.name_id + '/following')
      .then(res => {
        accountData = res.data
      })
      .catch(err => {
        accountData = err.data
      })
    res_data = {
      following: accountData.following
    }
  } else {
    res_data = {'status':'Error:Request you sent was not POST. This program is not support Activity Pub cliant.'}
  }
  
  res.setHeader('Content-Type', 'application/json')
  res.write(JSON.stringify(res_data))
  res.end()
}
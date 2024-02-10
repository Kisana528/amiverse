import axios from '@/lib/axios'
import FullAppUrl from '@/components/full_app_url'

export default async function handler(req, res) {
  //const accept = req.headers.accept
  //const isActivity = accept.includes('application/activity+json')
  let res_data = {'status':'Error:Data was not send to API.'}
  if(req.method === "GET"){
    let data = {}
    /*console.log(req.query)
    // ページング
    let page = 1
    if (page = req.query.page){
      // 内容
    }
    */
    await axios.post('http://app:3000/v1/@' + req.query.name_id + '/followers')
      .then(res => {
        data = res.data
      })
      .catch(err => {
        data = err.data
      })
    res_data = {
      "@context": "https://www.w3.org/ns/activitystreams",
      type: "Collection",
      id: `https://amiverse.net/@${data.name_id}/followers`,
      totalItems: data.count,
      items: [
        `https://amiverse.net/@${data.name_id}`
      ]
    }
  } else {
    res_data = {'status':'Error:Request you sent was not POST. This program is not support Activity Pub cliant.'}
  }
  
  res.setHeader('Content-Type', 'application/json')
  res.write(JSON.stringify(res_data))
  res.end()
}
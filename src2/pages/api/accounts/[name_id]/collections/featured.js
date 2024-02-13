import axios from '@/lib/axios'
import FullAppUrl from '@/components/full_app_url'

export default async function handler(req, res) {
  let res_data = { 'status': 'Error:Data was not send to API.' }
  if (req.method === "GET") {
    res_data = {
      "@context": "https://www.w3.org/ns/activitystreams",
      id: FullAppUrl(req.query.name_id + '/outbox'),
      type: "OrderedCollection",
      totalItems: 0,
      orderedItems: []
    }
  } else {
    res_data = { 'status': 'Error:Request you sent was not POST. This program is not support Activity Pub cliant.' }
  }
  res.setHeader('Content-Type', 'application/json')
  res.write(JSON.stringify(res_data))
  res.end()
}
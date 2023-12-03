import axios from '@/lib/axios'

export default function handler(req, res) {
  const data = req.body
  
  //axios
  /*axios.post('http://app:3000/v1/@' + query.name_id)
    .then(res => {
      accountData = res.data
      console.log(accountData.items.length)
    })
    .catch(err => {
      //アカウント取得例外
    })*/
    res.write(JSON.stringify({'status': 'ok'}))
  res.status(200).json({
    status: 'OK!'
  })
}

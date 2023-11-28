import axios from '@/lib/axios'

export default function handler(req, res) {
  const data = JSON.parse(JSON.stringify(req.body))
  const normalObject = Object.assign({}, req.body)
  console.log(req.body)

  //axios
  /*axios.post('http://app:3000/v1/@' + query.name_id)
    .then(res => {
      accountData = res.data
      console.log(accountData.items.length)
    })
    .catch(err => {
      //アカウント取得例外
    })*/
  res.status(200).json({ status: 'OK!',
    data
  })
}

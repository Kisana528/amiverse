import axios from '@/lib/axios'
import { useRouter } from 'next/router'
import qs from 'querystring'

export async function getServerSideProps({req, res, context, query}) {
  //const body = await parseBody(req, '1mb');
  //if (req.method === 'POST') {
    //await getBody(req, res)
    //console.log(req.body)
  //s}
  const streamPromise = new Promise((resolve, reject) => {
    let postBody = '';

    req.on('data', (data) => {
      // convert Buffer to string
      postBody += data.toString();
      console.log(data)
      console.log(JSON.parse(postBody))
      console.log(JSON.stringify(postBody))
    });

    req.on('end', () => {
      console.log('Received POST data:', postBody)
      const postData = qs.parse(postBody);
      resolve(postData);
    });
  });
  const posted_data = await streamPromise;
  console.log(posted_data)
  res.setHeader('Content-Type', 'application/activity+json; charset=utf-8')
  res.write(JSON.stringify({'status': 'ok'}))
  res.end()
  return { props: {} }
}

export default function Inbox() {}
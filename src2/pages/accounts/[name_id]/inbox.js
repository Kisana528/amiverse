import axios from '@/lib/axios'

export async function getServerSideProps({req, res, context, query}) {
  console.log(req.body)
  res.setHeader('Content-Type', 'application/activity+json; charset=utf-8')
  res.write(JSON.stringify({'status': 'ok'}))
  res.end()
  return { props: {} }
}

export default function Inbox() {}
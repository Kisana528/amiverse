export async function getServerSideProps({req, res, context, query}) {
  const data = { id: 1232, name: query.name_id}

  res.setHeader('Content-Type', 'application/json')
  res.write(JSON.stringify(data))
  res.end()
  return { props: {} }
}

export default function Outbox() {}
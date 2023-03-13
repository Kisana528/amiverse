import React, { useEffect, useState } from 'react'
import axios from '../lib/axios'
import Link from 'next/link'

export default function Home() {
  const [items, setItems] = useState([])
  let ignore = false
  useEffect(() => {
    if (!ignore) {
      const fetchItems = async () => {
        const response = await axios.get('/api/items')
        console.log(response.data)
        const data = response.data
        setItems(data)
      }
      fetchItems()
    }
    return () => {ignore = true}
  },[])
  return (
    <>
      <main>
        <h1>Amiverse.net</h1>
        <Link href="/login">ログイン</Link>
        <ul>
          {items.map(item => (
            <li key={item.id}>{item.content}</li>
          ))}
        </ul>
      </main>
    </>
  )
}

import React, { useEffect, useState } from 'react'

export default function Home() {
  const [items, setItems] = useState([])
  useEffect(() => {
    const fetchItems = async () => {
      const response = await fetch('http://localhost:3000/api/items')
      const data = await response.json()
      setItems(data)
    }
    fetchItems()
  },[])
  return (
    <>
      <main>
        <h1>Amiverse.net</h1>
        <a>aa</a>
        <ul>
          {items.map(item => (
            <li key={item.id}>{item.content}</li>
          ))}
        </ul>
      </main>
    </>
  )
}

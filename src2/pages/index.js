import React, { useEffect, useState, useContext } from 'react'
import axios from '@/lib/axios'
import Link from 'next/link'
import Canvas from '@/components/canvas'
import {appContext} from '@/pages/_app'

export default function Home() {
  const loggedIn = useContext(appContext).loggedIn
  const [items, setItems] = useState([])
  let ignore = false
  useEffect(() => {
    if (!ignore && loggedIn) {
      const fetchItems = async () => {
        const response = await axios.get('/api/items')
        const data = response.data
        setItems(data)
      }
      fetchItems()
      async function created(){
        const ActionCable = await import('actioncable')
        const cable = ActionCable.createConsumer(process.env.NEXT_PUBLIC_WSNAME)
        cable.subscriptions.create( "ItemsChannel",{
          connected() {
            console.log('connected')
          },
          disconnected() {
            console.log('disconnected')
          },
          received(data) {
            let li = document.createElement("li")
            li.textContent = data.item.content
            document.getElementById('items').appendChild(li)
            return console.log(data['item']['content'])
          }
        })
      }
      created()
    }
    return () => {ignore = true}
  },[loggedIn])

  if(loggedIn){
    return (
      <>
        <h1>HOME</h1>
        <p>投稿一覧</p>
        <ul id="items">
          {items.map(item => (
            <li key={item.id}>{item.content}</li>
          ))}
        </ul>
        <Canvas></Canvas>
      </>
    )
  } else {
    return (
      <>
        <h1>Amiverse.netへようこそ！</h1>
        <Link href="/login">ログイン</Link>
        <Link href="/signup">登録</Link>
        <Link href="/@kisana">き</Link>
      </>
    )
  }
}
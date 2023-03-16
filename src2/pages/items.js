import React, { useEffect, useState, useContext } from 'react'
import axios from '../lib/axios'
import Link from 'next/link'
import Canvas from '@/components/canvas'
import {appContext} from './_app'

export default function Items() {
  const loggedIn = useContext(appContext).loggedIn
  const [items, setItems] = useState([])
  let ignore = false
  useEffect(() => {
    if (!ignore) {
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
            // Called when the subscription is ready for use on the server
            console.log('connected : ', this)
          },
          disconnected() {
            // Called when the subscription has been terminated by the server
          },
          received(data) {
            // Called when there's incoming data on the websocket for this channel
            let div = document.createElement("div")
            div.id = data.item.id
            div.textContent = data.item.content
            document.getElementById('items').appendChild(div)
            return console.log(data['item']['content'])
          }
        })
      }
      created()
    }
    return () => {ignore = true}
  },[])
  return (
    <main>
      <h1>items</h1>
      <div id="items"></div>
      <ul>
        {items.map(item => (
          <li key={item.id}>{item.content}</li>
        ))}
      </ul>
      <Canvas></Canvas>
    </main>
  )
}

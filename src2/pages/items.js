import React, { useEffect, useState, useContext } from 'react'
import axios from '../lib/axios'
import {appContext} from './_app'
import Item from '@/components/item_account'
import Post from '@/components/post'

export default function Items() {
  const loggedIn = useContext(appContext).loggedIn
  const [items, setItems] = useState([])
  let ignore = false

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
        const new_items = [...items, data]
        setItems((prevItems)=>([...prevItems, data]))
      }
    })
  }
  useEffect(() => {
    if (!ignore) {
      const fetchItems = async () => {
        const response = await axios.get('/items')
        const data = response.data
        setItems(data)
      }
      fetchItems()
      created()
    }
    return () => {ignore = true}
  },[])
  return (
    <div className="main-container">
      <h1>items</h1>
      <div id="items">
        {items.map(item => (
          <Item key={item.item_id} item={item} />
        ))}
      </div>
      <Post />
      <style jsx>{`
        .main-container {
          background: var(--main-container-background-color);
          padding: 5px;
        }
        .items {
        }
      `}</style>
    </div>
  )
}

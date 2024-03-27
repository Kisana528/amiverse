import React, { useEffect, useState, useContext, useRef } from 'react'
import axios from '@/lib/axios'
import Link from 'next/link'
import {appContext} from '@/pages/_app'
import ItemAccount from '@/components/item_account'
import {MaterialSymbols10k, MaterialSymbolsHomeRounded, JisakuMenuBar} from '@/lib/svg'
import HeaderText from '@/components/header_text'
import Video from '@/components/video'

export default function Home() {
  const loggedIn = useContext(appContext).loggedIn
  const loginFormTrigger = useContext(appContext).loginFormTrigger
  const setFlash = useContext(appContext).setFlash
  const [loadItems, setloadItems] = useState(true)
  const [items, setItems] = useState([])
  const [page, setPage] = useState(1)

  let ignore = false
  useEffect(() => {
    if (!ignore && loggedIn) {
      const fetchItems = async () => {
        await axios.post('/tl', { 'page': page })
          .then(res => {
            setItems(res.data)
            setloadItems(false)
          })
          .catch(err => {
            setFlash('アイテム取得エラー')
            //err.response.status
            setloadItems(false)
          })
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
    }
    return () => {ignore = true}
  },[loggedIn])

  const loggedInContent = (
    <>
      <div>
        <MaterialSymbols10k width="2em" height="2em" />
        <MaterialSymbolsHomeRounded width="2em" height="2em" />
        <JisakuMenuBar width="2em" height="2em" />
      </div>
      <div>
        {loadItems ?
          <p>Loading...</p>
          :
          items.length > 0 ?
            items.map(item => (
              <ItemAccount key={item.aid} item={item} />
            ))
          :
          <p>Nothing Here</p>
        }
      </div>
    </>
  )
  const elseContent = (
    <>
      <div>
        Amiverse.netへようこそ！
        <br />
        <div onClick={loginFormTrigger}>ログイン</div>
        <br />
        <Link href="/signup">登録</Link>
        <br />
        <Link href="/@kisana">@kisana</Link>
        <br />
      </div>
    </>
  )
  let content
  if (loggedIn) {
    content = loggedInContent
  } else {
    content = elseContent
  }

  return (
    <>
      <HeaderText
        headerText={'Home'}
      >
        {content}
      </HeaderText>
    </>
  )
}

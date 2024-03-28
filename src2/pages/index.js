import React, { useEffect, useState, useContext, useRef } from 'react'
import axios from '@/lib/axios'
import Link from 'next/link'
import {appContext} from '@/pages/_app'
import {MaterialSymbols10k, MaterialSymbolsHomeRounded, JisakuMenuBar} from '@/lib/svg'
import HeaderText from '@/components/header_text'
import Items from '@/components/items'

export default function Home() {
  const loggedIn = useContext(appContext).loggedIn
  const loading = useContext(appContext).loading
  const loginFormTrigger = useContext(appContext).loginFormTrigger
  const account = useContext(appContext).account
  const setFlash = useContext(appContext).setFlash
  const [loadItems, setloadItems] = useState(true)
  const [items, setItems] = useState([])
  const [page, setPage] = useState(1)

  useEffect(() => {
    if (!loading) {
      const fetchItems = async () => {
        await axios.post('/tl/current', { 'page': page })
          .then(res => {
            setItems(res.data)
            setloadItems(false)
          })
          .catch(err => {
            if (err.response.status == 401) {
              setFlash('タイムライン取得エラー:未ログイン')
            } else {
              setFlash('タイムライン取得エラー:不明')
            }
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
  },[loading])

  return (
    <>
      <HeaderText
        headerText={'Home'}
      >
        {(() => {
          if (loggedIn) {
            return (
              <div>
                こんにちは、{account.name}さん。
              </div>
            )
          } else {
            return (
              <div>
                Amiverse.netへようこそ！
                <div onClick={loginFormTrigger}>ログイン</div>
                <Link href="/signup">サインアップ</Link>
              </div>
            )
          }
        })()}
        <div>
          <MaterialSymbols10k width="2em" height="2em" />
          <MaterialSymbolsHomeRounded width="2em" height="2em" />
          <JisakuMenuBar width="2em" height="2em" />
        </div>
        <div>
          <Items items={items} loadItems={loadItems} />
        </div>
      </HeaderText>
    </>
  )
}

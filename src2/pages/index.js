import React, { useEffect, useState, useContext, useRef } from 'react'
import axios from '@/lib/axios'
import Link from 'next/link'
import {appContext} from '@/pages/_app'
import ItemAccount from '@/components/item_account'
import Hls from 'hls.js'
import {MaterialSymbols10k, MaterialSymbolsHomeRounded, JisakuMenuBar} from '@/lib/svg'

export default function Home() {
  const loggedIn = useContext(appContext).loggedIn
  const loginFormTrigger = useContext(appContext).loginFormTrigger
  const [loadItems, setloadItems] = useState(true)
  const [items, setItems] = useState([])

  let ignore = false
  useEffect(() => {
    if (!ignore && loggedIn) {
      const fetchItems = async () => {
        const response = await axios.post('/items')
        const data = response.data
        setItems(data)
        setloadItems(false)
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

  const videoRef = useRef(null)
  const video = videoRef.current
  const videoSrc = 'http://localhost:9000/development/variants/accounts/00000000000000/videos/xho6e3zyfd5g4w/output.m3u8'

  if (Hls.isSupported()) {
    const hls = new Hls()
    hls.loadSource(videoSrc)
    hls.attachMedia(video)
  }

  const loggedInContent = (
    <>
      <div>
        <Link href="/@kisana">@kisana</Link>
        <br />
        <Link href="/items">投稿を見る</Link>
        <br />

        <MaterialSymbols10k width="2em" height="2em" />
        <MaterialSymbolsHomeRounded width="2em" height="2em" />
        <JisakuMenuBar width="2em" height="2em" />

        <div className="video-view" >
          <video ref={videoRef} controls />
        </div>

      </div>
      <div>
        {loadItems ?
          <p>Loading...</p>
          :
          items.length > 0 ?
            items.map(item => (
              <ItemAccount key={item.item_id} item={item} />
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
      <div className="main-header">
        <div className="main-header-text">
          <Link href="/">Home</Link>
        </div>
      </div>
      <div className="main-container">
        {content}
      </div>
      <style jsx>{`
        .main-header {
          height: 50px;
          width: 100%;
          position: sticky;
          top: 0px;
          display: flex;
          justify-content: space-around;
          align-items: center;
          backdrop-filter: blur(3px);
          background: var(--blur-color);
        }
        .main-header-text {
          background: linear-gradient(90deg, #747eee, #d453cc 50%, #fe5597);
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
          font-size: 20px;
        }
        .main-container {
          background: var(--main-container-background-color);
          padding: 5px;
        }
        .video-view {
          width: 100%;
        }
      `}</style>
    </>
  )
}

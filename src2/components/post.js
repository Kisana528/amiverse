import React, { useState, useContext } from 'react'
import axios from '@/lib/axios'
import { appContext } from '@/pages/_app'

export default function Post() {
  const setFlash = useContext(appContext).setFlash
  const loggedIn = useContext(appContext).loggedIn
  const [content, setContent] = useState('')
  const [nsfw, setNsfw] = useState(false)
  const [cw, setCw] = useState(false)

  const handleSubmit = async (e) => {
    e.preventDefault()
    if (loggedIn) {
      await axios.post('/api/items/create', { content, nsfw, cw })
        .then(res => {
          if (res.data.success) {
            setFlash('投稿したよ')
            setContent('')
            setNsfw(false)
            setCw(false)
          } else {
            setFlash('間違った入力')
          }
        })
        .catch(err => {
          setFlash('投稿通信例外')
        })
    } else {
      setFlash('ろぐいんしてください')
    }
  }

  return (
    <>
      <div>
        <form onSubmit={handleSubmit}>
          <label>
            内容:
            <textarea value={content} onChange={(e) => setContent(e.target.value)} />
          </label>
          <br />
          <label>
            Nsfw:
            <input type="checkbox" checked={nsfw} onChange={(e) => setNsfw(!nsfw)} />
          </label>
          <br />
          <label>
            Cw:
            <input type="checkbox" checked={cw} onChange={(e) => setCw(!cw)} />
          </label>
          <br />
          <button type="submit">送信</button>
        </form>
      </div>
      <style jsx>{`
      `}</style>
    </>
  )
}